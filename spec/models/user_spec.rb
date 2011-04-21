require 'spec_helper'

describe User do

  before :each do
    @attr = { :name => "Example User", :email => "user@example.com"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should accept a name with 5 characters as minimum" do
    short_name_user = User.new(@attr.merge(:name => "abcd"))
    short_name_user.should_not be_valid
  end

  it "should accept a name with 30 characters as maximum" do
    long_name = "a" * 31
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should accept an valid email" do
    addresses = %w[name@domain.com n@dd.info no@do.de HA_LLO@blub.de andy.finga@cool.com 123@xy.abc.xxx a-f@in.de huhu@langer-domain-name.com]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject an invalid email" do
    addresses = %w[name@domain n_dd.info @do.de HA_LLO.blub.de andy@finga@cool.com 123@xy/123.com a-f@in,de huhu@langer-domain-name.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should require an email to be unique" do
    User.create!(@attr)
    same_email_user = User.new(@attr.merge(:name => "Example Two"))
    same_email_user.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    User.create!(@attr)
    upcased_email = @attr[:email].upcase
    same_email_user = User.new(@attr.merge(:name => "Example Two", :email => upcased_email))
    same_email_user.should_not be_valid
  end

end

