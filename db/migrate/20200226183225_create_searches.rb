class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.string :title
      t.text :text
      t.string :date
      t.string :link
      t.string :imgsrc
      t.string :domain

      t.timestamps
    end
  end
end
