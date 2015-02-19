require 'spec_helper'

class Resource < ActiveRecord::Base
  has_validated_attributes :name_attr => {:format => :name, :maximum_length => 10}, :username_attr => {:format => :username}, :email_attr => {:format => :email},
                           :phone_number_attr => {:format => :phone_number}, :phone_extension_attr => {:format => :phone_extension},
                           :domain_attr => {:format => :domain}, :zipcode_attr => {:format => :zipcode},
                           :middle_initial_attr => {:format => :middle_initial}, :dollar_attr => {:format => :dollar},
                           :positive_dollar_attr => {:format => :positive_dollar}, :percent_attr => {:format => :percent},
                           :positive_percent_attr => {:format => :positive_percent}, :url_attr => {:format => :url}, :ssn_attr => {:format => :social_security_number},
                           :taxid_attr => {:format => :taxid}, :age_attr => {:format => :age}, :number_attr => {:format => :number}
end

describe "HasValidatedAttributes" do
  before(:each) do
    @resource = Resource.create(:username_attr => "testusername", :name_attr => "testname", :email_attr => "test@example.com",
      :phone_number_attr => "1111111111", :phone_extension_attr => "111111", :domain_attr => "www.test.com", :zipcode_attr => "11111",
      :middle_initial_attr => "A", :dollar_attr => "-11", :positive_dollar_attr => "1", :percent_attr => "12",
      :positive_percent_attr => "99", :url_attr => "http://www.google.com", :ssn_attr => "111111111", :taxid_attr => "111111111",
      :number_attr => "1", :age_attr => 28)
  end

  describe "#username" do
    it "should return error" do
      [">*,.<><", "<<< test", "Kansas City", "-- Hey --", "& youuuu", "21 Jump"].each do |value|
        @resource.username_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Username attr use only letters, numbers, and .-_@ please."]
      end
    end

    it "should return error with less than 5 chars" do
      @resource.username_attr = "test"
      @resource.valid?.should be_false
      @resource.errors.full_messages.should == ["Username attr is too short (minimum is 5 characters)"]
    end

    it "should return error with more than 127 chars" do
      @resource.username_attr = "test" * 128
      @resource.valid?.should be_false
      @resource.errors.full_messages.should == ["Username attr is too long (maximum is 127 characters)"]
    end

    it "should return ok" do
      ["kansascity", "kansascity@org1", "kansas.city@org1", "kansas_city@org1", "kansas-city", "1kc.-_@"].each do |value|
        @resource.username_attr = value
        @resource.valid?.should be_true
      end
    end
  end

  describe "#name" do
    it "should return error" do
      [">*", "< test"].each do |value|
        @resource.name_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Name attr avoid non-printing characters and \\&gt;&lt;/ please."]
      end
    end

    it "should return error with more than 10 chars" do
      @resource.name_attr = "test" * 6
      @resource.valid?.should be_false
      @resource.errors.full_messages.should == ["Name attr is too long (maximum is 10 characters)"]
    end

    it "should return ok" do
      ["k c", "- H-", " t", "& u", "21 ", "brok", nil].each do |value|
        @resource.name_attr = value
        @resource.valid?.should be_true
      end
    end
  end

  describe "#email" do
    it "should return error" do
      ["Abc.example.com", "A@b@c@example.com", "()[]\;:,<>@example.com", "abc@example.comar"].each do |value|
        @resource.email_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Email attr should look like an email address."]
      end
    end

    it "should return error with more than 63 chars" do
      @resource.email_attr = "test@example.com" * 64
      @resource.valid?.should be_false
      @resource.errors.full_messages.should == ["Email attr is too long (maximum is 63 characters)", "Email attr should look like an email address."]
    end

    it "should return ok" do
      ["abc@example.com", "Abc@example.com", "aBC@example.com", "abc.123@example.com"].each do |value|
        @resource.email_attr = value
        @resource.valid?.should be_true
      end
    end
  end

  describe "#phone_number" do
    it "should return error" do
      [">*", "< test", "www.test..com", "www.test.c", "www-test.com", "abc", "123", "&*()", "www.test-com"].each do |value|
        @resource.phone_number_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Phone number attr accepts only 10 numbers and (),.- characters and must not be all 0s"]
      end
    end

    it "should return ok" do
      ["9134456677", "5444456677"].each do |value|
        @resource.phone_number_attr = value
        @resource.valid?.should be_true
      end
    end
  end

  describe "#phone_extension" do
    it "should return error" do
      ["-1", "qwert"].each do |value|
        @resource.phone_extension_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Phone extension attr accepts only numbers (0-9)"]
      end
    end

    it "should return ok" do
      ["123", "123456"].each do |value|
        @resource.phone_extension_attr = value
        @resource.valid?.should be_true
      end
    end
  end


  describe "#domain" do
    it "should return error" do
      [">*", "<test", "test-er"].each do |value|
        @resource.domain_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Domain attr should look like a domain name."]
      end
    end

    it "should return error with more than 63 chars" do
        @resource.domain_attr = "a" * 64 + ".com"
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Domain attr is too long (maximum is 63 characters)"]
    end


    it "should return ok" do
      ["test.com", "hey.com", "dynamicadvisorsgroup.com", "advisorsexcel.com"].each do |value|
        @resource.domain_attr = value
        @resource.valid?.should be_true
      end
    end
  end

  describe "#zipcode" do
    it "should return error" do
      ["5555", "5555555555","-99999"].each do |value|
        @resource.zipcode_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Zipcode attr must contain 5 or 9 numbers"]
      end
    end

    it "should return ok" do
      ["11111", "333333333"].each do |value|
        @resource.zipcode_attr = value
        @resource.valid?.should be_true
      end
    end
  end


  describe "#middle_initial" do
    it "should return error" do
      ["k c", "55555", "55555-5555", "55555 5555", "55555.5555", "(888)88-9999", " ,-99999"].each do |value|
        @resource.middle_initial_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Middle initial attr accepts only one letter"]
      end
    end

    it "should return ok" do
      ["a", "A"].each do |value|
        @resource.middle_initial_attr = value
        @resource.valid?.should be_true
      end
    end
  end

  describe "#dollar" do
    it "should return error" do
      ["0.2222"].each do |value|
        @resource.dollar_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Dollar attr accepts only numeric characters, period, and negative sign"]
      end
    end

    it "should return ok" do
      ["0", "1", "100", "1000", "-1000.99"].each do |value|
        @resource.dollar_attr = value
        @resource.valid?.should be_true
      end
    end
  end


  describe "#positive dollar" do
    it "should return error" do
      ["-0.2", "-1"].each do |value|
        @resource.positive_dollar_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Positive dollar attr accepts only numeric characters, period", "Positive dollar attr must be greater than or equal to 0"]
      end
    end

    it "should return ok" do
      ["1", "100", "1000", "1000.99"].each do |value|
        @resource.positive_dollar_attr = value
        @resource.valid?.should be_true
      end
    end
  end

  describe "#percent" do
    it "should return error" do
      ["ewqr", "&"].each do |value|
        @resource.percent_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Percent attr accepts only numeric characters, period, negative sign, and must be equal/less/greater than +/- 100"]
      end
    end

    it "should return ok" do
      ["99.999", "0.001", "99"].each do |value|
        @resource.percent_attr = value
        @resource.valid?.should be_true
      end
    end
  end


  describe "#positive_percent" do
    it "should return error" do
      ["-100"].each do |value|
        @resource.positive_percent_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Positive percent attr accepts only numeric characters, period, and must be less than 100", "Positive percent attr must be greater than or equal to 0"]
      end
    end

    it "should return ok" do
      ["99.999", "0.001", "99"].each do |value|
        @resource.positive_percent_attr = value
        @resource.valid?.should be_true
      end
    end
  end

  describe "#url" do
    it "should return error" do
      ["ewqr", "&", "test.c", "www.test", "test.", "www-test.com"].each do |value|
        @resource.url_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Url attr web address isnt valid"]
      end
    end

    it "should return ok" do
      ["http://www.example.com", "http://fiance.example.com"].each do |value|
        @resource.url_attr = value
        @resource.valid?.should be_true
      end
    end
  end

  describe "#ssn" do
    it "should return error" do
      ["111-111-111"].each do |value|
        @resource.ssn_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Ssn attr is the wrong length (should be 9 characters)", "Ssn attr must be in the format 111-11-1111"]
      end
    end

    it "should return ok" do
      ["111111111"].each do |value|
        @resource.ssn_attr = value
        @resource.valid?.should be_true
      end
    end
  end

  describe "#taxid" do
    it "should return error" do
      @resource.taxid_attr = "ab-cdefgh"
      @resource.valid?.should be_false
      @resource.errors.full_messages.should == ["Taxid attr must be in the format 11-1111111"]
    end

    it "should return error is is less or more than 9 chars" do
      ["111", "1111111111"].each do |value|
        @resource.taxid_attr = value
        @resource.valid?.should be_false
        @resource.errors.full_messages.should == ["Taxid attr is the wrong length (should be 9 characters)", "Taxid attr must be in the format 11-1111111"]
      end
    end

    it "should return ok" do
      ["111111111"].each do |value|
        @resource.taxid_attr = value
        @resource.valid?.should be_true
      end
    end
  end


  describe "#age" do
    it "should return error" do
      @resource.age_attr = "111"
      @resource.valid?.should be_false
      @resource.errors.full_messages.should == ["Age attr must contain only 3 numbers and less than 110"]
    end

    it "should return ok" do
      ["1", "10", "100"].each do |value|
        @resource.age_attr = value
        @resource.valid?.should be_true
      end
    end
  end

  describe "#number" do
    it "should return error" do
      @resource.number_attr = "aaa"
      @resource.valid?.should be_false
      @resource.errors.full_messages.should == ["Number attr accepts only numbers (0-9)"]
    end

    it "should return ok" do
      ["1", "10", "100"].each do |value|
        @resource.number_attr = value
        @resource.valid?.should be_true
      end
    end
  end
end