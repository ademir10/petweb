class PagesController < ApplicationController
 
    #aproveitando esse controller pra gerar o fechamento por periodo
    def report_fechamento
     
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
    
            
        if params[:date1] && params[:date2] && params[:tipo_consulta] == 'Á RECEBER \ Á PAGAR'
           @total_receipts = Receipt.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'Á RECEBER').sum(:value_doc)   
           @status_r = 'Á Receber'
           
           
           @total_payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'Á PAGAR').sum(:value_doc)
           @status_p = 'Á Pagar'
        
        elsif params[:date1] && params[:date2] && params[:tipo_consulta] == 'RECEBIDAS \ PAGAS'
           @total_receipts = Receipt.where("receipt_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'RECEBIDA').sum(:value_doc)   
           @status_r = 'Recebidas'
           
           @total_payments = Payment.where("payment_date BETWEEN ? AND ?", params[:date1], params[:date2]).where(status: 'PAGA').sum(:value_doc)
           @status_p = 'Pagas'
        
        elsif params[:date1] && params[:date2] && params[:tipo_consulta].blank?
          #flash[:waning] = 'Estes dados são com base no dia de hoje, o que temos á Pagar e á Receber, pelo fato de não ter selecionado uma opção.'
           @total_receipts = Receipt.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:value_doc)   
           @status_r = ''
           
           @total_payments = Payment.where("due_date BETWEEN ? AND ?", params[:date1], params[:date2]).sum(:value_doc)
           @status_p = ''
        end
        
        #fazendo o calculo de vendas - despesas
        
        @total_liquido = @total_receipts.to_f - @total_payments.to_f
        @total_liquido = (@total_liquido).round(2)
   
      #se for por data   
      #@total_items = Item.select("product_id, date(created_at) as created_at, sum(qnt) as qnt").where("created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).group("product_id,date(created_at)").order("created_at") 
      
      @total_items = Item.joins(:intowel).select("product_id, sum(qnt) as qnt, sum(total_value) as total_value_sale").where("items.created_at::date BETWEEN ? AND ?", params[:date1], params[:date2]).group("product_id") 
            
    #render layout: false

    end


  def index
    @date = DateTime.now.year
    
    #verifica se tem contas á pagar vencendo hoje
    @payments = Payment.where('due_date <= ?', Date.today).where(status: 'Á PAGAR').order(:due_date)
    @total_payments = Payment.where('due_date <= ?', Date.today).where(status: 'Á PAGAR').sum(:value_doc)
    
    #verifica se tem contas á receber vencendo hoje
    @receipts = Receipt.where('due_date <= ?', Date.today).where(status: 'Á RECEBER').order(:due_date)
    @total_receipts = Receipt.where('due_date <= ?', Date.today).where(status: 'Á RECEBER').sum(:value_doc)
  end
  
  #grafico anual de vendas por categoria
  def sales_report
    
    #total de vendas por mês
      meeting_annual = Intowel.select("date_trunc( 'month', items.created_at ) as month, sum(items.total_value) as total_quantity").joins(:items).where(status: 'RECEBIDA').group('month').order('month')
      meeting_by_month = []
      
      meeting_annual.each do |
      meeting |
      meeting_by_month.push({
          :label => meeting.month.strftime("%B"),
          :value => meeting.total_quantity
      })
      end

      @meeting_annual = Fusioncharts::Chart.new({
          :height => '50%',
          :width => '100%',
          :type => 'column2d',
          :renderAt => 'chart-container-m',
          :dataSource => {
              :chart => {
                  :xAxisname => 'Representação gráfica por mes',
                  :yAxisName => 'Valores em (R$)',
                  :numberPrefix => 'R$',
                  :theme => 'fint',
                  :formatNumberScale=> '0',
                  :decimalSeparator=> ',',
                  :thousandSeparator=> '.',
              },
              :data => meeting_by_month
          }
      })
    
      #total de toalhas locadas por mês
      pack_annual = Intowel.select("date_trunc( 'month', items.created_at ) as month, sum(items.qnt) as total_quantity").joins(:items).group('month').order('month')
      packsearch_by_month = []
      
      pack_annual.each do |
      pack |
      packsearch_by_month.push({
          :label => pack.month.strftime("%B"),
          :value => pack.total_quantity
      })
      end

      @pack_annual = Fusioncharts::Chart.new({
          :height => '50%',
          :width => '100%',
          :type => 'column2d',
          :renderAt => 'chart-container-p',
          :dataSource => {
              :chart => {
                  :xAxisname => 'Representação gráfica por mes',
                  :yAxisName => 'Quantidade de toalhas locadas ',
                  :numberPrefix => 'Toalhas ',
                  :theme => 'fint',
                  :formatNumberScale=> '0',
                  :decimalSeparator=> ',',
                  :thousandSeparator=> '.',
              },
              :data => packsearch_by_month
          }
      })
      
    end 

end
