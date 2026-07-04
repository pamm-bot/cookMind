class ProfilsController < ApplicationController
  before_action :authenticate_user!
  def show
    @profil = current_user.profil || current_user.create_profil(dietary_preferences: "")
  end

  def edit
    @profil = current_user.profil || current_user.create_profil(dietary_preferences: "")
  end

  def update
    @profil = current_user.profil
    if @profil.update(profil_params)
      redirect_to profil_path(@profil), notice: "Profile updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profil_params
    params.require(:profil).permit(:dietary_preferences)
  end
end
