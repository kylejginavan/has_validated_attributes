# encoding: utf-8

require 'spec_helper'

class Resource < ActiveRecord::Base
  has_validated_attributes :name_attr => {:format => :name, :maximum_length => 10},
                           :safe_text_attr => { :format => :safe_text },
                           :username_attr => {:format => :username},
                           :email_attr => {:format => :email},
                           :phone_number_attr => {:format => :phone_number},
                           :phone_extension_attr => {:format => :phone_extension},
                           :domain_attr => {:format => :domain},
                           :zipcode_attr => {:format => :zipcode},
                           :middle_initial_attr => {:format => :middle_initial},
                           :dollar_attr => {:format => :dollar},
                           :positive_dollar_attr => {:format => :positive_dollar},
                           :percent_attr => {:format => :percent},
                           :positive_percent_attr => {:format => :positive_percent},
                           :url_attr => {:format => :url},
                           :ssn_attr => {:format => :social_security_number},
                           :taxid_attr => {:format => :taxid},
                           :age_attr => {:format => :age},
                           :number_attr => {:format => :number},
                           :rails_name_attr => {:format => :rails_name},
                           :domain_attr => {:format => :domain}
end

describe "HasValidatedAttributes" do
  before(:each) do
    @resource = Resource.create(
      :username_attr => "testusername",
      :name_attr => "testname",
      :email_attr => "test@example.com",
      :phone_number_attr => "1111111111",
      :phone_extension_attr => "111111",
      :domain_attr => "www.test.com",
      :zipcode_attr => "11111",
      :middle_initial_attr => "A",
      :dollar_attr => "-11",
      :positive_dollar_attr => "1",
      :percent_attr => "12",
      :positive_percent_attr => "99",
      :url_attr => "http://www.google.com",
      :ssn_attr => "111111111",
      :taxid_attr => "111111111",
      :number_attr => "1",
      :age_attr => 28
    )
  end

  describe Resource do
    has_validated_name_attribute(:name_attr, 10)
    has_validated_username_attribute(:username_attr)
    has_validated_email_attribute(:email_attr)
    has_validated_zipcode_attribute(:zipcode_attr)
    has_validated_phone_number_attribute(:phone_number_attr)
    has_validated_phone_extension_attribute(:phone_extension_attr)
    has_validated_url_attribute(:url_attr)
    has_validated_positive_percent_attribute(:positive_percent_attr)
    has_validated_percent_attribute(:percent_attr)
    has_validated_age_attribute(:age_attr)
    has_validated_positive_dollar_attribute(:positive_dollar_attr)
    has_validated_dollar_attribute(:dollar_attr)
    has_validated_number_attribute(:number_attr)
    has_validated_rails_name_attribute(:rails_name_attr)
    has_validated_taxid_attribute(:taxid_attr)
    has_validated_ssn_attribute(:ssn_attr)
    has_validated_safe_text_attribute(:safe_text_attr)
    has_validated_domain_attribute(:domain_attr)
  end
end