require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'                       # get 'new'  <-->  get :new   both work the same
      response.should be_success
    end

    it "should have the correct title" do
      get :new
      response.should have_selector("title", :content => "sign up")
    end
  end


  describe "POST 'create'" do
    describe "failure" do
      before :each do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "sign up")
      end

      it "should render the new page" do
        post :create, :user => @attr
        response.should render_template('new')
       end
    end

    describe "success" do
      before :each do
        @attr = { :name => "New User", :email => "valid@email.org",
                  :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a new user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the show user page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should display a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome/i
      end
    end
  end


  describe "GET 'show'" do
    before :each do
      @user = Factory(:user)
      get :show, :id => @user             # get 'show', :id => @user.id    would be identical in function
    end

    it "should be successful" do
      response.should be_success
    end

    it "should find the right user" do
      assigns(:user).should == @user
    end

    # the following "have_selector" tests check the view

    it "should have the right title" do
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      response.should have_selector("h2", :content => @user.name)
    end

    it "should have a profile image" do
      response.should have_selector("h2>img", :class => "gravatar")
    end
  end

end

