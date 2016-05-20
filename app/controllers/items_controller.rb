class ItemsController < ApplicationController
  before_action :must_login

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @intowel = Intowel.find(params[:intowel_id])
    
    #verifica se o produto foi selecionado
     if item_params[:product_id].blank?
     flash[:warning] = 'Selecione o item desejado!'
     redirect_to intowel_path(@intowel) and return
     end
    
    #verifica se já existe o mesmo item adicionado na venda
    check_item = Item.where(intowel_id: @intowel.id, product_id: item_params[:product_id])
    if check_item.present?
      flash[:warning] = 'Este item já foi adicionado!'
      redirect_to intowel_path(@intowel) and return
    end
         
      if item_params[:qnt].blank?
       flash[:warning] = 'Informe uma quantidade para o item selecionado!'
       redirect_to intowel_path(@intowel) and return
      end
        
      @item = @intowel.items.create(item_params)
      redirect_to intowel_path(@intowel)
  end


  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @intowel = Intowel.find(params[:intowel_id])
    @item = @intowel.items.find(params[:id])
    @item.destroy
    redirect_to intowel_path(@intowel)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:product_id, :qnt, :sale_value, :total_value, :intowel_id)
    end
end
