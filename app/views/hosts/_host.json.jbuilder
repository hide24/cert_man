json.extract! host, :id, :hostname, :organization_id, :owner_name, :mail, :created_at, :updated_at
json.certificate do
  if host.certificate
    json.partial! "certificates/certificate", certificate: host.certificate  
  else
    json.expiration_date ""
    json.expiration_date_class ""
  end
end
json.url host_url(host, format: :json)
