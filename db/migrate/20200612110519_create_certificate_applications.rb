class CreateCertificateApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :certificate_applications do |t|
      t.integer :user_id
      t.boolean :finished, default: false

      t.timestamps
    end
  end
end
