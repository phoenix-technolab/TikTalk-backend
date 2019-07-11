expected_locals = %w(block)
expected_locals.each do |local|
  raise("_block expects local #{local}") unless binding.local_variable_get(local)
end

json.id          block.id
json.user_id     block.user_id
json.receiver_id block.receiver_id
json.created_at  block.created_at
json.updated_at  block.updated_at