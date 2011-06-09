Factory.define :user do |f|
  f.sequence(:email) { |i| "user#{i}@email.com" }
  f.sequence(:name)  { |i| "User Name #{i}"     }
  f.sequence(:uid)   { |i| "uid#{i}"}
  f.provider     "twitter"
  f.avatar_url   "http://some.url/avatar.png"
  f.external_url "http://some.url/"
end
