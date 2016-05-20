require 'test_helper'

class OuttowelsControllerTest < ActionController::TestCase
  setup do
    @outtowel = outtowels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:outtowels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create outtowel" do
    assert_difference('Outtowel.count') do
      post :create, outtowel: { client_id: @outtowel.client_id }
    end

    assert_redirected_to outtowel_path(assigns(:outtowel))
  end

  test "should show outtowel" do
    get :show, id: @outtowel
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @outtowel
    assert_response :success
  end

  test "should update outtowel" do
    patch :update, id: @outtowel, outtowel: { client_id: @outtowel.client_id }
    assert_redirected_to outtowel_path(assigns(:outtowel))
  end

  test "should destroy outtowel" do
    assert_difference('Outtowel.count', -1) do
      delete :destroy, id: @outtowel
    end

    assert_redirected_to outtowels_path
  end
end
