module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module W1
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          def initialize(order, account, options = {})
            @md5secret = options.delete(:secret)
            
            super
          end

          def form_fields
            @md5_secret.nil? ? 
              @fields :
              @fields.merge(ActiveMerchant::Billing::Integrations::W1.signature_parameter_name => generate_signature)
          end
            
          def generate_signature_string
            #main_params = [:account, :amount, :order, :currency].map {|key| @fields[mappings[key]]}
            #main_params.sort
            #[main_params, @md5secret].flatten.join
            fields = @fields.clone
            fields.delete(ActiveMerchant::Billing::Integrations::W1.signature_parameter_name)
            fields = fields.sort
            values = fields.map {|key,val| val}
            signature_string = [values, @md5secret].flatten.join
            encode_string(signature_string)
          end
          
          def generate_signature
            Digest::MD5.base64digest(generate_signature_string)
          end

          def encode_string(data, enc = 'Windows-1251')
            data.to_s.encode(enc)
          end
          
          # Replace with the real mapping
          mapping :account, 'WMI_MERCHANT_ID'
          mapping :amount, 'WMI_PAYMENT_AMOUNT'
        
          mapping :order, 'WMI_PAYMENT_NO'
          mapping :currency, 'WMI_CURRENCY_ID'

          #mapping :notify_url, 'result_url'
          mapping :return_url, 'WMI_SUCCESS_URL'
          mapping :cancel_return_url, 'WMI_FAIL_URL'
          mapping :description, 'WMI_DESCRIPTION'
          
          #mapping :custom_fields, 'custom_fields'
        end
      end
    end
  end
end