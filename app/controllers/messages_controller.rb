class MessagesController < ApplicationController
  before_action :authenticate_user!

  SYSTEM_PROMPT = <<~PROMPT
    You are a professional chef assistant called CookMind.
    Suggest detailed recipes based on the ingredients and dietary preferences provided by the user.
    Format your response in Markdown.
    You have access to tools:
    - Search for saved recipes in the user's collection when they ask about a specific recipe.
    - Get the user's dietary preferences and available ingredients to personalize suggestions.
  PROMPT

  def create
    @chat = current_user.chats.find(params[:chat_id])

    # Sauvegarder le message de l'utilisateur et vérifier la validation
    @message = Message.new(role: "user", content: params[:message][:content], chat: @chat)

    if @message.save
      # Créer le chat IA avec l'historique et les outils
      @ruby_llm_chat = RubyLLM.chat(model: "gpt-4o-mini")
      build_conversation_history

      # Connecter les outils à l'IA
      @ruby_llm_chat.with_tool(SearchRecipesTool.new(user: current_user))
      @ruby_llm_chat.with_tool(UserPreferencesTool.new(user: current_user))

      response = @ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)

      # Sauvegarder la réponse de l'IA
      @assistant_message = Message.new(role: "assistant", content: response.content, chat: @chat)
      @assistant_message.save

      # Générer un titre automatique à partir du premier message
      @chat.generate_title_from_first_message

      # si la requête vient de Turbo, on répond sans recharger, sinon on redirige
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          # si le msg n'est pas valide, on met à jour juste le formulaire avec le msg d'erreur
          render turbo_stream: turbo_stream.update("new_message_container", partial: "messages/form",
                                                                            locals: { chat: @chat, message: @message })
        end
        format.html do
          render "chats/show", status: :unprocessable_entity
        end
      end
    end
  end

  private

  def build_conversation_history
    @chat.messages.each do |message|
      next if message.content.blank?

      @ruby_llm_chat.add_message(role: message.role, content: message.content)
    end
  end
end
