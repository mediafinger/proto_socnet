class UsersController < ApplicationController
  def new
    @title = "sign up"
  end

  def show
    @title = "show user page"
    @user = User.find(params[:id])
  end

end

