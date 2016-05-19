class IntowelsController < ApplicationController
  before_action :set_intowel, only: [:show, :edit, :update, :destroy]
  before_action :show_client_name, only: [:new, :edit, :update, :create, :index, :report_invoice]
  before_action :must_login
  
  #consultando os valores com base na quantidade e produto selecionado
  def consulta_prod
    #pega o id do produto com base no nome
    check_id_prod = Product.find_by(name: params[:product])
    
    #busca os diferentes valores desse cliente
      @prod_clis = ProdCli.select('val1,val2,val3,val4,val5').where(client_id: params[:client_id]).where(product_id: check_id_prod.id).first
      respond_to do |format|
      format.html
      format.json { render :json => @prod_clis }
      end
  
    #------------DEU CERTO GLORIA Á DEUS!!!-----------------------------------------------
  end
  
  def index
    check_client = Client.all
    if check_client.blank?
      flash[:warning] = 'Não existe nenhum cliente cadastrado, portanto não será possivel gerar um orçamento ou Venda. Cadastre pelo menos 1 Cliente.'
      redirect_to clients_path and return
    end

        
    check_product = Product.all
    if check_product.blank?
      flash[:warning] = 'Não existe nenhum produto cadastrado, portanto não será possivel gerar um orçamento ou Venda. Cadastre pelo menos 1 Produto.'
      redirect_to products_path and return
    end
    
    if params[:date1].blank? && params[:date2].blank?
     @intowels = Intowel.where("created_at::date = ?", Date.today)
    end
    
    #consultas por data
    if params[:date1].present? && params[:date2].present?
      
      if params[:date1].blank?
        params[:date1] = Date.today
        @datainicial = Date.today
       else
        @datainicial = Date.strptime(params[:date1], '%Y-%m-%d').strftime("%d/%m/%Y")
      end

      if params[:date2].blank?
        params[:date2] = Date.today
      @datafinal = Date.today
      else
       @datafinal = Date.strptime(params[:date2], '%Y-%m-%d').strftime("%d/%m/%Y")
      end
      
      @datainicial = Date.strptime(params[:date1], '%Y-%m-%d').strftime("%d/%m/%Y")
      @datafinal = Date.strptime(params[:date2], '%Y-%m-%d').strftime("%d/%m/%Y")
               
          
      @intowels = Intowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:created_at)
    end
    
  end

  # GET /intowels/1
  # GET /intowels/1.json
  def show
    @client = Client.find(@intowel.client_id)
    @total_items = Item.where(intowel_id: @intowel.id).sum(:total_value)
    @products = Product.order(:name)
  end

  # GET /intowels/new
  def new
    @intowel = Intowel.new
  end

  # GET /intowels/1/edit
  def edit
  end

  # POST /intowels
  # POST /intowels.json
  def create
    @intowel = Intowel.new(intowel_params)
    
    respond_to do |format|
      @intowel.status = 'ABERTA'
      @intowel.form_receipt = 'NÃO INFORMADO'
      @intowel.installments = '1'
      if @intowel.save
        format.html { redirect_to @intowel, notice: 'Entrada criada com sucesso.' }
        format.json { render :show, status: :created, location: @intowel }
      else
        format.html { render :new }
        format.json { render json: @intowel.errors, status: :unprocessable_entity }
      end
    end
    
 
  end

  # PATCH/PUT /intowels/1
  # PATCH/PUT /intowels/1.json
  def update
    respond_to do |format|
      if @intowel.update(intowel_params)
        format.html { redirect_to @intowel, notice: 'Entrada atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @intowel }
      else
        format.html { render :edit }
        format.json { render json: @intowel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /intowels/1
  # DELETE /intowels/1.json
  def destroy
    @intowel.destroy
    respond_to do |format|
      format.html { redirect_to intowels_url, notice: 'Entrada excluida com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intowel
      @intowel = Intowel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def intowel_params
      params.require(:intowel).permit(:client_id, :form_receipt, :installments, :status)
    end
        #mostra o nome dos clientes ao invés do id
    def show_client_name
      @clients = Client.order(:name)
    end
end
