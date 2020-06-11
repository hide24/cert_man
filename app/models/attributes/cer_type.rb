module Attributes
  class CerType < ActiveRecord::Type::String
    def serialize(value)
      if value.kind_of?(OpenSSL::X509::Certificate)
        super(value.to_s)
      else
        super
      end
    end

    def cast(value)
      begin
        OpenSSL::X509::Certificate.new(value)
      rescue
        value
      end
    end
  end
end
