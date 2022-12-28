class HeaderColorsController < ApplicationController
  before_action :ensure_current_user

  def edit
  end

  def update
    color_params = params[:header_color][:color]
    header_color = "header_color_#{current_user.id}"
    session[header_color] = color_params

    redirect_to root_path, notice: 'Цвет панели изменен'
  end
end
