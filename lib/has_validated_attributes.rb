module HasValidatedAttributes
  extend ActiveSupport::Concern

  mattr_accessor :username_format, :phone_number_format, :phone_extension_format, :name_format, :email_format,
  :zipcode_format, :dollar_format, :percent_format, :positive_percent_format, :middle_initial_format, :url_format,
  :positive_dollar_format, :domain_format, :ssn_format, :taxid_format, :age_format, :number_format
  
  self.username_format = {:length => {:within => 5..127}, :format => {:with => /\A\w[\w\.\-_@]+\z/, :message => "use only letters, numbers, and .-_@ please."}}
  self.name_format = {:format => {:with => /\A[^[:cntrl:]\\<>]*\z/, :message => "avoid non-printing characters and \\&gt;&lt;/ please."}}
  self.email_format = {:length => {:maximum => 63}, :format => {:with => /\A[\w\.%\+\-]+@(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|pro|mobi|name|aero|jobs|museum)\z/i, :message => "should look like an email address."}}
  self.phone_number_format = {:numericality => {:greater_than_or_equal_to => 1000000000, :less_than => 10000000000, :message => 'accepts only 10 numbers and (),.- characters'}}
  self.phone_extension_format = {:numericality => {:greater_than_or_equal_to => 0, :less_than => 100000000, :message => 'accepts only numbers (0-9)'}}
  self.domain_format = {:length => {:maximum => 63}, :format => {:with => /\A(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|pro|mobi|name|aero|jobs|museum)\z/i, :message => "should look like a domain name."}}
  self.zipcode_format = {:format => {:with => /^\d{5}(\d{4})?$/, :message => "must contain 5 or 9 numbers"}}
  self.middle_initial_format = {:format => {:with => /^[a-zA-Z]{0,1}$/u, :message => "accepts only one letter"}}
  self.dollar_format = {:format => {:with => /^-?[0-9]{0,12}(\.[0-9]{0,2})?$/, :message => "accepts only numeric characters, period, and negative sign"}}
  self.positive_dollar_format = {:format => {:with => /^[0-9]{0,12}(\.[0-9]{0,2})?$/, :message => "accepts only numeric characters, period"}}
  self.percent_format = {:format => {:with => /^-?[0-9]{0,3}(\.[0-9]{0,3})?$/, :message => "accepts only numeric characters, period, negative sign, and must be equal/less/greater than +/- 100"}}
  self.positive_percent_format = {:format => {:with => /^[0-9]{0,3}(\.[0-9]{0,3})?$/, :message => "accepts only numeric characters, period, and must be less than 100"}}
  self.url_format = {:length => {:maximum => 255}, :format => {:with => /^(http|https|ftp):\/\/[A-Z0-9]+([\.]{1}[a-z0-9-]{1,63})*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :message => "web address isnt valid"}}
  self.ssn_format = {:length => {:is => 9}, :numericality => {:greater_than_or_equal_to => 0, :less_than => 1000000000, :message => "must be in the format 111-11-1111"}}
  self.taxid_format = {:length => {:is => 9}, :numericality => {:greater_than_or_equal_to => 9999999, :less_than => 1000000000, :message => "must be in the format 11-1111111"}}
  self.age_format = {:numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 110, :message => 'must contain only 3 numbers and less than 110'}}
  self.number_format = {:numericality => {:message => "accepts only numbers (0-9)"}}

  included do
    class_eval do
      def self.has_validated_attributes(args = {})
        if args.blank? || !args.is_a?(Hash)
          raise ArgumentError, 'Must define the fields you want to be validate with has_validated_attributes :field_one => {:format => :phone}, :field_two => {:format => :zipcode, :required => true}'
        end

        args.each do |field, options|
          type = options.delete(:format)
          validates field.to_sym, HasValidatedAttributes.send("#{type}_format".to_sym).merge(options)
        end
      end
    end
  end
end

#include activerecord
ActiveRecord::Base.send :include, HasValidatedAttributes