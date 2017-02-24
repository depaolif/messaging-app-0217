class UserController < ApplicationController
  get '/users' do
    if logged_in?
      @user = current_user
      @groups = @user.groups_without
      erb :'users/index'
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end
end
