class MessagesController < ApplicationController
  before_action :set_chat

  def create
    save_user_message
    prompt = build_prompt
    response = ask_ai(prompt)
    Message.create(role: "assistant", content: response.content, chat: @chat)
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

  def build_prompt
    ingredients = Array(current_user.profil.ingredients)
    dietary = current_user.profil.dietary_preferences.presence || "No specific dietary preferences"

    <<~TEXT
      The user has the following ingredients available:
      #{ingredients.join(', ')}

      Dietary preferences:
      #{dietary}

      Please suggest a detailed recipe using ONLY the ingredients listed above.
      Make sure the recipe respects the user's dietary preferences.
      Format your response in Markdown.
    TEXT
  end

  def ask_ai(prompt)
    ai_chat = RubyLLM.chat(model: "gpt-4o-mini")
    ai_chat.with_instructions("You are a professional chef. Provide clear, structured recipes in Markdown.")
    ai_chat.ask(prompt)
  end
end
