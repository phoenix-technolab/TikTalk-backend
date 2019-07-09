expected_locals = %w(channel)
expected_locals.each do |local|
  raise("_channel expects local #{local}") unless binding.local_variable_get(local)
end

json.channel_sid                    channel.channel_sid
json.status                         channel.status
json.unread_messages_count          channel.unread_messages_count
json.last_consumed_message_index    channel.last_consumed_message_index        
json.notification_level             channel.notification_level
