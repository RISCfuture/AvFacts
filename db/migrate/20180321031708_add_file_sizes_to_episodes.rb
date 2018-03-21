class AddFileSizesToEpisodes < ActiveRecord::Migration[5.2]
  def change
    change_table :episodes do |t|
      t.bigint :mp3_size, :aac_size
    end

    Episode.reset_column_information
    Episode.find_each do |e|
      e.update mp3_size: e.mp3&.byte_size,
               aac_size: e.aac&.byte_size
    end
  end
end
