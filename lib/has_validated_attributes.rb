module HasValidatedAttributes
  extend ActiveSupport::Concern

  mattr_accessor :username, :phone_number, :phone_extension, :name, :email,
  :zipcode, :dollar, :percent, :positive_percent, :middle_initial, :url,
  :positive_dollar, :domain, :ssn, :taxid, :age, :number
  
  self.username = {:length => {:within => 5..127}, :format => {:with => /\A\w[\w\.\-_@]+\z/, :message => "use only letters, numbers, and .-_@ please.".freeze}}
  self.name = {:format => {:with => /\A[^[:cntrl:]\\<>]*\z/, :message => "avoid non-printing characters and \\&gt;&lt;/ please.".freeze}}
  self.email = {:length => {:maximum => 63}, :format => {:with => /\A[\w\.%\+\-]+@(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|pro|mobi|name|aero|jobs|museum)\z/i, :message => "should look like an email address.".freeze}}
  self.phone_number = {:numericality => {:greater_than_or_equal_to => 1000000000, :less_than => 10000000000, :message => 'accepts only 10 numbers and (),.- characters'.freeze}, :allow_nil => true, :allow_blank => true}
  self.phone_extension = {:numericality => {:greater_than_or_equal_to => 0, :less_than => 100000000, :message => 'accepts only numbers (0-9)'.freeze}, :allow_nil => true, :allow_blank => true}
  self.domain = {:length => {:maximum => 63}, :format => {:with => /\A(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|pro|mobi|name|aero|jobs|museum)\z/i, :message => "should look like a domain name.".freeze}}
  self.zipcode = {:format => {:with => /^\d{5}(\d{4})?$/, :message => "must contain 5 or 9 numbers".freeze}, :allow_nil => true, :allow_blank => true}
  self.middle_initial = {:format => {:with => /^[a-zA-Z]{0,1}$/u, :message => "accepts only one letter".freeze}}
  self.dollar = {:format => {:with => /^-?[0-9]{0,12}(\.[0-9]{0,2})?$/, :message => "accepts only numeric characters, period, and negative sign".freeze}, :allow_nil => true}
  self.positive_dollar = {:format => {:with => /^[0-9]{0,12}(\.[0-9]{0,2})?$/, :message => "accepts only numeric characters, period".freeze}}
  self.percent = {:format => {:with => /^-?[0-9]{0,3}(\.[0-9]{0,3})?$/, :message => "accepts only numeric characters, period, negative sign, and must be equal/less/greater than +/- 100".freeze}}
  self.positive_percent = {:format => {:with => /^[0-9]{0,3}(\.[0-9]{0,3})?$/, :message => "accepts only numeric characters, period, and must be less than 100".freeze}}
  self.url = {:length => {:maximum => 255}, :format => {:with => /^(http|https|ftp):\/\/[A-Z0-9]+([\.]{1}[a-z0-9-]{1,63})*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :message => "web address isnt valid".freeze}, :allow_nil => true, :allow_blank => true}
  self.ssn = {:length => {:is => 9}, :numericality => {:greater_than_or_equal_to => 0, :less_than => 1000000000, :message => "must be in the format 111-11-1111".freeze}, :allow_nil => true, :allow_blank => true}
  self.taxid = {:length => {:is => 9}, :numericality => {:greater_than_or_equal_to => 9999999, :less_than => 1000000000, :message => "must be in the format 11-1111111".freeze}, :allow_nil => true, :allow_blank => true}
  self.age = {:numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 110, :message => 'must contain only 3 numbers and less than 110'.freeze}, :allow_nil => true}
  self.number = {:numericality => {:message => "accepts only numbers (0-9)".freeze}}

  included do
    class_eval do
      def self.has_validated_attributes(args = {})
        if args.blank? || !args.is_a?(Hash)
          raise ArgumentError, 'Must define the fields you want to be validate with has_validated_attributes :field_one => :phone, :field_two => :zipcode'
        end
        args.each do |field, validation_type|
          validates field.to_sym, HasValidatedAttributes.send(validation_type.to_sym)
        end
      end
    end
  end
end

#include activerecord
ActiveRecord::Base.send :include, HasValidatedAttributes