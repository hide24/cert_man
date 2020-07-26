class CreateRenewals < ActiveRecord::Migration[6.0]
  def change
    create_table :renewals do |t|
      t.integer :host_id
      t.string :file_host
      t.string :file_path
      t.string :cer_filename
      t.string :key_filename
      t.string :file_username
      t.string :file_password
      t.string :file_pkey
      t.boolean :file_authtype
      t.string :script_host
      t.string :script_path
      t.string :script_username
      t.string :script_password
      t.string :script_pkey
      t.boolean :script_authtype

      t.timestamps
    end
  end
end
