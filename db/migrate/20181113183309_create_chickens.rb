class CreateChickens < ActiveRecord::Migration[5.0]
  def change
    create_table :chickens do |t|
      t.string :name
      t.string :weight
    end
  end
end
