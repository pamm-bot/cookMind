class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  def generate_title_from_first_message
    first_message = messages.where(role: "user").first
    return unless first_message

    ai_chat = RubyLLM.chat(model: "gpt-4o-mini")
    response = ai_chat.ask("Generate a short title (max 5 words) for a chat that starts with this message: #{first_message.content}. Reply with only the title, no punctuation.") # rubocop:disable Layout/LineLength
    update(title: response.content)
  end
end
