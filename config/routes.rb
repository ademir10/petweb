Rails.application.routes.draw do
  
  resources :outtowels do
   member do
     post 'baixar'
   end 
    resources :itemouts
  end
 
   resources :intowels do
   member do
     post 'baixar'
   end 
    resources :items
  end
  
  resources :receipts
  resources :payments
  resources :products
  resources :suppliers
  
  resources :clients do
    resources :prod_clis
  end
  resources :prod_clis
  
  resources :loginfos
    resources :expire_dates
  resources :users
      
  root 'pages#index'
  #acerto de clientes por periodo
  get 'reckoning', to: 'intowels#reckoning'
  
  post 'acerto', to: 'intowels#acerto'
 
  #rota para consultar produto selecionado no combobox na Ordem de serviço
  get 'consulta_prod', to: 'intowels#consulta_prod'
  
  get 'sessions/new'
  #rotas para o login
  get 'expired', to: 'sessions#expired_date'
  get 'pages/index'
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'
  post 'login', to: 'sessions#create'
  #---------------------------------------------
  
  #rotas para contato
  get 'contact', to: 'messages#new', as: 'contact'
  post 'contact', to: 'messages#create'
  #---------------------------------------------
  #somente para chamar a edição do usuario quando for um membro logado
  get 'editar_user', to: 'users#chama_edicao'
  #---------------------------------------------
  
  #relatórios
  #relatorio de clientes
  get 'report_client', to: 'clients#report_client'
  #relatorio de fornecedores
  get 'report_supplier', to: 'suppliers#report_supplier'
  #relatorio de produtos
  get 'report_product', to: 'products#report_product'
  #relatorio de contas a pagar
  get 'report_payment', to: 'payments#report_payment'
    #para relatório de contas a receber
  get 'report_receipt', to: 'receipts#report_receipt'
    #para relatório de entrada de toalhas
  get 'report_intowel', to: 'intowels#report_intowel'
  
      
  #para carregar a view informando que não pode excluir cadastro com relacionamento em outra table
  get 'message_error_relation_tables', to: 'messages#message_error_relation_tables'
  end
