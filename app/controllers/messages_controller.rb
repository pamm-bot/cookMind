class MessagesController < ApplicationController
  def create
    @chat = current_user.chats.find(params[:chat_id])
    # @ingredients = chat.ingredients
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      Message.create(role: "a chef", content: response.content, chat: @chat)
      redirect_to chat_path(@chat)
    else
      render "/ingredients", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
