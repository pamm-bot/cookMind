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
    @chat = Chat.new(
      title: "AI Recipe Generator",
      user: current_user
    )
    @chat.save

    # If the user clicked "Find recipes with AI"
    if params[:use_ingredients]
      ingredients = Array(current_user.profil.ingredients)
      dietary_preferences = current_user.profil.dietary_preferences.presence || "No specific dietary preferences"

      prompt = <<~TEXT
        The user has the following ingredients available:
        #{ingredients.join(", ")}

        Dietary preferences:
        #{dietary_preferences}

        Please suggest a detailed recipe using ONLY these ingredients.
        Make sure the recipe respects the user's dietary preferences.
        Format your response in Markdown.
      TEXT

      ai_chat = RubyLLM.chat(model: "gpt-4o-mini")
      ai_chat.with_instructions("You are a professional chef. Provide clear, structured recipes in Markdown.")
      response = ai_chat.ask(prompt)

      Message.create(
        role: "assistant",
        content: response.content,
        chat: @chat
      )
    end

    redirect_to chat_path(@chat)
  end
end
