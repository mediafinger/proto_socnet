require 'spec_helper'

describe "Users" do

  describe "sign up" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",                       :with => ""
          fill_in "Email",                      :with => ""
          fill_in "Password",                   :with => ""
          fill_in :user_password_confirmation,  :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should create a new user" do
        lambda do
          visit signup_path
          fill_in "Name",                       :with => "Heinz Strunk"
          fill_in "Email",                      :with => "heinz@strunk.de"
          fill_in "Password",                   :with => "foobar"
          fill_in :user_password_confirmation,  :with => "foobar"
          click_button
          response.should have_selector("div.flash.success", :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end

end

