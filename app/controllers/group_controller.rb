class GroupController < ApplicationController

  post '/groups/new' do
    if logged_in?
      user=current_user
      group = Group.create(groupname: params[:group_name])
      user.groups << group
      flash[:message]="#{group.groupname} was created successfully"
      redirect "/users"
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

  get '/groups/:id/join' do
    if logged_in?
      user=current_user
      group = Group.find(params[:id].to_i)
      user.groups << group
      flash[:message] = "Successfully joined #{group.groupname}"
      redirect "/groups/#{group.id}"
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

  get '/groups/:id' do
    if logged_in?
      @user = current_user
      @groups = @user.groups_without
      @group = Group.find(params[:id].to_i)
      erb :'/groups/show'
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

  delete '/groups/:id/delete' do
    group = Group.find(params[:id].to_i)
    name=group.groupname
    group.destroy
    flash[:message]="#{name} was deleted!"
    redirect '/users'
  end

  patch '/groups/:id/leave' do
    if logged_in?
      user = current_user
      group = Group.find(params[:id].to_i)
      user.groups.delete(group)
      flash[:message]="Successfully left #{group.groupname}"
      redirect "/groups/#{group.id}"
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

end
