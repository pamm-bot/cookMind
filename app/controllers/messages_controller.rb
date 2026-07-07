class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    save_user_message
    prompt = build_prompt(params[:message][:content])
    response = ask_ai(prompt)

    Message.create(
      role: "assistant",
      content: response.content,
      chat: @chat
    )

    redirect_to chat_path(@chat)
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def save_user_message
    Message.create(
      role: "user",
      content: params[:message][:content],
      chat: @chat
    )
  end

  def build_prompt(question)
    ingredients = Array(current_user.profil.ingredients)
    dietary = current_user.profil.dietary_preferences.presence || "No specific dietary preferences"

    <<~TEXT
      The user has the following ingredients available:
      #{ingredients.join(', ')}

      Dietary preferences:
      #{dietary}

      The user's message is:
      #{question}

      #{response_instructions}
    TEXT
  end

  def response_instructions
    <<~TEXT
      Respond naturally and appropriately to what the user actually said:
      - If they ask for a recipe or recipe suggestion, suggest one using ONLY the ingredients listed above, respecting their dietary preferences, formatted in Markdown.
      - If they ask a specific question (cooking time, substitutions, etc.), answer that question directly and briefly.
      - If they are just thanking you, greeting you, or making small talk (e.g. "thank you", "ok", "great"), respond with a short, warm, conversational reply. Do NOT suggest a new recipe unless they explicitly ask for one.
    TEXT
  end

  def ask_ai(prompt)
    ai_chat = RubyLLM.chat(model: "gpt-4o-mini")
    ai_chat.with_instructions("You are a professional chef. Provide clear, structured recipes in Markdown.")
    ai_chat.ask(prompt)
  end
end
