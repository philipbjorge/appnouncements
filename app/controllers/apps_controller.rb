class AppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app, only: [:show, :edit, :update, :destroy]

  # GET /apps
  def index
    @apps = policy_scope(App)
   end

  # GET /apps/1
  def show
    # TODO: Order by version
    # TODO: Paginate (delay)
    authorize @app
  end

  # GET /apps/new
  def new
    @app = current_user.apps.build
    authorize @app
    
    return unless ensure_billing_acceptable
  end

  # GET /apps/1/edit
  def edit
    authorize @app
  end
  
  # POST /apps
  def create
    @app = current_user.apps.build(app_create_params)
    authorize @app
    
    return unless ensure_billing_acceptable
    
    if @app.save
      # TODO: Create/Update Subscription
      redirect_to @app, notice: 'App was successfully created.'
    elsif (not @app.valid?) && @app.errors.messages.keys == [:billing_changes_confirmed]
      @app.billing_changes_confirmed = "1"  # for validates_acceptance_of 
      
      quantity_change = {}
      quantity_change[@app.plan] = 1
      @future_invoice = FutureInvoice.new(current_user.customer, quantity_change)
      
      render :new_confirm_billing
    else
      render :new
    end
  end

  # PATCH/PUT /apps/1
  def update
    authorize @app
    if @app.update(app_params)
      redirect_to @app, notice: 'App was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /apps/1
  def destroy
    authorize @app
    @app.destroy
    redirect_to apps_url, notice: 'App was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = App.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def app_params(*attrs)
      attrs = ([:display_name, :color, :plan, :billing_changes_confirmed] + attrs).uniq
      params.require(:app).permit(attrs)
    end
  
    def app_create_params
      app_params(:platform)
    end
  
    def ensure_billing_acceptable
      session[:return_to] = new_app_path
      
      if current_user.needs_billing_info? && (current_user.apps.length > 1 || @app.plan != :core)
        skip_authorization
        redirect_to billing_path, notice: "In order to add new apps, you need a valid credit card. You will not be charged until you add a new app."
        return false
      end
      
      session.delete(:return_to)
      return true
    end
end
