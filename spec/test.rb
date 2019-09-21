# frozen_string_literal: true

require "spec_helper"

class Resource < ActiveRecord::Base
  has_validated_attributes username_attr: { format: :username, allow_blank: false }
end

describe "HasValidatedAttributes" do
  before(:each) do
    @resource = Resource.create(username_attr: "testusername", name_attr: "testname", email_attr: "test@example.com",
      phone_number_attr: "1111111111", phone_extension_attr: "111111", domain_attr: "www.test.com", zipcode_attr: "11111",
      middle_initial_attr: "A", dollar_attr: "-11", positive_dollar_attr: "1", percent_attr: "12",
      positive_percent_attr: "99", url_attr: "http://www.google.com", ssn_attr: "111111111", taxid_attr: "111111111",
      number_attr: "1")
  end

  describe "#username" do
    it "should return error" do
      [">*,.<><", "<<< test", "Kansas City", "-- Hey --", "& youuuu", "21 Jump", ""].each do |value|
        @resource.username_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Username attr use only letters, numbers, and .-_@ please."]
      end
    end
  end
end
