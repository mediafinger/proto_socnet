require 'spec_helper'

describe User do

  before :each do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
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

  it "should require a password" do
    User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
  end

  it "should require a matching password_confirmation" do
    User.new(@attr.merge(:password_confirmation => "barfoo")).should_not be_valid
  end

  it "should reject passwords with less than 6 letters" do
    short_password_user = User.new(@attr.merge(:password => "foo", :password_confirmation => "foo"))
    short_password_user.should_not be_valid
  end

  it "should reject passwords with more than 30 letters" do
    longpass = "F" * 31
    long_password_user = User.new(@attr.merge(:password => longpass, :password_confirmation => longpass))
    long_password_user.should_not be_valid
  end


  describe "password_encryption" do
    before :each do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should save the encrypted_password" do
      @user.encrypted_password.should_not be_blank      # in pure Ruby this would be: encrypted_password.blank? (is not true)
    end

    describe "has_password? method" do
      it "should be true, if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false, if the passwords do not match" do
        @user.has_password?("barfoo").should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        User.authenticate(@user.email, "barfoo").should be_nil
      end

      it "should return nil for an email address with no user" do
        User.authenticate("not@saved.blub", @user.password).should be_nil
      end

      it "should return the User on email/password match" do
        User.authenticate(@user.email, @user.password).should == @user
      end
    end

  end

end

