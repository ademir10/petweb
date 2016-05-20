class ItemoutsController < ApplicationController
  before_action :must_login

  # GET /itemouts/1/edit
  def edit
  end

  # POST /itemouts
  # POST /itemouts.json
  def create
    @outtowel = Outtowel.find(params[:outtowel_id])
    
    #verifica se o produto foi selecionado
     if itemout_params[:product_id].blank?
     flash[:warning] = 'Selecione o item desejado!'
     redirect_to outtowel_path(@outtowel) and return
     end
    
    #verifica se já existe o mesmo item adicionado na venda
    check_item = Itemout.where(outtowel_id: @outtowel.id, product_id: itemout_params[:product_id])
    if check_item.present?
      flash[:warning] = 'Este item já foi adicionado!'
      redirect_to outtowel_path(@outtowel) and return
    end
         
      if itemout_params[:qnt].blank?
       flash[:warning] = 'Informe uma quantidade para o item selecionado!'
       redirect_to outtowel_path(@outtowel) and return
      end
        
      @itemout = @outtowel.itemouts.create(itemout_params)
      redirect_to outtowel_path(@outtowel)
    
  end

  def update
    respond_to do |format|
      if @itemout.update(itemout_params)
        format.html { redirect_to @itemout, notice: 'Itemout was successfully updated.' }
        format.json { render :show, status: :ok, location: @itemout }
      else
        format.html { render :edit }
        format.json { render json: @itemout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /itemouts/1
  # DELETE /itemouts/1.json
  def destroy
    @outtowel = Outtowel.find(params[:outtowel_id])
    @itemout = @outtowel.itemouts.find(params[:id])
    @itemout.destroy
    redirect_to outtowel_path(@outtowel)
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def itemout_params
      params.require(:itemout).permit(:product_id, :qnt, :outtowel_id)
    end
end
