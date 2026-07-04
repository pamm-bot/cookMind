class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  def generate_title_from_first_message
    # Génère un titre à partir du premier message de l'utilisateur
    first_message = messages.where(role: "user").first
    return unless first_message

    # Utilise l'IA pour générer un titre court
    ai_chat = RubyLLM.chat(model: "gpt-4o-mini")
    response = ai_chat.ask("Generate a short title (max 5 words) for a chat that starts with this message: #{first_message.content}. Reply with only the title, no punctuation.")
    update(title: response.content)
  end
end
