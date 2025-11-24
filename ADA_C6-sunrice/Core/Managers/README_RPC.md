# Supabase RPC Function Reference

## Function: `get_comment_counts_for_ideas`

This function aggregates comment counts by type for multiple ideas in a single database query.

### SQL Definition

```sql
CREATE OR REPLACE FUNCTION get_comment_counts_for_ideas(idea_ids BIGINT[])
RETURNS TABLE (
  idea_id BIGINT,
  yellow_count INT,
  black_count INT,
  dark_green_count INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    ic.idea_id,
    COUNT(*) FILTER (WHERE ic.type_id = (SELECT fourth_round FROM sequences LIMIT 1))::INT AS yellow_count,
    COUNT(*) FILTER (WHERE ic.type_id = (SELECT fifth_round FROM sequences LIMIT 1))::INT AS black_count,
    COUNT(*) FILTER (WHERE ic.type_id = (SELECT third_round FROM sequences LIMIT 1))::INT AS dark_green_count
  FROM ideas_comments ic
  WHERE ic.idea_id = ANY(idea_ids)
  GROUP BY ic.idea_id;
END;
$$ LANGUAGE plpgsql;
```

### Usage in Swift

The function is called in `IdeaManager.swift`:

```swift
struct CommentCountResult: Decodable {
    let idea_id: Int64
    let yellow_count: Int
    let black_count: Int
    let dark_green_count: Int
}

let response: [CommentCountResult] = try await supabaseManager.rpc(
    "get_comment_counts_for_ideas",
    params: ["idea_ids": ideaIds]
).execute().value
```

### Benefits

- **Performance**: Single query instead of fetching all comments
- **Scalability**: Efficient even with many ideas and comments
- **Network**: Reduced data transfer
- **Fallback**: Automatic fallback to manual aggregation if RPC fails

### Testing

To verify the RPC is working:
1. Check console logs for "Fetching comment counts using RPC"
2. Verify counts are retrieved successfully
3. If you see "RPC failed, falling back to manual aggregation", check Supabase function deployment
