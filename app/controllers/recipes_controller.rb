class RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = current_user.recipes

    if params[:ingredients].present?
      @ingredients = params[:ingredients]
      @chat = current_user.chats.last || current_user.chats.create!(title: "What do you want to eat today 🧑‍🍳 ?")

      ai_chat = RubyLLM.chat(model: "gpt-4o-mini")
      response = ai_chat.with_instructions("You are a professional chef. Suggest detailed recipes based on the ingredients provided. Format your response in Markdown.").ask("I have these ingredients: #{@ingredients.join(', ')}. Suggest me a recipe!")

      # Sauvegarde les messages dans le chat
      Message.create!(role: "user",
                      content: "I have these ingredients: #{@ingredients.join(', ')}. Suggest me a recipe!", chat: @chat)
      Message.create!(role: "assistant", content: response.content, chat: @chat)

      @ai_response = response.content
    else
      @chat = current_user.chats.last
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    if @recipe.save
      redirect_to recipes_path, notice: "Recipe saved!"
    else
      redirect_to recipes_path, alert: "Error while saving."
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to recipes_path, notice: "Recipe deleted!"
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :content, :ingredients, :calories, :meal_type)
  end
end
