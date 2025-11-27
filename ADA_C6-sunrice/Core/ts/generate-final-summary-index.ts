// Supabase Edge Function: Generate Final Summary
// Creates a final one-sentence summary combining all session analyses

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { GoogleGenAI } from 'npm:@google/genai@1.29.0';
import { corsHeaders } from '../_shared/utils.ts';
import { buildSummaryPrompt } from '../_shared/prompts.ts';
import type { WhiteOutput, GreenOutput, RedOutput } from '../_shared/types.ts';

Deno.serve(async (req) => {
    // Handle CORS preflight
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders });
    }

    try {
        // Parse request
        const { session_id } = await req.json();

        if (!session_id) {
            return new Response(
                JSON.stringify({ error: 'Missing session_id' }),
                {
                    status: 400,
                    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                }
            );
        }

        // Initialize Supabase client
        const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
        const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY')!;
        const supabase = createClient(supabaseUrl, supabaseKey);

        // Initialize Gemini AI
        const apiKey = Deno.env.get('GEMINI_API_KEY');
        if (!apiKey) {
            throw new Error('Missing GEMINI_API_KEY');
        }
        const ai = new GoogleGenAI({ apiKey });
        const model = 'gemini-2.0-flash-lite';

        // Fetch summaries from session_summaries table
        const { data: sessionSummaries, error: summariesError } = await supabase
            .from('session_summaries')
            .select('round_type, themes, notes')
            .eq('session_id', session_id);

        if (summariesError) {
            throw new Error(`Failed to fetch session summaries: ${summariesError.message}`);
        }

        // Fetch idea insights from idea_insights table
        const { data: ideaInsights, error: insightsError } = await supabase
            .from('idea_insights')
            .select('*')
            .eq('session_id', session_id);

        if (insightsError) {
            throw new Error(`Failed to fetch idea insights: ${insightsError.message}`);
        }

        if ((!sessionSummaries || sessionSummaries.length === 0) && (!ideaInsights || ideaInsights.length === 0)) {
            return new Response(
                JSON.stringify({
                    error: 'No summaries found. Please run session summarization and idea analysis first.'
                }),
                {
                    status: 404,
                    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                }
            );
        }

        // Parse summaries by type
        let white: WhiteOutput | null = null;
        let green: GreenOutput | null = null;
        let red: RedOutput | null = null;

        for (const summary of sessionSummaries || []) {
            if (summary.round_type === 1) {
                // White session
                white = { categories: summary.themes, notes: summary.notes };
            } else if (summary.round_type === 2) {
                // Green session
                green = { themes: summary.themes, notes: summary.notes };
            } else if (summary.round_type === 6) {
                // Red session
                red = { themes: summary.themes, notes: summary.notes };
            }
        }

        // Build evidence pack
        const evidencePack = JSON.stringify({ white, green, red, insights: ideaInsights });

        // Build prompt
        const prompt = buildSummaryPrompt();

        // Call Gemini AI
        const resp = await ai.models.generateContent({
            model: model,
            contents: [
                {
                    role: 'user',
                    parts: [{ text: prompt }, { text: `EvidencePack:\n${evidencePack}` }],
                },
            ],
        });

        const finalSummary =
            typeof (resp as any).text === 'function'
                ? (resp as any).text()
                : (resp as any).text;

        // Store final summary in session_final_summaries table
        const { data: summaryData, error: insertError } = await supabase
            .from('session_final_summaries')
            .upsert({
                session_id,
                summary_text: finalSummary,
            }, {
                onConflict: 'session_id'
            })
            .select()
            .single();

        if (insertError) {
            console.error('Failed to insert final summary:', insertError);
        }

        return new Response(
            JSON.stringify({
                success: true,
                summary: summaryData,  // <- this matches your Swift
            }),
            {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            }
        );
    } catch (error) {
        console.error('Error:', error);
        return new Response(
            JSON.stringify({ error: (error as Error).message }),
            {
                status: 500,
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            }
        );
    }
});
