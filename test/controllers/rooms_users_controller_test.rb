require 'test_helper'

class RoomsUsersControllerTest < ActionController::TestCase
  setup do
    @rooms_user = rooms_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rooms_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rooms_user" do
    assert_difference('RoomsUser.count') do
      post :create, rooms_user: { room_id: @rooms_user.room_id, user_id: @rooms_user.user_id }
    end

    assert_redirected_to rooms_user_path(assigns(:rooms_user))
  end

  test "should show rooms_user" do
    get :show, id: @rooms_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rooms_user
    assert_response :success
  end

  test "should update rooms_user" do
    patch :update, id: @rooms_user, rooms_user: { room_id: @rooms_user.room_id, user_id: @rooms_user.user_id }
    assert_redirected_to rooms_user_path(assigns(:rooms_user))
  end

  test "should destroy rooms_user" do
    assert_difference('RoomsUser.count', -1) do
      delete :destroy, id: @rooms_user
    end

    assert_redirected_to rooms_users_path
  end
end
