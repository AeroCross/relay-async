json.array!(@users) do |user|
  json.extract! user, :id, :fullname, :username, :password, :email
  json.url user_url(user, format: :json)
end
