module Attributes
  class PkeyType < ActiveRecord::Type::String
    def serialize(value)
      if value.kind_of?(OpenSSL::PKey::RSA)
        super(value.export)
      else
        super
      end
    end

    def cast(value)
      begin
        OpenSSL::PKey::RSA.new(value)
      rescue
        value
      end
    end
  end
end
