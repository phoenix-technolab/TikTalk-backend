expected_locals = %w(user)
expected_locals.each do |local|
  raise("_user expects local #{local}") unless binding.local_variable_get(local)
end

json.id              user.id
json.email           user.email
json.name            user.name
json.gender          user.gender
json.phone_number    user.phone_number
json.code_country    user.code_country
json.birth_date      user.birth_date
json.country         user.country
json.city            user.city
json.images do
  json.array! user.attachments do |image|
    json.id                  image.id
    json.url                 image.image.url
  end
end
json.created_at      user.created_at
json.updated_at      user.updated_at