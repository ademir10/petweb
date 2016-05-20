require 'test_helper'

class ReceiptsControllerTest < ActionController::TestCase
  setup do
    @receipt = receipts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:receipts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create receipt" do
    assert_difference('Receipt.count') do
      post :create, receipt: { client_id: @receipt.client_id, description: @receipt.description, doc_number: @receipt.doc_number, due_date: @receipt.due_date, form_receipt: @receipt.form_receipt, installments: @receipt.installments, invoice_id: @receipt.invoice_id, receipt_date: @receipt.receipt_date, status: @receipt.status, type_doc: @receipt.type_doc }
    end

    assert_redirected_to receipt_path(assigns(:receipt))
  end

  test "should show receipt" do
    get :show, id: @receipt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @receipt
    assert_response :success
  end

  test "should update receipt" do
    patch :update, id: @receipt, receipt: { client_id: @receipt.client_id, description: @receipt.description, doc_number: @receipt.doc_number, due_date: @receipt.due_date, form_receipt: @receipt.form_receipt, installments: @receipt.installments, invoice_id: @receipt.invoice_id, receipt_date: @receipt.receipt_date, status: @receipt.status, type_doc: @receipt.type_doc }
    assert_redirected_to receipt_path(assigns(:receipt))
  end

  test "should destroy receipt" do
    assert_difference('Receipt.count', -1) do
      delete :destroy, id: @receipt
    end

    assert_redirected_to receipts_path
  end
end
