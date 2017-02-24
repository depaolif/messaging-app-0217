require "./config/environment"
require "./app/models/user"
require "rack-flash"
set :public_folder, File.dirname(__FILE__)
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
    use Rack::Flash
  end

  get "/" do
    if logged_in?
      redirect '/users'
    else
      erb :index
    end
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    #your code here
    user = User.new(params)
    if !user.username.empty? && user.save
      redirect '/users'
    else
      flash[:message]="Sign up failed"
      redirect '/signup'
    end
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/users'
    else
      flash[:message]="Log In failed"
      redirect '/'
    end
  end

  get "/success" do
    if logged_in?
      erb :success
    else
      redirect "/"
    end
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

  end

end
