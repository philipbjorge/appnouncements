class ReleasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app, only: [:new, :attach, :edit, :create, :update, :destroy,]
  before_action :set_release, only: [:attach, :edit, :update, :destroy]

  # GET /apps/1/releases/new
  def new
    authorize @app
    @release = @app.releases.build(type: @app.release_type)
  end

  # GET /apps/1/edit
  def edit
    authorize @release
  end

  def attach
    authorize @release
    attachment = @app.images.attach(params.require(:file))[0]
    render json: {filename: url_for(attachment)}
  end

  # POST /apps
  def create
    authorize @app
    @release = @app.releases.build(release_params.merge(type: @app.release_type))
    if @release.save
      redirect_to @app, notice: 'Release was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /apps/1
  def update
    authorize @release
    if @release.update(release_params)
      redirect_to @app, notice: 'Release was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /apps/1
  def destroy
    authorize @release
    @release.destroy
    redirect_to @app, notice: 'Release was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_app
    @app = App.find(params[:app_id])
  end

  def set_release
    @release = Release.find(params[:id])
  end

  def release_params
    Release.fix_params(params, @app.platform).require(:release).permit(:version, :title, :body, :published, :display_version)
  end
end