json.extract! certificate_application, :id, :user_id, :application_type, :status, :created_at, :updated_at
json.url certificate_application_url(certificate_application, format: :json)
