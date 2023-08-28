class MessagesController < ApplicationController
  # include ActionView::RecordIdentifier

  def index
    @chat_users = current_user.users_chatting_with
  
    @user_chatting_with = 
      if params[:receiver]
        User.find(params[:receiver])
      else
        @chat_users.first
      end
  
    @all_messages = current_user.all_messages_with(@user_chatting_with)
  
    @message = current_user.sent_messages.new(receiver: @user_chatting_with)
  end
  
  def create
    if @message = current_user.sent_messages.create(message_params)
    
    else
      redirect_to chat_path, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :receiver_id)
  end
end
