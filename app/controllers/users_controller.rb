require 'pry'
require 'rack-flash'
class UsersController < ApplicationController
  use Rack::Flash

    get "/users" do
      if logged_in?
        @users = User.all
        erb :'/users/index'
      else
        flash[:message] = "Please login to view this page."
        redirect "/login"
      end
    end

    get "/signup" do
      erb :'/users/new'
    end

    post "/signup" do
      @user = User.create(params[:user])
      session[:user_id] = @user.id
      redirect "/users/#{@user.id}"
    end

    get '/users/:id' do

      if logged_in? && current_user_logged_in?
        @user = current_user
        @user.chores = Chore.find_or_create_by(params[:chore])
        erb :'users/show'
      else
        flash[:message] = "Private user's page.  Please log in as user to view"
        redirect "/login"
      end
    end
end
