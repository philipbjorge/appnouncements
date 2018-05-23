module Api::V1
  class ReleaseNotesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def show
      skip_authorization

      @app = App.find_by_uuid(params[:uuid])
      not_found unless @app
      @releases = @app.releases

      render layout: "webview"
    end

    def preview
      authenticate_user!

      @app = App.find_by_uuid(params[:uuid])
      not_found unless @app
      authorize @app

      @preview = true
      @releases = [Release.new(params.require(:release).permit(:version, :title, :body, :display_version))]
      render :show, layout: "webview"
    end
  end
end
