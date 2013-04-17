class GoodNamesController < ApplicationController
  def names
    @names = GoodName.where('name like ?', "%#{params[:q]}%")
    render json: @names, only: [:name, :id]
  end
end
