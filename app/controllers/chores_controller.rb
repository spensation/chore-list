require 'pry'
require 'rack-flash'
class ChoresController < ApplicationController
  use Rack::Flash

  get '/chores' do
    if logged_in?
      @chores = Chore.all
      @user = current_user
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
    if current_user_logged_in?
      @chore = Chore.find_by_slug(params[:slug])
      erb :'chores/edit'
    else
      flash[:massage] = "You must be logged in to make changes."
      redirect '/login'
    end
  end

  patch '/chores/:slug' do
    @chore = Chore.find_by_slug(params[:slug])
    if !logged_in?
      redirect "/login"
    elsif session[:user_id] != @chore.user.id
      flash[:message] = "Please edit your own chores!"
      redirect "/"
    else
      @chore.update(params[:chore])
      @chore.task_ids = params["tasks"]
      # if !params["task"]["title"].empty?
      #   @chore.tasks << Task.find_or_create_by(title: params[:task][:title])
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
    @chore.destroy
    flash[:message] = "#{@chore.title} successfully deleted."
    redirect "/chores"
  end
end
