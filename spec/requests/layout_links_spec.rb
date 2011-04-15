require 'spec_helper'

describe "LayoutLinks" do

  it "should have a home page at '/'" do
    get '/'                                 # the 'root_path' '/' equals 'home'
    response.should be_success              # not necessary, if checking for a selector
    response.should have_selector('title', :content => "home")
  end

  it "should have an about page" do
    get '/about'
    response.should have_selector('title', :content => "about")
  end

  it "should have a contact page" do
    get '/contact'
    response.should have_selector('title', :content => "contact")
  end

  it "should have a help page" do
    get '/help'
    response.should have_selector('title', :content => "help")
  end

  it "should have a sign up page" do
    get '/signup'
    response.should have_selector('title', :content => "sign up")
  end


end

