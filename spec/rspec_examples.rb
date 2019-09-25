# frozen_string_literal: true

Dir[Rails.root.join("spec/support/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.extend Module.new {
    def has_validated_attribute(type, attr, *args, &block)
      it_behaves_like "#{ type.gsub("_", " ") } attribute", attr, *args, &block
    end

    # Provide dynamic methods wrappers to shared behaviors.
    #
    #=== Examples
    #  has_validated_name_field(:first_name)      # Same as `it_behaves_like "name attribute", :first_name`
    #  has_validated_zip_code_field(:first_name)  # Same as `it_behaves_like "zip code field", :first_name`
    def method_missing(name, *args, &block)
      if /\Ahas_validated_(?<type>\w*)_attribute\Z/ =~ name
        has_validated_attribute(type, *args, &block)
      else
        super
      end
    end
  }
end
