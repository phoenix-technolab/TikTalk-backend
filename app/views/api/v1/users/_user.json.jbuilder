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
  json.birth_date               user.birth_date.strftime("%d-%m-%Y")
  json.country                  user.country
  json.city                     user.city
  json.tokens                   user.tokens
  json.images do
    if user.attachments.blank?
      json.array! [{id: rand(1000000..9999999), url: ENV['NO_PHOTO_PLACEHOLDER']}] do |item|
        json.id   item[:id]
        json.url  item[:url]
      end
    else
      json.array! user.attachments do |image|
        json.id                  image.id
        json.url                 image.image.url
      end
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
  json.languages                user.profile.languages
  json.notifications            user.profile.notifications
  json.zodiac                   user.profile.zodiac
  json.locker_value             user.profile.locker_value
  json.locker_type              user.profile.locker_type
  json.lat                      user.lat
  json.lng                      user.lng
  json.created_at               user.created_at
  json.updated_at               user.updated_at
