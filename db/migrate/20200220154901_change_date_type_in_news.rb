class ChangeDateTypeInNews < ActiveRecord::Migration[5.0]
  def change
    change_column :news, :date, :string
  end
end
