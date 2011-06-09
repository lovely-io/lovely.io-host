class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string   :email
      t.string   :name
      t.string   :role

      t.string   :uid,          :null => false  # external ID
      t.string   :provider,     :null => false
      t.string   :avatar_url,   :null => false
      t.string   :external_url, :null => false

      t.string   :last_login_ip
      t.datetime :last_login_at

      t.string   :auth_token

      t.timestamps
    end

    add_index :users, [:provider, :uid], :unique => true
    add_index :users, :auth_token,       :unique => true
  end

  def self.down
    drop_table :users
  end
end
