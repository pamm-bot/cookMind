class IngredientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profil
  def index
  end

  def create
  end

  def destroy
  end

  private

  def set_profil
    @profil = current_user.profil || current_user.create_profil
  end
end
