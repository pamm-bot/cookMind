class IngredientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profil
  def index
    @ingredients = Array(@profil.ingredients)
  end

  def create
    @profil.ingredients = Array(@profil.ingredients)
    @profil.ingredients << params[:ingredient]
    @profil.save
    redirect_to ingredients_path
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
