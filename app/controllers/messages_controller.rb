class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  SYSTEM_PROMPT = <<~PROMPT
    You are a professional chef assistant called CookMind.
    Suggest detailed recipes based on the ingredients and dietary preferences provided by the user.
    Format your response in Markdown.
    You have access to tools:
    - Search for saved recipes in the user's collection when they ask about a specific recipe.
    - Get the user's dietary preferences and available ingredients to personalize suggestions.
  PROMPT

  def create
    @message = Message.new(role: "user", content: params[:message][:content], chat: @chat)

    if @message.save
      @assistant_message = @chat.messages.create(role: "assistant", content: "")
      full_content = ""

      @ruby_llm_chat = RubyLLM.chat(model: "gpt-4o-mini")
      build_conversation_history
      @ruby_llm_chat.with_tool(SearchRecipesTool.new(user: current_user))
      @ruby_llm_chat.with_tool(UserPreferencesTool.new(user: current_user))
      @ruby_llm_chat.with_instructions(SYSTEM_PROMPT)

      @ruby_llm_chat.ask(@message.content) do |chunk|
        next if chunk.content.blank?
        full_content += chunk.content
        @assistant_message.content = full_content
        broadcast_replace_message(@assistant_message, streaming: true)
      end

      @assistant_message.update(content: full_content)
      broadcast_replace_message(@assistant_message, streaming: false)
      @chat.generate_title_from_first_message

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "new_message_container",
            partial: "messages/form",
            locals: { chat: @chat, message: @message }
          )
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def build_conversation_history
    @chat.messages.each do |message|
      next if message.content.blank?
      @ruby_llm_chat.add_message(role: message.role, content: message.content)
    end
  end

  def broadcast_replace_message(message, streaming: false)
    Turbo::StreamsChannel.broadcast_replace_to(
      @chat,
      target: helpers.dom_id(message),
      partial: "messages/message",
      locals: { message: message, streaming: streaming }
    )
  end
end
