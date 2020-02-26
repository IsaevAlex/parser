class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.string :title
      t.text :text
      t.string :category
      t.date :date
      t.string :link
      t.string :imgsrc

      t.timestamps
    end
  end
end
