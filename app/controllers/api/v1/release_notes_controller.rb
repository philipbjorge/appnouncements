module Api::V1
  class ReleaseNotesController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :skip_authorization, only: [:show, :configuration]

    def show
      @app = App.find_by(uuid: params[:uuid], disabled: false)
      not_found unless @app

      # TODO: Validate start/end_version
      @releases = @app.releases.published
      @releases = @releases.where("string_to_array(version, '.')::int[] >= string_to_array(?, '.')::int[]", params[:start_version]) if params[:start_version]
      @releases = @releases.where("string_to_array(version, '.')::int[] <= string_to_array(?, '.')::int[]", params[:end_version]) if params[:end_version]
    
      render layout: "webview"
    end
    
    def configuration
      @app = App.find_by(uuid: params[:uuid])
      not_found unless @app
      
      # TODO: Validate start/end_version
      @releases = []
      if params[:start_version] != params[:end_version]
        @releases = @app.releases.published
        @releases = @releases.where("string_to_array(version, '.')::int[] >= string_to_array(?, '.')::int[]", params[:start_version]) if params[:start_version]
        @releases = @releases.where("string_to_array(version, '.')::int[] <= string_to_array(?, '.')::int[]", params[:end_version]) if params[:end_version]
      end

      render json: {
          unseenReleasesCount: @releases.size,
          disabled: @app.disabled
      }
    end

    def preview
      authenticate_user!

      @app = App.find_by(uuid: params[:uuid])
      not_found unless @app
      authorize @app

      @preview = true
      @releases = [Release.new(Release.fix_params(params, @app.platform).require(:release).permit(:version, :title, :body, :display_version).merge(type: @app.release_type))]
      render :show, layout: "webview"
    end
  end
end
