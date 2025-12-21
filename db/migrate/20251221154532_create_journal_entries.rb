class CreateJournalEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :journal_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mood, null: false, foreign_key: true
      t.text :note

      t.timestamps
    end
  end
end
