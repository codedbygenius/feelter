class CreateMoods < ActiveRecord::Migration[8.0]
  def change
    create_table :moods do |t|
      t.integer :feeling
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
