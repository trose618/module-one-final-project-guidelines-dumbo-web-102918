class DropStrengthColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column "users", "strength"
  end
end
