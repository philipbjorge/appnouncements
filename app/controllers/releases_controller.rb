class ReleasesController < ApplicationController
  include LoggedIn

  # TODO: Add Pundit

  before_action :set_app, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_release, only: [:edit, :update, :destroy]

  # GET /apps/1/releases/new
  def new
    authorize @app
    @release = @app.releases.build
  end

  # GET /apps/1/edit
  def edit
    authorize @app
  end

  # POST /apps
  def create
    authorize @app
    @release = @app.releases.build(release_params)
    if @release.save
      redirect_to @app, notice: 'Release was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /apps/1
  def update
    authorize @app
    puts(release_params)
    if @release.update(release_params)
      redirect_to @app, notice: 'Release was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /apps/1
  def destroy
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
    params.require(:release).permit(:version, :title, :body, :draft)
  end
end