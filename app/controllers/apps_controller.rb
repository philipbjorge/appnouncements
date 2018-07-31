class AppsController < ApplicationController
  before_action :authenticate_user!
  before_action :enforce_app_plan_restriction, only: [:new, :create]
  before_action :set_app, only: [:integration, :attach, :show, :edit, :update, :destroy]

  def attach
    authorize @app
    attachment = @app.images.attach(params.require(:file))[0]
    render json: {filename: url_for(attachment)}
  end

  # GET /apps
  def index
    @apps = policy_scope(App)
  end
  
  def integration
    authorize @app, :show?
    @markdown = sdk_integration_markdown(@app)
  end

  # GET /apps/1
  def show
    # TODO: Paginate (delay)
    authorize @app
  end

  # GET /apps/new
  def new
    @app = current_user.apps.build
    authorize @app
  end

  # GET /apps/1/edit
  def edit
    authorize @app
  end

  # POST /apps
  def create
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
      attrs = ([:display_name, :color] + attrs).uniq
      params.require(:app).permit(attrs)
    end
  
    def app_create_params
      app_params(:platform)
    end
  
    def enforce_app_plan_restriction
      return if current_user.subscription.can_create_new_app?
      redirect_to apps_path, notice: "You must <a href='#{view_context.billing_path}'>upgrade your subscription</a> to add more apps!"
    end
  
    def sdk_integration_markdown app
      Rails.cache.fetch("#{app.platform}/sdk_integration_markdown", expires_in: 1.hour) do
        if app.android?
          readme = RestClient.get("https://raw.githubusercontent.com/Appnouncements/appnouncements-android/master/README.md").body
          truncated_readme = /## Integration Guide(.*?)^## /m.match(readme)[1].gsub("YOUR API KEY HERE", app.uuid)
          return truncated_readme + "\n-------\n## Find our full documentation on [github](https://github.com/Appnouncements/appnouncements-android/blob/master/README.md)."
        else
          "# TODO"
        end
      end
    end
end
