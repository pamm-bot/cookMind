class Message < ApplicationRecord
  belongs_to :chat

  MAX_USER_MESSAGES = 10

  after_create_commit :broadcast_append_to_chat

  validate :user_message_limit, if: -> { role == "user" }

  private

  def user_message_limit
    return unless chat.messages.where(role: "user").count >= MAX_USER_MESSAGES

    errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
  end

  def broadcast_append_to_chat
    # Diffuse le message dans le chat via ActionCable
    broadcast_append_to chat,
                        target: "messages",
                        partial: "messages/message",
                        locals: { message: self }
  end
end
