// Supabase Edge Function: Analyze Idea
// Performs semantic analysis on a green idea with all its comments and related facts
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { GoogleGenAI } from 'npm:@google/genai@1.29.0';
import { corsHeaders, extractJsonFromText } from '../_shared/utils.ts';
import { buildIdeaInsightPrompt } from '../_shared/prompts.ts';
Deno.serve(async (req) => {
    // Handle CORS preflight
    if (req.method === 'OPTIONS') {
        return new Response('ok', {
            headers: corsHeaders
        });
    }
    try {
        // Parse request
        const { session_id, green_idea_id } = await req.json();
        if (!session_id || !green_idea_id) {
            return new Response(JSON.stringify({
                error: 'Missing session_id or green_idea_id'
            }), {
                status: 400,
                headers: {
                    ...corsHeaders,
                    'Content-Type': 'application/json'
                }
            });
        }
        // Initialize Supabase client
        const supabaseUrl = Deno.env.get('SUPABASE_URL');
        const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY');
        const supabase = createClient(supabaseUrl, supabaseKey);
        // Initialize Gemini AI
        const apiKey = Deno.env.get('GEMINI_API_KEY');
        if (!apiKey) {
            throw new Error('Missing GEMINI_API_KEY');
        }
        const ai = new GoogleGenAI({
            apiKey
        });
        const model = 'gemini-2.5-flash-lite';
        // Fetch green idea with all related comments using database function
        const { data: ideaThreadData, error: threadError } = await supabase.rpc('get_idea_thread', {
            p_green_idea_id: green_idea_id
        });
        if (threadError) {
            throw new Error(`Failed to fetch idea thread: ${threadError.message}`);
        }
        if (!ideaThreadData) {
            throw new Error('Green idea not found');
        }
        // The database function returns the data in the correct structure
        const ideaThread = ideaThreadData;
        // Call correlate-ideas function to get related white facts
        // We'll make an internal call to the correlate-ideas endpoint
        const correlateUrl = `${supabaseUrl}/functions/v1/correlate-ideas`;
        const correlateResponse = await fetch(correlateUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${supabaseKey}`
            },
            body: JSON.stringify({
                session_id,
                green_idea_id
            })
        });
        let relatedWhiteFacts = [];
        if (correlateResponse.ok) {
            const correlateData = await correlateResponse.json();
            relatedWhiteFacts = (correlateData.result?.kept_white_facts || []).map((f) => ({
                id: f.id,
                input: f.fact
            }));
        } else {
            console.warn('Failed to fetch related white facts, continuing without them');
        }
        // Build prompt for semantic analysis
        const prompt = buildIdeaInsightPrompt(ideaThread, relatedWhiteFacts);
        // Call Gemini AI
        const response = await ai.models.generateContent({
            model,
            contents: [
                {
                    role: 'user',
                    parts: [
                        {
                            text: prompt
                        }
                    ]
                }
            ]
        });
        const text = typeof response.text === 'function' ? response.text() : response.text;
        const jsonString = extractJsonFromText(text);
        let insight;
        try {
            insight = JSON.parse(jsonString);
        } catch (error) {
            insight = {
                id: ideaThread.id,
                idea: ideaThread.idea,
                rating: 'neutral',
                why: 'Failed to parse LLM output',
                evidence: {
                    pros_ids: [],
                    risks_ids: [],
                    white_facts_ids: []
                },
                notes: `Error: ${error.message}`
            };
        }
        // Store in idea_insights table
        const { data: summaryData, error: insertError } = await supabase.from('idea_insights').upsert({
            idea_id: ideaThread.id,
            session_id,
            rating: insight.rating,
            why: insight.why,
            evidence: insight.evidence,
            mitigations: insight.mitigations || null,
            worst_possible_idea: insight.worst_possible_idea || null,
            flip_side_idea: insight.flip_side_idea || null,
            notes: insight.notes || null
        }, {
            onConflict: 'idea_id'
        }).select().single();
        if (insertError) {
            console.error('Failed to insert insight:', insertError);
        }
        return new Response(JSON.stringify({
            success: true,
            insight,
            summary_id: summaryData?.id
        }), {
            headers: {
                ...corsHeaders,
                'Content-Type': 'application/json'
            }
        });
    } catch (error) {
        console.error('Error:', error);
        return new Response(JSON.stringify({
            error: error.message
        }), {
            status: 500,
            headers: {
                ...corsHeaders,
                'Content-Type': 'application/json'
            }
        });
    }
});
