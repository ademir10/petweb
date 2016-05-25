class IntowelsController < ApplicationController
  before_action :set_intowel, only: [:show, :edit, :update, :destroy]
  before_action :show_client_name, only: [:new, :edit, :update, :create, :index, :report_intowel,:reckoning]
  before_action :must_login
  
    
  #acerto por periodo de clientes
  def acerto
   
   #é obrigátorio informar o cliente
    if params[:cliente].blank? || params[:data1].blank? || params[:data2].blank?
      flash[:warning] = 'Você precisa selecionar o cliente, informar o periodo e consultar para poder efetivar a baixa em seguida!.'
      redirect_to reckoning_path and return
    end
    
    check_intowel = Intowel.where(client_id: params[:cliente]).where(status: 'Á RECEBER').where('created_at::Date Between ? and ?', params[:data1],params[:data2]).count
    if check_intowel >= 1
    #atualizo para RECEBIDA todas as entradas com base no periodo informado
    Intowel.where(client_id: params[:cliente]).where(status: 'Á RECEBER').where('created_at::Date Between ? and ?', params[:data1],params[:data2]).update_all(status: 'RECEBIDA')  
    #atualizando todas as contas a receber do cliente informado e no periodo informado
    Receipt.where(client_id: params[:cliente]).where(status: 'Á RECEBER').where('created_at::Date Between ? and ?', params[:data1],params[:data2]).update_all(status: 'RECEBIDA', receipt_date: Date.today)  
    
    #inserindo no log de atividades
    log = Loginfo.new(params[:loginfo])
    log.employee = current_user.name
    log.task = 'Efetuou acerto por periodo do cliente de ID: ' + params[:cliente].to_s + ' e periodo de ' + params[:data1].to_s + ' até ' + params[:data2].to_s 
    log.save!
        
     flash[:success] = 'Acerto realizado com sucesso!'
     redirect_to reckoning_path and return
     else
     flash[:warning] = 'Não existem dados para serem baixados!'
     redirect_to reckoning_path and return 
    end 
    
  end
  
  #consulta de acertos
  def reckoning
   
    if params[:client_id].present?
      @client = Client.find(params[:client_id])
      #guardando os dados da consulta pra utilizar na baixa
      @cliente_acerto = params[:client_id]
      @data1_acerto = params[:date1]
      @data2_acerto = params[:date2]
    end
    
    puts 'aqui está o cliente! ' + @cliente_acerto.to_s
 
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
             @intowels = Intowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:created_at)
             @qnt_items = Intowel.select("intowels.id,items.qnt,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:qnt)
             @total_items = Intowel.select("intowels.id,items.total_value,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:total_value)
 
          elsif params[:client_id].present? && params[:date1].present? && params[:date2].present?
             @intowels = Intowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).order(:created_at)
             @qnt_items = Intowel.select("intowels.id,items.qnt,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).sum(:qnt)
             @total_items = Intowel.select("intowels.id,items.total_value,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).sum(:total_value)

         
          elsif params[:client_id].blank? && params[:date1].present? && params[:date2].present?
             @intowels = Intowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:created_at)
             @qnt_items = Intowel.select("intowels.id,items.qnt,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:qnt)
             @total_items = Intowel.select("intowels.id,items.total_value,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:total_value)

          elsif params[:client_id] && params[:date1] && params[:date2]
             @intowels = Intowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:created_at).where("client_id = ?", params[:client_id]).order(:created_at)
             @qnt_items = Intowel.select("intowels.id,items.qnt,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).sum(:qnt)
             @total_items = Intowel.select("intowels.id,items.total_value,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).sum(:total_value)
           end
  end
  

  #relatório
  def report_intowel
   
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
             @intowels = Intowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:created_at)
             @qnt_items = Intowel.select("intowels.id,items.qnt,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:qnt)
             @total_items = Intowel.select("intowels.id,items.total_value,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:total_value)
 
          elsif params[:client_id].present? && params[:date1].present? && params[:date2].present?
             @intowels = Intowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).order(:created_at)
             @qnt_items = Intowel.select("intowels.id,items.qnt,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).sum(:qnt)
             @total_items = Intowel.select("intowels.id,items.total_value,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).sum(:total_value)

         
          elsif params[:client_id].blank? && params[:date1].present? && params[:date2].present?
             @intowels = Intowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:created_at)
             @qnt_items = Intowel.select("intowels.id,items.qnt,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:qnt)
             @total_items = Intowel.select("intowels.id,items.total_value,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:total_value)

          elsif params[:client_id] && params[:date1] && params[:date2]
             @intowels = Intowel.where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:created_at).where("client_id = ?", params[:client_id]).order(:created_at)
             @qnt_items = Intowel.select("intowels.id,items.qnt,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).sum(:qnt)
             @total_items = Intowel.select("intowels.id,items.total_value,intowels.created_at").joins(:items).where("intowels.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).where("client_id = ?", params[:client_id]).sum(:total_value)
           end
  end
  
  
  #EFETUA A BAIXA DA INVOICE e envia os dados para o contas á Receber automaticamente gerando o PDF
  def baixar
    @intowel = Intowel.find(params[:id])
    
    #verifica se foi adicionado algum item na Intowel
    @qnt_items = Item.where(intowel_id: @intowel.id).count
      if @qnt_items == 0
        flash[:warning] = 'Adicione pelo menos 1 item!'
       redirect_to intowel_path(@intowel) and return 
      end
    
    #verifica se foi informada a forma de pagamento
    if intowel_params[:form_receipt].blank?
      flash[:warning] = 'Selecione uma forma de pagamento válida!'
      redirect_to intowel_path(@intowel) and return
    end
           
    #FAZENDO A SOMA DE TODOS OS ITENS PARA EXIBIR NA IMPRESSÃO 
    @total_items = Item.where(intowel_id: @intowel.id).sum(:total_value)
                     
    # SE JÁ FOI RECEBIDA A O.S. não enviará para o contar á Receber
     if @intowel.status == 'RECEBIDA'
              
        #render layout: 'reports/rpt_intowel'
        redirect_to intowels_path
        flash[:success] = 'E ai o que vamos fazer agora ' + current_user.name + '?'
       else
       #verifica se foi marcada a baixa automática       
       if intowel_params[:status] == '1'
       @novostatus = 'RECEBIDA'
       else
       @novostatus = 'Á RECEBER'  
       end
      
       Intowel.update(@intowel.id, status: @novostatus, form_receipt: intowel_params[:form_receipt], installments: intowel_params[:installments])
       
       #FAZENDO A SOMA DE TODOS OS ITENS PARA JOGAR NO CONTAS Á RECEBER
       @total_items = Item.where(intowel_id: @intowel.id).sum(:total_value)
       
       #verifica se já foi enviado para o contas á receber
              
       if Receipt.exists?(intowel_id: @intowel.id)
         #renderiza a view para carregar o PDF dentro da pasta Layouts/reports
         @intowel = Intowel.find(params[:id])
         redirect_to intowels_path
         flash[:success] = 'Ok o que vamos fazer agora ' + current_user.name + '?'
         else
           
           #verifica a quantidade de parcelas e faz a divisão para enviar para o contas á receber
           @qnt_parcela = intowel_params[:installments].to_i
           
           #se tiver somente uma parcela é lançado uma vez só
           if @qnt_parcela == 1
                
                #ENVIANDO PARA O CONTAS Á RECEBER
                 cta_receber = Receipt.new(params[:receipt])
                 cta_receber.doc_number = @intowel.id
                 cta_receber.client_id = @intowel.client_id
                 cta_receber.type_doc = "ENTRADA DE TOALHAS"
                 cta_receber.description = 'Ref. Entrada de toalhas Nº: ' + params[:id].to_s
                 cta_receber.value_doc = @total_items
                 cta_receber.due_date = Date.today
                 cta_receber.installments = intowel_params[:installments]
                 #Verifica se foi marcado para fazer a baixa automática
                 if intowel_params[:status] == '1'
                 cta_receber.status = "RECEBIDA"
                 cta_receber.receipt_date = Date.today
                 else
                 cta_receber.status = "Á RECEBER"  
                 end
                 cta_receber.intowel_id = @intowel.id
                 cta_receber.form_receipt = intowel_params[:form_receipt]
                 cta_receber.save!
            #caso contrário é feito um loop para lançar parcela por parcela
            else
                if @qnt_parcela > 1
                #@valor_total = Item.find_by[intowel_id: @intowel.id].sum(:total_value).to_f
                @resultado = @total_items.to_f / @qnt_parcela
                @resultado = (@resultado).round(2)
                @data_vencto = Date.today
                end
                
                    while @qnt_parcela > 0
                          @conta_parc = @conta_parc.to_i + 1 
                          @data_vencto = @data_vencto.to_date + 1.month 
                     #inserindo cada parcela no contas á receber
                     cta_receber = Receipt.new(params[:receipt])
                     cta_receber.doc_number = @intowel.id
                     cta_receber.client_id = @intowel.client_id
                     cta_receber.type_doc = "O.S"
                     cta_receber.description = 'Ref. Entrada de toalhas Nº: ' + @intowel.id.to_s + ' Parc. ' + @conta_parc.to_s
                     cta_receber.value_doc = @resultado
                     cta_receber.due_date = @data_vencto
                     cta_receber.installments = intowel_params[:installments]
                     #Verifica se foi marcado para fazer a baixa automática
                     if intowel_params[:status] == '1'
                     cta_receber.status = "RECEBIDA"
                     cta_receber.receipt_date = Date.today
                     else
                     cta_receber.status = "Á RECEBER"  
                     end
                     cta_receber.intowel_id = @intowel.id
                     cta_receber.form_receipt = intowel_params[:form_receipt]
                     cta_receber.save!     
                         
                     @qnt_parcela = @qnt_parcela - 1
                         
                    end 
             
            end     
        
        #Atualiza a forma de pagamento  na visualização do form        
        @intowel = Intowel.find(params[:id])         
                       
        #renderiza a view para carregar o PDF dentro da pasta Layouts/reports
         redirect_to intowels_path
        flash[:success] = 'Entrada finalizada e os dados foram enviados para o contas á receber! e ai o que vamos fazer agora ' + current_user.name + '?'
        end
      end
  end
  

 
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
      flash[:warning] = 'Não existe nenhum cliente cadastrado, portanto não será possivel cadastrar entrada de toalhas. Cadastre pelo menos 1 Cliente.'
      redirect_to clients_path and return
    end

        
    check_product = Product.all
    if check_product.blank?
      flash[:warning] = 'Não existe nenhum produto cadastrado, portanto não será possivel cadastrar entrada de toalhas. Cadastre pelo menos 1 Produto.'
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
      #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Cadastrou nova entrada de toalhas - Nº: ' + @intowel.id.to_s
        log.save!  
        
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
        #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Atualizou entrada de toalhas - Nº: ' + @intowel.id.to_s
        log.save! 
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
     #inserindo no log de atividades
     log = Loginfo.new(params[:loginfo])
     log.employee = current_user.name
     log.task = 'Excluiu entrada de toalhas - Nº: ' + @intowel.id.to_s
     log.save!
    Receipt.destroy_all(intowel_id: @intowel)
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
      @clients = Client.order(:company)
    end
end
