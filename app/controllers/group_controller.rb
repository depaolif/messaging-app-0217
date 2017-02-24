class GroupController < ApplicationController

  post '/groups/new' do
    if logged_in?
      user=current_user
      group = Group.create(groupname: params[:group_name])
      user.groups << group
      user.set_role("Admin", group)
      flash[:message]="#{group.groupname} was created successfully"
      redirect "/groups/#{group.id}"
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

  get '/groups/:id/join' do
    if logged_in?
      user=current_user
      group = Group.find(params[:id].to_i)
      role=user.get_role(group)
      if role.nil?
        user.groups << group
        user.set_role("Member", group)
        group.messages.create(themessage: "#{user.username} has joined the group", user: current_user)
        flash[:message] = "Successfully joined #{group.groupname}"
        redirect "/groups/#{group.id}"
      elsif role=="Kicked"
        flash[:message] = "You were kicked out and cannot rejoin this group."
        redirect "/groups/#{group.id}"
      elsif role == "Member"
        flash[:message] = "You are already a member of this group"
        redirect "/groups/#{group.id}"
      end
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

  get '/groups/:id' do
    if logged_in?
      @user = current_user
      @not_in_groups = @user.not_in_groups
      @group = Group.find(params[:id].to_i)
      @role = @user.get_role(@group)
      erb :'/groups/show'
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

  delete '/groups/:id/delete' do
    if logged_in?
      group = Group.find(params[:id].to_i)
      role=current_user.get_role(group)
      if role != "Admin"
        flash[:message]="You are not the administrator of this group"
        redirect "/groups/#{group.id}"
      else
        name=group.groupname
        group.destroy
        flash[:message]="#{name} was deleted!"
        redirect '/users'
      end
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

  get '/groups/:groupid/user/:userid/kick' do
    if logged_in?
      user=User.find(params[:userid].to_i)
      group=Group.find(params[:groupid].to_i)
      user.set_role("Kicked", group)
      group.messages.create(themessage: "#{user.username} was kicked out of the group", user: current_user)
      flash[:message] = "#{user.username} was successfully kicked from #{group.groupname}"
      redirect "/groups/#{group.id}"
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

  get '/groups/:groupid/user/:userid/reinstate' do
    if logged_in?
      user=User.find(params[:userid].to_i)
      group=Group.find(params[:groupid].to_i)
      user.set_role("Member", group)
      group.messages.create(themessage: "#{user.username} was invited back", user: current_user)
      flash[:message] = "#{user.username} was invited back to #{group.groupname}"
      redirect "/groups/#{group.id}"
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

  patch '/groups/:id/leave' do
    if logged_in?
      user = current_user
      group = Group.find(params[:id].to_i)
      role = user.get_role(group)
      if role == "Admin"
        flash[:message]="You can't leave.  You're the Admin."
        redirect "/groups/#{group.id}"
      else
        user.groups.delete(group)
        group.messages.create(themessage: "#{user.username} has left the group", user: current_user)
        flash[:message]="Successfully left #{group.groupname}"
        redirect "/groups/#{group.id}"
      end
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end

end
