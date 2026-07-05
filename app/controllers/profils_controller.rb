class ProfilsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profil, only: %i[show edit update]

  def show
  end

  def edit
  end

  def update
    if @profil.update(profil_params)
      redirect_to profil_path(@profil), notice: "Profile updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profil
    @profil = current_user.profil || current_user.build_profil(dietary_preferences: "")
  end

  def profil_params
    params.require(:profil).permit(:dietary_preferences, :avatar)
  end
end
