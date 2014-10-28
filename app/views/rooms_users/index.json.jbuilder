json.array!(@rooms_users) do |rooms_user|
  json.extract! rooms_user, :id, :room_id, :user_id
  json.url rooms_user_url(rooms_user, format: :json)
end
