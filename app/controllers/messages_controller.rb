class MessagesController < ApplicationController

  # before_action :set_message

  def index
    @chat_users = current_user.users_sent_messages_to

    @user_chatting_with = @chat_users.first

    @all_messages = current_user.all_messages_with(@user_chatting_with)

    @message = current_user.sent_messages.new(receiver: @user_chatting_with)
  end

  # def show
  #   # @user = current_user
  # end

  def create
    if @message = current_user.sent_messages.create(message_params)

      # @message.broadcast_append_later_to "chat",
      # target: "messages",
      # locals: { user: current_user }
    else
      redirect_to chat_path, status: :unprocessable_entity
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content, :receiver_id)
  end
end
