module Attributes
  class CsrType < ActiveRecord::Type::String
    def serialize(value)
      if value.kind_of?(OpenSSL::X509::Request)
        super(value.to_s)
      else
        super
      end
    end

    def cast(value)
      begin
        OpenSSL::X509::Request.new(value)
      rescue
        value
      end
    end
  end
end
