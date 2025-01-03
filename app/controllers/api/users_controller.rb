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

  def search
    users = User.includes(:address, :company)

    # Filter by Name
    users = users.where("users.name ILIKE ?", "%#{params[:name]}%") if params[:name].present?

    # Filter by Email
    users = users.where("users.email ILIKE ?", "%#{params[:email]}%") if params[:email].present?

    # Filter by Phone
    users = users.where("users.phone ILIKE ?", "%#{params[:phone]}%") if params[:phone].present?

    # Filter by Street Address
    users = users.where("addresses.street_address ILIKE ?", "%#{params[:street_address]}%") if params[:street_address].present?

    # Filter by Zip
    users = users.where("addresses.zip ILIKE ?", "%#{params[:zip]}%") if params[:zip].present?

    # Filter by Company Name
    users = users.where("companies.name ILIKE ?", "%#{params[:company_name]}%") if params[:company_name].present?

    # Render the filtered users as JSON
    render json: users.includes(:address, :company).as_json(include: { address: {}, company: {} })
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
