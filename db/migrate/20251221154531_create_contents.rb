class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.integer :content_type
      t.string :title
      t.string :url
      t.text :blog
      t.references :category, null: false, foreign_key: true
      t.references :mood, null: true, foreign_key: true

      t.timestamps
    end
  end
end
