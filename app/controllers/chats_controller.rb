class ChatsController < ApplicationController
  def index
    @chats = current_user.chats
  end

  def create
    @chat = Chat.new(title: "What do you want to eat today 🧑‍🍳 ?")
    # @chat.ingredients = current_user.ingredients --> il va falloir créer un model ingredients
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      @chat.ingredients
      render "/ingredients"
    end
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end
end
