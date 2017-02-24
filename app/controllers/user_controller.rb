class UserController < ApplicationController

  get '/users' do
    if logged_in?
      @user = current_user
      @not_in_groups = @user.not_in_groups
      erb :'users/index'
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

  get '/users/:id' do
    if logged_in?
      @profile_user = User.find(params[:id].to_i)
      @profile_user_groups = @profile_user.groups
      @user = current_user
      @not_in_groups = @user.not_in_groups
      erb :'users/show'
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

  patch '/users/:id' do
    if logged_in?
      user = current_user
      user.update(bio: params[:bio],age: params[:age])
      flash[:message]="Profile updated!"
      redirect "/users/#{current_user.id}"
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end
end
