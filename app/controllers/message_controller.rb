class MessageController < ApplicationController
  post '/group/:id/message' do
    if logged_in?
      @user=current_user
      @group = Group.find(params[:id].to_i)
      @group.messages.create(themessage: params[:message], user: @user)
      redirect "/groups/#{@group.id}"
    else
      flash[:message]="Not logged in"
      redirect '/'
    end
  end
end
