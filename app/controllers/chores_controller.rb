require 'pry'
require 'rack-flash'
class ChoresController < ApplicationController
  use Rack::Flash

  get '/chores' do
    if logged_in?
      @user = current_user
      @chores = Chore.all
      erb :'/chores/index'
    else
      redirect '/login'
    end
  end

  get '/chores/new' do
    if logged_in?
      @chores = Chore.all
      @user = current_user
      erb :'/chores/new'
    else
      redirect '/login'
    end
  end

  post '/chores' do
    @chore = Chore.create(title: params[:chore][:title])
    @chore.task_ids = params["tasks"]
    @user = current_user
    if @chore.save
      @user.chores << @chore
      redirect to "chores/#{@chore.slug}"
    else
      erb :'chores/new'
    end
  end

  get '/chores/:slug' do
    if logged_in?
      @chore = Chore.find_by_slug(params[:slug])
      erb :'/chores/show'
    else
      flash[:massage] = "Please log in to view this page."
      redirect '/chores'
    end
  end

  get '/chores/:slug/edit' do
    if !logged_in?
      flash[:massage] = "You must be logged in to perform this function"
      redirect '/login'
    else
      @chore = Chore.find_by_slug(params[:slug])
      if @chore && @chore.user == current_user
        erb :'chores/edit'
      else
        redirect '/chores'
      end
    end
  end

  patch '/chores/:slug' do
    @chore = Chore.find_by_slug(params[:slug])
    if !logged_in?
      flash[:message] = "You must be logged in to perform this function"
      redirect "/"
    elsif @chore.user != current_user
      flash[:message] = "You must be the current user to perform this function"
      redirect "/chores"
    else
      @chore.update(params[:chore])
      @chore.task_ids = params["tasks"]
        if @chore.save
          flash[:message] = "Successfully edited chore."
          redirect "chores/#{@chore.slug}"
        else
          flash[:message] = "There seems to be a problem. Please try that again"
          redirect "/chores/:slug/edit"
        end
      end
  end

  delete '/chores/:slug' do
    @chore = Chore.find_by_slug(params[:slug])
    if !logged_in?
      flash[:message] = "You must be logged in to perform this function"
      redirect "/"
    elsif @chore.user != current_user
      flash[:message] = "You must be the current user to perform this function"
      redirect "/chores"
    else
      @chore.destroy
      flash[:message] = "#{@chore.title} successfully deleted."
      redirect "/users/:id"
    end
  end
end
