# encoding: utf-8

require "spec_helper"
require "byebug"

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
                           :rails_name_attr => {:format => :rails_name}
end

class NormalizedResource < Resource
  has_normalized_attributes :name_attr => :strip,
                            :safe_text_attr => :strip,
                            :username_attr => :strip,
                            :email_attr => :strip,
                            :phone_number_attr => :phone,
                            :phone_extension_attr => :strip,
                            :domain_attr => :strip,
                            :zipcode_attr => :strip,
                            :middle_initial_attr => :strip,
                            :dollar_attr => :dollar,
                            :positive_dollar_attr => :dollar,
                            :percent_attr => :percent,
                            :positive_percent_attr => :percent,
                            :url_attr => :strip,
                            :ssn_attr => :ssn,
                            :taxid_attr => :taxid,
                            :age_attr => :number,
                            :number_attr => :number,
                            :rails_name_attr => :strip
end

describe "HasValidatedAttributes" do
  context "unnormalized attributes" do
    describe Resource do
      has_validated_name_attribute(:name_attr, length: 10)
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

      context "test validations" do
        subject { Resource.new }
        it { expect(subject).to be_valid }

        context "email addresses" do
          it { subject.email_attr = "name@example.com"; expect(subject).to be_valid }
          it { subject.email_attr = "gladyce@senger.io"; expect(subject).to be_valid }
          it { subject.email_attr = "herp@derp"; expect(subject).to be_invalid }

          ## all of the examples below come from
          ##   http://haacked.com/archive/2007/08/21/i-knew-how-to-validate-an-email-address-until-i.aspx/
          it { subject.email_attr = "NotAnEmail"; expect(subject).to be_invalid }
          it { subject.email_attr = "@NotAnEmail"; expect(subject).to be_invalid }
          # it { subject.email_attr = """test\\blah""@example.com"; expect(subject).to be_valid }
          it { subject.email_attr = """test\blah""@example.com"; expect(subject).to be_invalid }
          it { subject.email_attr = "\"test\\\rblah\"@example.com"; expect(subject).to be_valid }
          it { subject.email_attr = "\"test\rblah\"@example.com"; expect(subject).to be_invalid }
          # it { subject.email_attr = """test\""blah""@example.com"; expect(subject).to be_valid }, true
          # it { subject.email_attr = """test""blah""@example.com"; expect(subject).to be_invalid }
          it { subject.email_attr = "customer/department@example.com"; expect(subject).to be_valid }
          it { subject.email_attr = "$A12345@example.com"; expect(subject).to be_valid }
          it { subject.email_attr = "!def!xyz%abc@example.com"; expect(subject).to be_valid }
          it { subject.email_attr = "_Yosemite.Sam@example.com"; expect(subject).to be_valid }
          it { subject.email_attr = "~@example.com"; expect(subject).to be_valid }
          it { subject.email_attr = ".wooly@example.com"; expect(subject).to be_invalid }
          it { subject.email_attr = "wo..oly@example.com"; expect(subject).to be_invalid }
          it { subject.email_attr = "pootietang.@example.com"; expect(subject).to be_invalid }
          it { subject.email_attr = ".@example.com"; expect(subject).to be_invalid }
          # it { subject.email_attr = """Austin@Powers""@example.com"; expect(subject).to be_valid }
          it { subject.email_attr = "Ima.Fool@example.com"; expect(subject).to be_valid }
          it { subject.email_attr = """Ima.Fool""@example.com"; expect(subject).to be_valid }
          # it { subject.email_attr = """Ima Fool""@example.com"; expect(subject).to be_valid }
          it { subject.email_attr = "Ima Fool@example.com"; expect(subject).to be_invalid }
        end
      end
    end
  end

  context "normalized attributes" do
    describe NormalizedResource do
      has_validated_phone_number_attribute(:phone_number_attr, normalized: true)
      has_validated_positive_dollar_attribute(:positive_dollar_attr, normalized: true)
      has_validated_dollar_attribute(:dollar_attr, normalized: true)
      has_validated_number_attribute(:number_attr, normalized: true)
      has_validated_taxid_attribute(:taxid_attr, normalized: true)
      has_validated_ssn_attribute(:ssn_attr, normalized: true)
    end
  end
end
