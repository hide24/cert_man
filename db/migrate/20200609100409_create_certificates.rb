class CreateCertificates < ActiveRecord::Migration[6.0]
  def change
    create_table :certificates do |t|
      t.integer :host_id
      t.integer :version
      t.text :certificate_key
      t.text :certificate_request
      t.text :certificate
      t.string :owner_name

      t.timestamps
    end
  end
end
