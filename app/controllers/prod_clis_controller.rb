class ProdClisController < ApplicationController
  before_action :must_login

  # GET /prod_clis/1/edit
  def edit
    @prod_cli = ProdCli.find(params[:id_prod_cli])
    @product = params[:product]
  end

  # POST /prod_clis
  # POST /prod_clis.json
  def create
   @client = Client.find(params[:client_id])
    #verifica se já existe o mesmo item adicionado na venda
    check_product = ProdCli.where(client_id: @client.id, product_id: prod_cli_params[:product_id])
    if check_product.present?
      flash[:warning] = 'Este produto já foi adicionado á esse cliente!'
      redirect_to client_path(@client) and return
    end
      
      if prod_cli_params[:qnt].blank? || prod_cli_params[:val1].blank? || prod_cli_params[:val2].blank? || prod_cli_params[:val3].blank? || prod_cli_params[:val4].blank? || prod_cli_params[:val5].blank? 
     flash[:warning] = 'Todos os dados precisam ser preenchidos!'
     redirect_to client_path(@client) and return
     else
       #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Adicionou produto ao cliente: ' + @client.company.to_s
        log.save!
       
      @prod_cli = @client.prod_clis.create(prod_cli_params)
      redirect_to client_path(@client)
     end
  end

  # PATCH/PUT /prod_clis/1
  # PATCH/PUT /prod_clis/1.json
  def update
    @prod_cli = ProdCli.find(params[:id])
     respond_to do |format|
      if @prod_cli.update(prod_cli_params)
        #ATUALIZOU DADOS
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Atualizou os dados do produto no cliente: ' + @prod_cli.client.company.to_s
        log.save!  
        
        format.html { redirect_to clients_path, notice: 'produto atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @prod_cli }
      else
        format.html { render :edit }
        format.json { render json: @prod_cli.errors, status: :unprocessable_entity }
      end
    end
    end

  # DELETE /prod_clis/1
  # DELETE /prod_clis/1.json
  def destroy
    @prod_cli.destroy
    respond_to do |format|
      format.html { redirect_to prod_clis_url, notice: 'produto excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def prod_cli_params
      params.require(:prod_cli).permit(:client_id, :product_id, :qnt, :val1, :val2, :val3, :val4, :val5)
    end
end
