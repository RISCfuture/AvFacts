class AddCreditsToEpisodes < ActiveRecord::Migration[5.2]
  def change
    add_column :episodes, :credits, :text
  end
end
