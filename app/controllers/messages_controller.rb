class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.find(params[:chat_id])

    # Sauvegarder le message de l'utilisateur et verifier la validation
    @message = Message.new(role: "user", content: params[:message][:content], chat: @chat) # si le msg est svg (validation ok, on continue sinn on affiche une erreur)

    if @message.save
      # Créer le chat IA avec l'historique
      @ruby_llm_chat = RubyLLM.chat(model: "gpt-4o-mini")
      build_conversation_history
      response = @ruby_llm_chat.with_instructions("You are a professional chef. Suggest detailed recipes based on the ingredients and dietary preferences provided by the user. Format your response in Markdown.").ask(@message.content)
      # on créer le chat ia et on envoie l'historique, on pose la question

      # Sauvegarder la réponse de l'IA
      @assistant_message = Message.new(role: "assistant", content: response.content, chat: @chat)
      @assistant_message.save

      respond_to do |format| # si la requete vient de turbo , on répond avec turbostream sans reharcger si pas de js on redirige
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("new_message_container", partial: "messages/form",
                                                                            locals: { chat: @chat, message: @message })
        end
        # si le msg n'est pas valide ex limite de 10 msg atteinte on met a jour juste le formulaire avec le msg d'errzur
        format.html do
          render "chats/show", status: :unprocessable_entity
        end
      end
    end
  end

  private

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(role: message.role, content: message.content)
    end
  end
end
