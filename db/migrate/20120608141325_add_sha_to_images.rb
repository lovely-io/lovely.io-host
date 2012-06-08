class AddShaToImages < ActiveRecord::Migration
  def change
    change_table(:images) do |t|
      t.string :sha, :default => nil
      t.index  :sha
    end
  end
end
