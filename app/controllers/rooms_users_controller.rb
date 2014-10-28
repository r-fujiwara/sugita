class RoomsUsersController < ApplicationController
  before_action :set_rooms_user, only: [:show, :edit, :update, :destroy]

  # GET /rooms_users
  # GET /rooms_users.json
  def index
    @rooms_users = RoomsUser.all
  end

  # GET /rooms_users/1
  # GET /rooms_users/1.json
  def show
  end

  # GET /rooms_users/new
  def new
    @rooms_user = RoomsUser.new
  end

  # GET /rooms_users/1/edit
  def edit
  end

  # POST /rooms_users
  # POST /rooms_users.json
  def create
    @rooms_user = RoomsUser.new(rooms_user_params)

    respond_to do |format|
      if @rooms_user.save
        format.html { redirect_to @rooms_user, notice: 'Rooms user was successfully created.' }
        format.json { render :show, status: :created, location: @rooms_user }
      else
        format.html { render :new }
        format.json { render json: @rooms_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms_users/1
  # PATCH/PUT /rooms_users/1.json
  def update
    respond_to do |format|
      if @rooms_user.update(rooms_user_params)
        format.html { redirect_to @rooms_user, notice: 'Rooms user was successfully updated.' }
        format.json { render :show, status: :ok, location: @rooms_user }
      else
        format.html { render :edit }
        format.json { render json: @rooms_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms_users/1
  # DELETE /rooms_users/1.json
  def destroy
    @rooms_user.destroy
    respond_to do |format|
      format.html { redirect_to rooms_users_url, notice: 'Rooms user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rooms_user
      @rooms_user = RoomsUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rooms_user_params
      params.require(:rooms_user).permit(:room_id, :user_id)
    end
end
