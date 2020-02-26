class AddDomainToNews < ActiveRecord::Migration[5.0]
  def change
    add_column :news, :domain, :string
  end
end
