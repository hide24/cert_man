json.extract! renewal, :id, :host_id, :file_host, :file_path, :cer_filename, :key_filename, :file_username, :file_password, :file_pkey, :file_use_password, :script_host, :script_path, :script_username, :script_password, :script_pkey, :script_use_password, :created_at, :updated_at
json.url renewal_url(renewal, format: :json)
