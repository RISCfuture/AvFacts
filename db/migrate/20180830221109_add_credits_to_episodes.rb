class AddCreditsToEpisodes < ActiveRecord::Migration[6.0]
  def change
    add_column :episodes, :credits, :text
  end
end
