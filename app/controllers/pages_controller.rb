class PagesController < ApplicationController
  #before_action :must_login

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
