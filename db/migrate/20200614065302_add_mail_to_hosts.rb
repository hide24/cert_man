class AddMailToHosts < ActiveRecord::Migration[6.0]
  def change
    add_column :hosts, :mail, :string
  end
end
