module Api::V1
  class ReleaseNotesController < ApplicationController
    def show
      skip_authorization
      @app = App.find_by_uuid(params[:uuid])
      not_found unless @app
      render layout: "webview"
    end
  end
end
