RailsAdmin.config do |config|
  config.main_app_name = ["POC SAS", ""]
  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Guide' do
    navigation_icon 'fa fa-book'
    create do
      exclude_fields :value, :detail
    end
    list do
      exclude_fields :patient, :procedure, :contract
    end
  end

  config.model 'Procedure' do
    navigation_icon 'fa fa-bell'
    object_label_method do
      :rails_admin_title
    end
  end

  config.model 'Patient' do
    navigation_icon 'fa fa-address-card'
  end

  config.model 'Contract' do
    navigation_icon 'fa fa-archive'
  end

  config.model 'Provider' do
    navigation_icon 'fa fa-shield'
  end

  config.model 'Price' do
    navigation_icon 'fa fa-money'
  end
end
