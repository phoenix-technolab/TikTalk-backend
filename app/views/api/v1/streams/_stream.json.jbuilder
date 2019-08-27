json.id                 stream.id
json.participants_count stream.participants_count
json.creator do 
  json.partial! "/api/v1/users/user", user: stream.user
end