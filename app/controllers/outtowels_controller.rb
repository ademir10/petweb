class OuttowelsController < ApplicationController
  before_action :set_outtowel, only: [:show, :edit, :update, :destroy]
  before_action :show_client_name, only: [:new, :edit, :update, :create, :index, :report_outtowel]
  before_action :must_login

#relatório
  def report_outtowel
   
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
                     
          if params[:client_id].blank? && params[:date1].present? && params[:date2].present?
             @outtowels = Outtowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:created_at)
             @qnt_items = Outtowel.select("outtowels.id,items.qnt,outtowels.created_at").joins(:items).where("outtowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:qnt)
              
          elsif params[:client_id].present? && params[:date1].present? && params[:date2].present?
             @outtowels = Outtowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).order(:created_at)
             @qnt_items = Outtowel.select("outtowels.id,items.qnt,outtowels.created_at").joins(:items).where("outtowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).sum(:qnt)
                      
          elsif params[:client_id].blank? && params[:date1].present? && params[:date2].present?
             @outtowels = Outtowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:created_at)
             @qnt_items = Outtowel.select("outtowels.id,items.qnt,outtowels.created_at").joins(:items).where("outtowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:qnt)
             
          elsif params[:client_id] && params[:date1] && params[:date2]
             @outtowels = Outtowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:created_at).where("client_id = ?", params[:client_id]).order(:created_at)
             @qnt_items = Outtowel.select("outtowels.id,items.qnt,outtowels.created_at").joins(:items).where("outtowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).sum(:qnt)
             
          end
  end
  
  #EFETUA A BAIXA DA INVOICE e envia os dados para o contas á Receber automaticamente gerando o PDF
  def baixar
    @outtowel = Outtowel.find(params[:id])
    
    #verifica se foi adicionado algum item na Outtowel
    @qnt_items = Itemout.where(outtowel_id: @outtowel.id).count
      if @qnt_items == 0
        flash[:warning] = 'Adicione pelo menos 1 item!'
       redirect_to outtowel_path(@outtowel) and return 
      end

     if @outtowel.status == 'FINALIZADA'
     @qnt_itemout = Itemout.where(outtowel_id: @outtowel.id).sum(:qnt)
     else
     @novostatus = 'FINALIZADA'
     Outtowel.update(@outtowel.id, status: @novostatus)
     @qnt_itemout = Itemout.where(outtowel_id: @outtowel.id).sum(:qnt)
     end
  end
  
  
  
  
  
  def index
    check_client = Client.all
    if check_client.blank?
      flash[:warning] = 'Não existe nenhum cliente cadastrado, portanto não será possivel cadastrar saida de toalhas. Cadastre pelo menos 1 Cliente.'
      redirect_to clients_path and return
    end

        
    check_product = Product.all
    if check_product.blank?
      flash[:warning] = 'Não existe nenhum produto cadastrado, portanto não será possivel cadastrar saida de toalhas. Cadastre pelo menos 1 Produto.'
      redirect_to products_path and return
    end
    
    if params[:date1].blank? && params[:date2].blank?
     @outtowels = Outtowel.where("created_at::date = ?", Date.today)
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
               
          
      @outtowels = Outtowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:created_at)
    end
  end

  # GET /outtowels/1
  # GET /outtowels/1.json
  def show
    @client = Client.find(@outtowel.client_id)
    @products = Product.order(:name)
  end

  # GET /outtowels/new
  def new
    @outtowel = Outtowel.new
  end

  # GET /outtowels/1/edit
  def edit
  end

  # POST /outtowels
  # POST /outtowels.json
  def create
        @outtowel = Outtowel.new(outtowel_params)
    
    respond_to do |format|
      @outtowel.status = 'ABERTA'
      if @outtowel.save
      #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Cadastrou nova saida de toalhas - Nº: ' + @outtowel.id.to_s
        log.save!  
        
        format.html { redirect_to @outtowel, notice: 'Saida de toalhas criada com sucesso.' }
        format.json { render :show, status: :created, location: @outtowel }
      else
        format.html { render :new }
        format.json { render json: @outtowel.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # PATCH/PUT /outtowels/1
  # PATCH/PUT /outtowels/1.json
  def update
    respond_to do |format|
      if @outtowel.update(outtowel_params)
        format.html { redirect_to @outtowel, notice: 'Saida de toalhas atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @outtowel }
      else
        format.html { render :edit }
        format.json { render json: @outtowel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /outtowels/1
  # DELETE /outtowels/1.json
  def destroy
    @outtowel.destroy
     #inserindo no log de atividades
     log = Loginfo.new(params[:loginfo])
     log.employee = current_user.name
     log.task = 'Excluiu saida de toalhas - Nº: ' + @outtowel.id.to_s
     log.save!
    respond_to do |format|
      format.html { redirect_to outtowels_url, notice: 'Saida de toalhas excluida com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_outtowel
      @outtowel = Outtowel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def outtowel_params
      params.require(:outtowel).permit(:client_id, :status)
    end
    #mostra o nome dos clientes ao invés do id
    def show_client_name
      @clients = Client.order(:company)
    end
end
