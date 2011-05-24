# to use this Factory in a test:  @user = Factory(:user)

Factory.define :user do |user|    # by using the symbol :user Factory Girl knows to s(t)imulate the user model
  user.name                     "Andy Finga"
  user.email                    "andy@finga.com"
  user.password                 "foobar"
  user.password_confirmation    "foobar"
end

