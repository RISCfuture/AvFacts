class MakePublishedAtNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :episodes, :published_at, true
  end
end
