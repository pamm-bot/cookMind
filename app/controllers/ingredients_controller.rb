class IngredientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profil
  def index
    @ingredients = Array(@profil.ingredients)
  end

  def new
    @ingredients = Array(@profil.ingredients)
  end

  def create
    @profil.ingredients = Array(@profil.ingredients)
    new_ingredient = params.dig(:ingredient, :ingredient).to_s.strip
    return redirect_to ingredients_path, alert: "Please enter an ingredient." unless new_ingredient.present?

    @profil.ingredients << new_ingredient
    if @profil.save
      redirect_to ingredients_path, notice: "Ingredient added."
    else
      redirect_to ingredients_path, alert: "Unable to save ingredient."
    end
  end

  def destroy
    @profil.ingredients = Array(@profil.ingredients)
    @profil.ingredients.delete_at(params[:id].to_i)
    @profil.save
    redirect_to ingredients_path
  end

  private

  def set_profil
    @profil = current_user.profil || current_user.create_profil
  end
end
