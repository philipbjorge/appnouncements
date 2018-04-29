class AppsController < ApplicationController
  include LoggedIn
  before_action :set_app, only: [:show, :edit, :update, :destroy]

  # GET /apps
  def index
    @apps = policy_scope(App)
  end

  # GET /apps/1
  def show
    authorize @app
  end

  # GET /apps/new
  def new
    @app = current_user.apps.build
    authorize @app
  end

  # GET /apps/1/edit
  def edit
  end

  # POST /apps
  def create
    @app = current_user.apps.build(app_params)
    authorize @app
    if @app.save
      redirect_to @app, notice: 'App was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /apps/1
  def update
    # TODO: Pundit Support
    if @app.update(app_params)
      redirect_to @app, notice: 'App was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /apps/1
  def destroy
    # TODO: Pundit Support
    @app.destroy
    redirect_to apps_url, notice: 'App was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = App.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def app_params
      params.require(:app).permit(:display_name)
    end
end
