class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = current_user.chats
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def create
    @chat = current_user.chats.create(title: "AI Recipe Generator")
    generate_ai_recipe if params[:use_ingredients]
    redirect_to chat_path(@chat)
  end

  private

  def generate_ai_recipe
    prompt = build_prompt
    response = ask_ai(prompt)

    Message.create(
      role: "assistant",
      content: response.content,
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

      Please suggest a detailed recipe using ONLY these ingredients.
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
