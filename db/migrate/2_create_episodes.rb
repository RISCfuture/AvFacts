class CreateEpisodes < ActiveRecord::Migration[5.1]
  def change
    create_table :episodes do |t|
      t.integer :number, null: false

      t.string :title, null: false
      t.string :subtitle

      t.string :author

      t.string :summary
      t.text :description, null: false

      t.text :script

      t.datetime :published_at, null: false
      t.boolean :processed, null: false, default: false

      t.boolean :explicit, :blocked, null: false, default: false

      t.tsvector :fulltext_search

      t.timestamps
    end

    add_index :episodes, :number, unique: true, name: 'episodes_number_unique'
    add_index :episodes, %i[published_at number], name: 'episodes_index_action'
    execute "CREATE INDEX episodes_fulltext_search ON episodes USING GIN (fulltext_search)"

    execute <<~SQL
      CREATE TRIGGER episodes_fulltext_update_trigger
        BEFORE INSERT OR UPDATE
          ON episodes
        FOR EACH ROW EXECUTE PROCEDURE
          tsvector_update_trigger(fulltext_search, 'pg_catalog.english', title, description, script);
    SQL
  end
end
