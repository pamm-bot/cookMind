class MessagesController < ApplicationController
  # on verifie que l'utilisateur est avant d'accéder au chat
  before_action :authenticate_user!

  def create
    # trouver le chat de l'user connecté
    @chat = current_user.chats.find(params[:chat_id])

    # on sauvegarde le message de l'utilisateur
    @user_message = Message.new(role: "user", content: params[:message][:content], chat: @chat)
    @user_message.save

    # on fait appel à l'IA
    ai_chat = RubyLLM.chat(model: "gpt-4o-mini")
    ai_chat.with_instructions("You are a professional chef. Suggest detailed recipes based on the ingredients and dietary preferences provided by the user. Format your response in Markdown.")
    response = ai_chat.ask(params[:message][:content])

    # on sauvegarde la réponse de l'IA
    @ai_message = Message.new(role: "assistant", content: response.content, chat: @chat)
    @ai_message.save

    # rediriger vers la page du chat pour voir la réponse
    redirect_to chat_path(@chat)
  end
end
