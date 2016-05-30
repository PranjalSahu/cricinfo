json.array!(@events) do |event|
  json.extract! event, :id, :batsman_id, :bowler_id, :run, :comment, :important, :over, :match_id
  json.url event_url(event, format: :json)
end
