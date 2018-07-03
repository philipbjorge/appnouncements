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
    return unless ensure_billing_acceptable
    
    @app = current_user.apps.build
    authorize @app
  end

  # GET /apps/1/edit
  def edit
    authorize @app
  end

  # POST /apps
  def create
    return unless ensure_billing_acceptable
    
    @app = current_user.apps.build(app_create_params)
    authorize @app
    if @app.save
      redirect_to @app, notice: 'App was successfully created.'
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
      attrs = ([:display_name, :color, :plan] + attrs).uniq
      params.require(:app).permit(attrs)
    end
  
    def app_create_params
      app_params(:platform)
    end
  
    def ensure_billing_acceptable
      session[:return_to] = new_app_path
      
      if current_user.require_billing_information?
        skip_authorization
        redirect_to billing_path, notice: "In order to add new apps, you will need to add a credit card. You will not be charged until you add a new app."
        return false
      elsif current_user.require_updated_billing_information?
        skip_authorization
        redirect_to billing_path, warning: "In order to add new apps, you will to update your billing information."
        return false
      end
      
      session.delete(:return_to)
      return true
    end
end
