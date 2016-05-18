class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :show_supplier_name, only: [:new, :edit, :update, :create, :index, :report_payment]
  before_action :must_login

  #relatorio
  def report_payment
    
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
    
      
          @payments = Payment.includes(:supplier).where(due_date: Date.today).order(:due_date)
          @total_payments = Payment.limit(10).sum(:value_doc)
          
          if params[:date1] && params[:date2] && params[:supplier].blank? && params[:tipo_consulta] == "Á PAGAR"
             @payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'Á PAGAR').order(:due_date)
             @total_payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'Á PAGAR').sum(:value_doc)   
          
          elsif params[:date1] && params[:date2] && params[:supplier] && params[:tipo_consulta] == "Á PAGAR"
             @payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(supplier_id: params[:supplier]).where(status: 'Á PAGAR').order(:due_date)
             @total_payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(supplier_id: params[:supplier]).where(status: 'Á PAGAR').sum(:value_doc)   

                
          elsif params[:date1] && params[:date2] && params[:supplier].blank? && params[:tipo_consulta] == "PAGA"
             @payments = Payment.where("payment_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'PAGA').order(:due_date)
             @total_payments = Payment.where("payment_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'PAGA').sum(:value_doc)   
          
          elsif params[:date1] && params[:date2] && params[:supplier] && params[:tipo_consulta] == "PAGA"
             @payments = Payment.where("payment_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(supplier_id: params[:supplier]).where(status: 'PAGA').order(:due_date)
             @total_payments = Payment.where("payment_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(supplier_id: params[:supplier]).where(status: 'PAGA').sum(:value_doc)   

          
          elsif params[:date1] && params[:date2] && params[:supplier].blank? && params[:tipo_consulta].blank?
             @payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:due_date)
             @total_payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:value_doc)   
      
          end
 
  end

  def index
@payments = Payment.includes(:supplier).where(due_date: Date.today).order(:due_date)
    @total_payments = Payment.where(due_date: Date.today).sum(:value_doc)
    
    if params[:date1].present? && params[:date2].present? && params[:tipo_consulta].blank?
       @payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).order(:due_date)
       @total_payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:value_doc)   
    
    elsif params[:date1].present? && params[:date2].present? && params[:tipo_consulta] == "Á PAGAR"
       @payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'Á PAGAR').order(:due_date)
       @total_payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'Á PAGAR').sum(:value_doc)   
    
    elsif params[:date1].present? && params[:date2].present? && params[:tipo_consulta] == "PAGA"
       @payments = Payment.where("payment_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'PAGA').order(:due_date)
       @total_payments = Payment.where("payment_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'PAGA').sum(:value_doc)   
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)
    @qnt_parcela = payment_params[:installments].to_i
      
    #se for somente uma parcela ele só salva uma vez
    if @qnt_parcela == 1
    
            respond_to do |format|
              if @payment.save
                #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Cadastrou nova conta á pagar - Nº doc: ' + payment_params[:doc_number].to_s
        log.save!
                format.html { redirect_to @payment, notice: 'Pagamento cadastrado com sucesso.' }
                format.json { render :show, status: :created, location: @payment }
              else
                format.html { render :new }
                format.json { render json: @payment.errors, status: :unprocessable_entity }
              end
            end
     else
          #se tiver mais de uma parcela ele lança a quantidade de vezes no sistema
          if @qnt_parcela > 1
            @valor_total = payment_params[:value_doc].to_f
            @resultado = @valor_total / @qnt_parcela
            @resultado = (@resultado).round(2)
            @data_vencto = payment_params[:due_date]
          end
    
        while @qnt_parcela > 0
         @conta_parc = @conta_parc.to_i + 1 
         @data_vencto = @data_vencto.to_date + 1.month 
         @payment.description = payment_params[:description] + ' Parc. ' + @conta_parc.to_s
         @payment.due_date = @data_vencto
         @payment.payment_date = Date.today
         @payment.value_doc = @resultado
                   
            if @payment.save
              #só vai fazer o redirect quando finalizar
            else
              format.html { render :new }
              format.json { render json: @payment.errors, status: :unprocessable_entity }
            end
         @qnt_parcela = @qnt_parcela - 1
         @payment = Payment.new(payment_params)   
        end 
      redirect_to payments_path
      flash[:success] = 'Parcelamento realizado com sucesso!'
     end 
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    #verifica se foi informada a forma de pagamento na baixa
    if payment_params[:payment_date].present? && payment_params[:form_payment].blank?
      flash[:warning] = 'Selecione uma forma de Pagamento!'
      redirect_to edit_payment_path(@payment) and return
    end
    
    #se informou a data da baixa e não alterou para PAGA o status
    if payment_params[:payment_date].present? && payment_params[:status] == 'Á PAGAR'
    flash[:warning] = 'Altere o Status para PAGA, já que você informou a data de pagamento!'
      redirect_to edit_payment_path(@payment) and return
    end
    
    #se alterou para PAGA o status e não informou a data do pagamento
    if payment_params[:status] == 'PAGA' && payment_params[:payment_date].blank?
    flash[:warning] = 'Informe a data de pagamento, já que você alerou o status para PAGA!'
      redirect_to edit_payment_path(@payment) and return
    end
     
    respond_to do |format|
      if @payment.update(payment_params)
        #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Atualizou conta á pagar - Nº doc ' + payment_params[:doc_number].to_s
        log.save!
        format.html { redirect_to @payment, notice: 'Pagamento atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    #inserindo no log de atividades
        log = Loginfo.new(params[:loginfo])
        log.employee = current_user.name
        log.task = 'Excluiu conta á pagar - Nº doc ' + @payment.doc_number.to_s
        log.save!
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Pagamento excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:doc_number, :description, :due_date, :payment_date, :installments, :value_doc, :type_doc, :form_payment, :status, :supplier_id)
    end
    #mostra o nome do fornecedor
    def show_supplier_name
      @suppliers = Supplier.order(:name)
    end
end
