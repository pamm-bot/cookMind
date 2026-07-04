class RecipesController < ApplicationController
  before_action :authenticate_user!

  def index # rubocop:disable Metrics/MethodLength
    @recipes = current_user.recipes
    @chat = current_user.chats.last || current_user.chats.create!(
      title: "What do you want to eat today 🧑‍🍳 ?"
    )
    return unless params[:ingredients].present?

    @ingredients = params[:ingredients]

    instructions =
      "You are a professional chef. " \
      "Suggest detailed recipes based on the ingredients provided. " \
      "Format your response in Markdown."
    question = "I have these ingredients: #{@ingredients.join(', ')}. Suggest me a recipe!"

    ai_chat = RubyLLM.chat(model: "gpt-4o-mini")
    response = ai_chat.with_instructions(instructions).ask(question)

    Message.create!(
      role: "user",
      content: question,
      chat: @chat
    )

    Message.create!(
      role: "assistant",
      content: response.content,
      chat: @chat
    )
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
