json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :user_id, :subject, :content
  json.url ticket_url(ticket, format: :json)
end
