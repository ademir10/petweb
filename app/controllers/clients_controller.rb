class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  #para trocar o id da cidade cadastrada na tabela pelo nome dela nas views show e index
  before_action :show_name_city, only: [:new, :edit, :update, :create, :index]
    #para trocar o id do estado cadastrado na tabela pelo nome dele nas views show e index
  before_action :show_name_state, only: [:new, :edit, :update, :create, :index]
  before_action :must_login
  
  #relatorio de clientes
  def report_client
    @clients = Client.order(:company)
    @total_clients = Client.count
  end

  # GET /clients
  # GET /clients.json
  def index
    @total_clients = Client.count
    if params[:search].blank? && params[:tipo_consulta].blank?
          @clients = Client.limit(100).order(:company)
          
       elsif params[:search].blank? || params[:tipo_consulta].blank?
          @clients = Client.limit(100).order(:company)   
    
        elsif params[:search].present? && params[:tipo_consulta] == "1"
          @clients = Client.where("company like ?", "%#{params[:search]}%")
      
            elsif params[:search].present? && params[:tipo_consulta] == "2"
                @clients = Client.where("cnpj like ?", "%#{params[:search]}%")
            
            elsif params[:search].present? && params[:tipo_consulta] == "3"
          @clients = Client.where("email like ?", "%#{params[:search]}%")
        end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @products = Product.order(:name)
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Cadastrou novo cliente - Nome: ' + client_params[:name].to_s
        log.save!
        
        format.html { redirect_to @client, notice: 'Cliente criado com sucesso.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Atualizou o cliente - Nome: ' + client_params[:name].to_s
        log.save!
        format.html { redirect_to @client, notice: 'Cliente atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Excluiu cliente - Nome: ' + @client.name.to_s
        log.save!
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Cliente excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:company, :name, :address, :neighborhood, :cidade_id, :estado_id, :cep, :phone, :cellphone, :email, :cnpj, :nf, :val1, :val2, :val3, :val4, :val5, :qnt)
    end
    # pra mostrar o nome da cidade
    def show_name_city
      @cidades = Cidade.order(:nome)
    end
    #pra mostrar o nome do estado
    def show_name_state
      @estados = Estado.order(:sigla)
    end
end
