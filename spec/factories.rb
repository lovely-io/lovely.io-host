Factory.define :user do |f|
  f.sequence(:email) { |i| "user#{i}@email.com" }
  f.sequence(:name)  { |i| "User Name #{i}"     }
  f.sequence(:uid)   { |i| "uid#{i}"}
  f.provider     "twitter"
  f.home_url     "http://some.url"
end

Factory.define :package do |f|
  f.sequence(:name)    { |i| "package-#{i}" }
#  f.sequence(:version) { |i| "1.1.#{i}" }
  f.description "Package description"
  f.license     "MIT"
  f.association :owner, :factory => :user
end

Factory.define :version do |f|
  f.sequence(:number) { |i| "1.0.#{i}" }
  f.build  "Lovely('something', function() {});"
  f.readme "Oh my dear, that's just lovely!"
  f.association :package, :factory => :package
end