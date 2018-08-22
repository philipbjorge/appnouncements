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
      
      @older_releases = @app.releases.published.where("string_to_array(version, '.')::int[] < string_to_array(?, '.')::int[]", params[:start_version]).limit(5) if params[:start_version]
      
      # Mail our users
      if @app.user.notify_on_missing_release?
        if params[:start_version] && @app.releases.published.where("string_to_array(version, '.')::int[] = string_to_array(?, '.')::int[]", params[:start_version]).length == 0
          create_placeholder_release params[:start_version]
        end
        
        if params[:end_version] && params[:start_version] != params[:end_version] && @app.releases.published.where("string_to_array(version, '.')::int[] = string_to_array(?, '.')::int[]", params[:end_version]).length == 0
          create_placeholder_release params[:end_version]
        end
      end
      
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
    
    private
    def create_placeholder_release version
      if @app.releases.where("string_to_array(version, '.')::int[] = string_to_array(?, '.')::int[]", version).length == 0
        r = @app.releases.create!(type: @app.release_type, version: version, published: false, display_version: "unreleased", title: "Placeholder", body: "This is a placeholder release for version #{version} which your users have already started requesting.")
        ApplicationMailer.with(user: current_user, app: @app, release: r).missing_release.deliver_later
      end
    end
  end
end
