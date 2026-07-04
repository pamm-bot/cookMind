class Message < ApplicationRecord
  belongs_to :chat

  MAX_USER_MESSAGES = 10 # on limite à 10 messages

  validate :user_message_limit, if: lambda {
    role == "user"
  } # on valide uniquement pour les msg de l'utilisateur et pas les réponse de l'ia
  # si l'utilisateur a déjà 10 messages alors une erreur est ajoutée et le message n'est pas sauvevegardé

  private

  def user_message_limit
    return unless chat.messages.where(role: "user").count >= MAX_USER_MESSAGES

    errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
  end
end
