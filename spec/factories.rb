FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |i| "user#{i}@email.com" }
    f.sequence(:name)  { |i| "User Name #{i}"     }
    f.sequence(:uid)   { |i| "uid#{i}"}
    f.provider     "twitter"
    f.home_url     "http://some.url"
  end

  factory :package do |f|
    f.sequence(:name)    { |i| "package-#{i}" }
    f.sequence(:version) { |i| "#{i}.0.0" }
    f.description "Package description"
    f.build       "Lovely('something', function() {});"
    f.documents   :index => 'boo hoo'
    f.license     "MIT"
    f.home_url    "http://some.url"
    f.association :owner, :factory => :user
  end

  factory :version do |f|
    f.sequence(:number) { |i| "1.0.#{i}" }
    f.build      "Lovely('something', function() {});"
    f.documents  'index' => 'boo hoo'
    f.created_at Time.now
    f.updated_at Time.now
    f.association :package, :factory => :package
  end

  factory :document do |f|
    f.sequence(:path) { |i| "doc-#{i}" }
    f.text "some text"
    f.association :version, :factory => :version
  end

  factory :image do |f|
    f.sequence(:path) { |i| "image-#{i}.png" }
    f.data        "some data"
    f.created_at  Time.now
    f.updated_at  Time.now
    f.association :version, :factory => :version
  end

  factory :news do |f|
    f.sequence(:title) { |i| "News #{i}" }
    f.text    "Some text"
    f.association :author, :factory => :user
  end

  factory :show do |f|
    f.sequence(:title) { |i| "Show #{i}" }
    f.text      "Some text"
    f.vimeo_id  "123456"
    f.association :author, :factory => :user
  end

  factory :tag do |f|
    f.sequence(:name) { |i| "tag#{i}" }
  end
end