Rails.application.routes.draw do
  get 'sync/sync_data'
  get 'patients/index'
  get 'patients/create'
  get 'patients/update'
  get 'patients/destroy'
  get 'doctors/index'
  get 'doctors/show'
  resources :doctors, only: [:index, :show] do
    resources :patients, only: [:index, :create, :update, :destroy]
    post 'sync', to: 'sync#sync_data'
  end
end