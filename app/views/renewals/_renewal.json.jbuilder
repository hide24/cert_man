json.extract! renewal, :id, :host_id, :file_host, :file_path, :cer_filename, :key_filename, :file_username, :file_password, :file_pkey, :file_authtype, :script_host, :script_path, :script_username, :script_password, :script_pkey, :script_authtype, :created_at, :updated_at
json.url host_renewal_url(host, format: :json)
