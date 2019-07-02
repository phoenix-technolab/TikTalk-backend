json.users do
  json.array! @users.includes(:attachments, :profile) do |user|
    json.partial! "/api/v1/users/user", user: user
  end
end