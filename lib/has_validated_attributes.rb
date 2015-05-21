# encoding: utf-8
require "sanitize"

module HasValidatedAttributes
  extend ActiveSupport::Concern
  CONTROL_CHARS_REGEX = /\A[^[:cntrl:]\\<>]*\z/
  CONTROL_CHARS_ERROR_MSG = "avoid non-printing characters and \\&gt;&lt;/ please."

  #instance methods
  def self.validations(*args)
    args.first.each do |name, format|
      HasValidatedAttributes.define_singleton_method "#{name}_format" do |field_name = nil, options = {}|
        validation = {}
        validation.merge!(:if => "#{field_name}?".to_sym) if format.delete(:has_if?)
        ### length options ###
        opts = options.select{|k, v| k.match(/length/)}
        opts.each{|k,v| validation.merge!(:length => {k.to_s.split("_").first.to_sym => v});options.delete(k)} if opts.present?
        ### extra options ###
        validation.merge!(options) if options.present?

        format.merge(validation)
      end
    end
  end

  class SafeTextValidator < ::ActiveModel::EachValidator
    PERMITTED_UNESCAPED_CHARACTERS = {
      "&" => "amp"
    }

    def validate_each(record, attribute, value)
      record.errors[attribute] << CONTROL_CHARS_ERROR_MSG unless value =~ CONTROL_CHARS_REGEX
      record.errors[attribute] << "may not contain HTML" unless sanitized?(value)
    end

    private

    def sanitized?(text)
      text.blank? || sanitize(text) == text
    end

    def sanitize(text)
      ::Sanitize.fragment(text.to_s).tap do |sanitized_text|
        # Some characters should be allowed to go unescaped, but all the decent sanitizers escape them...
        # so we simply unescape them (this was the solution many others from the Internet have taken).
        PERMITTED_UNESCAPED_CHARACTERS.each do |char, escape|
          sanitized_text.gsub!("&#{ escape };", char)
        end
      end
    end
  end

  #loading all methods dynamically
  validations :name => { :safe_text => true, :length => {:maximum => 63}, :has_if? => true},
              :safe_text => { :safe_text => true, :has_if? => true},
              :username => {:length => {:within => 5..127}, :format => {:with => /\A\w[\w\.\-_@]+\z/, :message => "use only letters, numbers, and .-_@ please."}, :uniqueness => true},
              :rails_name => {:format => {:with => /\A[a-zA-Z\_]*?\z/u, :message => "should only include underscores and letters."}},
              :email => {:length => {:maximum => 63}, :format => {:with => /\A[\w\.%\+\-’']+@(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|pro|mobi|name|aero|jobs|museum)\z/i, :message => "should look like an email address."}},
              :phone_number => {:numericality => {:greater_than_or_equal_to => 1000000000, :less_than => 10000000000, :message => 'accepts only 10 numbers and (),.- characters and must not be all 0s'}, :has_if? => true},
              :phone_extension => {:numericality => {:greater_than_or_equal_to => 0, :less_than => 100000000, :message => 'accepts only numbers (0-9)'}, :has_if? => true},
              :domain => {:length => {:maximum => 63}, :format => {:with => /\A(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|pro|mobi|name|aero|jobs|museum)\z/i, :message => "should look like a domain name."}},
              :zipcode => {:format => {:with => /\A\d{5}(\d{4})?\z/, :message => "must contain 5 or 9 numbers"}, :has_if? => true},
              :middle_initial => {:format => {:with => /\A[a-zA-Z]{0,1}\z/u, :message => "accepts only one letter"}},
              :dollar => {:format => {:with => /\A-?[0-9]{0,12}(\.[0-9]{0,2})?\z/, :message => "accepts only numeric characters, period, and negative sign"}, :numericality => {:greater_than => -1000000000000, :less_than => 1000000000000}, :allow_nil => true},
              :positive_dollar => {:format => {:with => /\A[0-9]{0,12}(\.[0-9]{0,2})?\z/, :message => "accepts only numeric characters, period"}, :numericality => {:greater_than_or_equal_to => 0, :less_than => 1000000000000}, :allow_nil => true},
              :percent => {:format => {:with => /\A-?[0-9]{0,3}(\.[0-9]{0,3})?\z/, :message => "accepts only numeric characters, period, negative sign, and must be equal/less/greater than +/- 100"}},
              :positive_percent => {:format => {:with => /\A[0-9]{0,3}(\.[0-9]{0,3})?\z/, :message => "accepts only numeric characters, period, and must be less than 100"}, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}, :allow_nil => true},
              :url => {:length => {:maximum => 255}, :format => {:with => /\A(http|https|ftp):\/\/[A-Z0-9]+([\.]{1}[a-z0-9-]{1,63})*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix, :message => "web address isnt valid"}, :has_if? => true},
              :social_security_number => {:length => {:is => 9}, :numericality => {:greater_than_or_equal_to => 0, :less_than => 1000000000, :message => "must be in the format 111-11-1111"}, :has_if? => true},
              :taxid => {:length => {:is => 9}, :numericality => {:greater_than_or_equal_to => 9999999, :less_than => 1000000000, :message => "must be in the format 11-1111111"}, :has_if? => true},
              :age => {:numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 110, :message => 'must contain only 3 numbers and less than 110'}},
              :number => {:numericality => {:message => "accepts only numbers (0-9)"}}

  included do
    class_eval do
      def self.has_validated_attributes(args = {})
        if args.blank? || !args.is_a?(Hash)
          raise ArgumentError, 'Must define the fields you want to be validate with has_validated_attributes :field_one => {:format => :phone}, :field_two => {:format => :zipcode, :required => true}'
        end

        args.each do |field, options|
          type = options.delete(:format)
          validates field.to_sym, HasValidatedAttributes.send("#{type}_format".to_sym, field, options)
        end
      end
    end
  end
end

#include activerecord
ActiveRecord::Base.send :include, HasValidatedAttributes