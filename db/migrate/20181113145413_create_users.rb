class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table "users" do |t|
      t.string "name"
      t.string "strength"
      t.string "weakness"
    end
  end
end
