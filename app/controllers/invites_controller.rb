class InvitesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_user, only: [:invite, :send_invite, :cancel_invite]
  before_action :set_invite, only: [:show, :accept_invite, :decline_invite]

  def index
    # store_last_page

    @invites = current_user.waiting_received_invites
  end

  def show
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("invite-box", @invite)
      end
      format.html do
        # store_last_page

        redirect_to invites_path
      end
    end
  end

  def send_invite
    current_user.send_invite_request(@user, params[:message])

    flash[:notice] = "Request sent, wait for the user to accept to continue chat :)"

    redirect_to messages_path
  end

  # Note: Here the current_user is the Invite receiver
  def accept_invite
    if @invite.accept
      
      # Create a message from sender(@invite.sender) to current_user
      @message = @invite.sender.send_message(@invite.receiver, @invite.message)
      # binding.break
      
      # Update the invite sender with a new chat user (because current_user has accepted)
      @message.broadcast_append_later_to dom_id(@invite.sender, :chat_list),
        target: "chat-user-list",
        partial: "messages/chat_user",
        locals: {
          chat_user: @invite.receiver, # current_user
          user_chatting_with: nil
        }

      # Destroy the invite, because it has concluded
      @invite.destroy

      redirect_to messages_path(@message.sender)
    else
      redirect_to invites_path, status: :unprocessable_entity
    end
  end

  def decline_invite
    @invite.destroy

    redirect_to invites_path
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_invite
    @invite = Invite.find(params[:id])
  end
end