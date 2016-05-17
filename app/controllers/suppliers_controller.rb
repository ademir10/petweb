class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  before_action :show_name_city, only: [:new, :edit, :update, :create, :index]
  before_action :show_name_state, only: [:new, :edit, :update, :create, :index]
  before_action :must_login


  #relatorio de fornecedores
  def report_supplier
    @suppliers = Supplier.order(:company)
    @total_suppliers = Supplier.count
  end

  def index
    @total_suppliers = Supplier.count
    
    if params[:search].blank? && params[:tipo_consulta].blank?
          @suppliers = Supplier.limit(50).order(:company)
          
      elsif params[:search].blank? || params[:tipo_consulta].blank?
        @suppliers = Supplier.limit(50).order(:company)
    
        elsif params[:search].present? && params[:tipo_consulta] == "1"
          @suppliers = Supplier.where("company like ?", "%#{params[:search]}%")
      
            elsif params[:search].present? && params[:tipo_consulta] == "2"
                @suppliers = Supplier.where("cnpj like ?", "%#{params[:search]}%")
            
            elsif params[:search].present? && params[:tipo_consulta] == "3"
          @suppliers = Supplier.where("email like ?", "%#{params[:search]}%")
        end
  end

  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to @supplier, notice: 'Fornecedor criado com sucesso.' }
        format.json { render :show, status: :created, location: @supplier }
      else
        format.html { render :new }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to @supplier, notice: 'Fornecedor atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @supplier.destroy
    respond_to do |format|
      format.html { redirect_to suppliers_url, notice: 'Fornecedor excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:supplier).permit(:company, :name, :address, :neighborhood, :cidade_id, :estado_id, :cep, :phone, :cellphone, :email, :cnpj, :bank, :agency, :acount, :favored)
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
