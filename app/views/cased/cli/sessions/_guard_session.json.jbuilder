json.id guard_session.id
json.url guard_session.url
json.api_url guard_session.api_url
json.state guard_session.state
json.command guard_session.command
json.metadata guard_session.metadata
json.reason guard_session.reason
json.ip_address guard_session.ip_address
json.requester do |requester|
  requester.id guard_session.requester['id']
  requester.email guard_session.requester['email']
end

json.responded_at guard_session.responded_at
json.responder do |responder|
  responder.id guard_session.responder['id']
  responder.email guard_session.responder['email']
end

json.guard_application do |guard_application|
  guard_application.id guard_session.guard_application['id']
  guard_application.name guard_session.guard_application['name']
  guard_application.settings do |settings|
    settings.message_of_the_day guard_session.guard_application.dig('settings', 'message_of_the_day')
    settings.reason_required guard_session.guard_application.dig('settings', 'reason_required')
  end
end
