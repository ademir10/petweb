require 'test_helper'

class ProdClisControllerTest < ActionController::TestCase
  setup do
    @prod_cli = prod_clis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prod_clis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prod_cli" do
    assert_difference('ProdCli.count') do
      post :create, prod_cli: { client_id: @prod_cli.client_id, product_id: @prod_cli.product_id, qnt: @prod_cli.qnt, val1: @prod_cli.val1, val2: @prod_cli.val2, val3: @prod_cli.val3, val4: @prod_cli.val4, val5: @prod_cli.val5 }
    end

    assert_redirected_to prod_cli_path(assigns(:prod_cli))
  end

  test "should show prod_cli" do
    get :show, id: @prod_cli
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prod_cli
    assert_response :success
  end

  test "should update prod_cli" do
    patch :update, id: @prod_cli, prod_cli: { client_id: @prod_cli.client_id, product_id: @prod_cli.product_id, qnt: @prod_cli.qnt, val1: @prod_cli.val1, val2: @prod_cli.val2, val3: @prod_cli.val3, val4: @prod_cli.val4, val5: @prod_cli.val5 }
    assert_redirected_to prod_cli_path(assigns(:prod_cli))
  end

  test "should destroy prod_cli" do
    assert_difference('ProdCli.count', -1) do
      delete :destroy, id: @prod_cli
    end

    assert_redirected_to prod_clis_path
  end
end
