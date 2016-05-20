require 'test_helper'

class ItemoutsControllerTest < ActionController::TestCase
  setup do
    @itemout = itemouts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:itemouts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create itemout" do
    assert_difference('Itemout.count') do
      post :create, itemout: { outtowel_id: @itemout.outtowel_id, product_id: @itemout.product_id, qnt: @itemout.qnt }
    end

    assert_redirected_to itemout_path(assigns(:itemout))
  end

  test "should show itemout" do
    get :show, id: @itemout
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @itemout
    assert_response :success
  end

  test "should update itemout" do
    patch :update, id: @itemout, itemout: { outtowel_id: @itemout.outtowel_id, product_id: @itemout.product_id, qnt: @itemout.qnt }
    assert_redirected_to itemout_path(assigns(:itemout))
  end

  test "should destroy itemout" do
    assert_difference('Itemout.count', -1) do
      delete :destroy, id: @itemout
    end

    assert_redirected_to itemouts_path
  end
end
