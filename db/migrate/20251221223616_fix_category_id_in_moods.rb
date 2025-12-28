class FixCategoryIdInMoods < ActiveRecord::Migration[8.0]
  def change
    change_column_null :moods, :category_id, true
  end
end
