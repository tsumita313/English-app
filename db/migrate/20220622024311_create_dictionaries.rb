class CreateDictionaries < ActiveRecord::Migration[7.0]
  def change
    create_table :dictionaries do |t|
      t.text :content
      t.text :translation

      t.timestamps
    end
  end
end
