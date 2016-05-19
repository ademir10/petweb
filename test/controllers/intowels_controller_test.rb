require 'test_helper'

class IntowelsControllerTest < ActionController::TestCase
  setup do
    @intowel = intowels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:intowels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create intowel" do
    assert_difference('Intowel.count') do
      post :create, intowel: { client_id: @intowel.client_id, form_receipt: @intowel.form_receipt, installments: @intowel.installments, status: @intowel.status }
    end

    assert_redirected_to intowel_path(assigns(:intowel))
  end

  test "should show intowel" do
    get :show, id: @intowel
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @intowel
    assert_response :success
  end

  test "should update intowel" do
    patch :update, id: @intowel, intowel: { client_id: @intowel.client_id, form_receipt: @intowel.form_receipt, installments: @intowel.installments, status: @intowel.status }
    assert_redirected_to intowel_path(assigns(:intowel))
  end

  test "should destroy intowel" do
    assert_difference('Intowel.count', -1) do
      delete :destroy, id: @intowel
    end

    assert_redirected_to intowels_path
  end
end
