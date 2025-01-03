class Api::UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @user = User.includes(:address, :company)
    render json: @user.as_json(
      only: [:id, :name, :email, :phone],
      include: {
        address: {
          only: [:street, :suite, :city, :zipcode]
        },
        company: {
          only: [:name, :catch_phrase, :bs],
          as: :company_name
        }
      }
    )
  end

  # GET /users/1
  def show
    user = User.includes(:address, :company).find(params[:id])
    render json: user.as_json(
      only: [:id, :name, :email, :phone],
      include: {
        address: {
          only: [:street, :suite, :city, :zipcode]
        },
        company: {
          only: [:name, :catch_phrase, :bs],
          as: :company_name
        }
      }
    )
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :phone, :username, :address_id, :company_id)
    end
end
