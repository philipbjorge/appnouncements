class AppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app, only: [:show, :edit, :update, :destroy]

  # GET /apps
  def index
    @apps = policy_scope(App)
  end

  # GET /apps/1
  def show
    # TODO: Paginate (delay)
    authorize @app
  end

  # GET /apps/new
  def new
    # TODO: CB: If they do not have capacity in their subscription, on clicking new show them a chargebee iframe
    # On success, POST to create, else redirect back with message?
    @app = current_user.apps.build
    authorize @app
  end

  # GET /apps/1/edit
  def edit
    authorize @app
  end

  # POST /apps
  def create
    # TODO: CB: Prevent creation unless there is room in their subscription
    # TODO: CB: Show a dialog on their status page letting them know when they are under-utilizing their subscriptions
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
    authorize @app
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
      params.require(:app).permit(:display_name, :color, :platform)
    end
end
