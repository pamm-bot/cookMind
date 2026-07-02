class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    save_user_message
    prompt = build_prompt
    response = ask_ai(prompt)

<<<<<<< HEAD
    Message.create(
      role: "assistant",
      content: response.content,
      chat: @chat
    )

    redirect_to chat_path(@chat)
=======
    # Sauvegarder le message de l'utilisateur et vérifier la validation
    @message = Message.new(role: "user", content: params[:message][:content], chat: @chat)

    if @message.save
      # Créer le chat IA avec l'historique
      @ruby_llm_chat = RubyLLM.chat(model: "gpt-4o-mini")
      build_conversation_history
      # on crée le chat IA, on envoie l'historique et on pose la question
      response = @ruby_llm_chat.with_instructions("You are a professional chef. Suggest detailed recipes based on the ingredients and dietary preferences provided by the user. Format your response in Markdown.").ask(@message.content)

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
>>>>>>> 73d2f7314e05ecee5caabbcac30b8b68ec37a1f2
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
