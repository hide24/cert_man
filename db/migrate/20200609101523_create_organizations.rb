class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :country
      t.string :state
      t.string :locality
      t.string :organization
      t.string :unit
      t.string :mail

      t.timestamps
    end
  end
end
