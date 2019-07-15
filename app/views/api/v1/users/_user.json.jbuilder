expected_locals = %w(user)
expected_locals.each do |local|
  raise("_user expects local #{local}") unless binding.local_variable_get(local)
end

  json.id                       user.id
  json.email                    user.email
  json.name                     user.name
  json.gender                   user.gender
  json.phone_number             user.phone_number
  json.code_country             user.code_country
  json.birth_date               user.birth_date
  json.country                  user.country
  json.city                     user.city
  json.images do
    json.array! user.attachments do |image|
      json.id                  image.id
      json.url                 image.image.url
    end
  end
  json.twilio_user_id           user.profile.twilio_user_id
  json.instagram_photos_url     user.profile.instagram_photos_url
  json.is_account_block         user.is_account_block
  json.firebase_token           user.firebase_token
  json.prefer_gender_male       user.profile.prefer_gender_male
  json.prefer_gender_female     user.profile.prefer_gender_female
  json.prefer_min_age           user.profile.prefer_min_age
  json.prefer_max_age           user.profile.prefer_max_age
  json.prefer_location_distance user.profile.prefer_location_distance        
  json.is_show_in_app           user.profile.is_show_in_app
  json.is_show_in_places        user.profile.is_show_in_places
  json.work                     user.profile.work
  json.education                user.profile.education
  json.about_you                user.profile.about_you
  json.relationship             user.profile.relationship
  json.sexuality                user.profile.sexuality
  json.height                   user.profile.height
  json.living                   user.profile.living
  json.children                 user.profile.children
  json.smoking                  user.profile.smoking
  json.drinking                 user.profile.drinking
  json.speak                    user.profile.speak
  json.notifications            user.profile.notifications
  json.lat                      user.lat
  json.lng                      user.lng
  json.created_at               user.created_at
  json.updated_at               user.updated_at
