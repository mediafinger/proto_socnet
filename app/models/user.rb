# == Schema Information
# Schema version: 20110524120836
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :name, :email, :password, :password_confirmation

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,      :presence     => true,
                        :length       => { :within => 5..30 }
  validates :email,     :presence     => true,
                        :format       => { :with => valid_email_regex },
                        :uniqueness   => { :case_sensitive => false }
  validates :password,  :presence     => true,
                        :length       => { :within => 6..30 },
                        :confirmation => true       # automatically creates the virtual attribute password_confirmation

  before_save :encrypt_password

  def self.authenticate(email, submitted_password)
    user = User.find_by_email(email)
    if !user.nil? && user.has_password?(submitted_password)
      user
    else
      nil
    end
  end

  def has_password?(submitted_password)   # return true if it matches the saved password
    encrypt(submitted_password) == encrypted_password
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{string}--#{salt}")
    end

    def make_salt
      secure_hash(Time.now.utc.to_s)
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end

