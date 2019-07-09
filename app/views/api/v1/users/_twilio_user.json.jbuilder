expected_locals = %w(user)
expected_locals.each do |local|
  raise("_user expects local #{local}") unless binding.local_variable_get(local)
end


json.sid                        user.sid
json.identity                   user.identity
json.is_online                  user.is_online
json.is_notifiable              user.is_notifiable
json.joined_channels_count      user.joined_channels_count
json.date_created               user.date_created
json.date_updated               user.date_updated