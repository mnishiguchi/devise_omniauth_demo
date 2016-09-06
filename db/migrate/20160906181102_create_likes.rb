class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.integer :likeable_id, null: false
      t.string :likeable_type, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :likes, [:likeable_id, :likeable_type]
  end
end
