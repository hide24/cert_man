class AddCertificateApplicationIdToCertificates < ActiveRecord::Migration[6.0]
  def change
    add_column :certificates, :certificate_application_id, :integer
  end
end
