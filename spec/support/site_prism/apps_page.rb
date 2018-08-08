require "tedium"

class ConfirmDeleteModal < SitePrism::Section
  element :confirm_input, ".modal-body input"
  element :confirm_btn, ".modal-footer .btn-danger"
end

class ApplicationLayoutBase < SitePrism::Page
  elements :flash_messages, "#flash-container .alert"
end

class AppsPage < ApplicationLayoutBase
  set_url "/apps"

  sections :apps, ".app-item" do
    element :title, ".card-title"
    element :platform, ".card-subtitle"
    element :view_releases_btn, ".view-releases-btn"
  end
  
  section :no_apps_card, "#no-apps-card", text: "You don't have any apps" do
    element :new_app_btn, "#new-app-btn"
  end
  
  section :toolbar, "#apps-toolbar" do
    element :new_app_btn, "#new-app-btn"
  end
end

class NewAppPage < ApplicationLayoutBase
  set_url "/apps/new"
  
  fields :platform, :display_name, :color
  submit_button

  submission :new_app
end

class NewAndroidReleasePage < ApplicationLayoutBase
  set_url "/apps{/app_id}/releases/new"

  fields :title, :version, :display_version, :body, :published
  submit_button

  submission :new_release
end

class EditAndroidReleasePage < ApplicationLayoutBase
  set_url "/apps{/app_id}/releases{/release_id}/edit"

  fields :title, :version, :display_version, :body, :published
  submit_button

  submission :edit_release
end

class AppDetailsPage < ApplicationLayoutBase
  set_url "/apps{/app_id}"

  section :confirm_delete_modal, ConfirmDeleteModal, ".data-confirm-modal"
  
  sections :release_list, ".release-list-item" do
    element :title, ".release-title"
    element :version, ".release-title .badge"
    element :body, ".release-preview"
    element :edit_btn, ".edit-release-btn"
    element :delete_btn, ".delete-release-btn"
  end
  
  section :no_releases_card, "#no-releases-card", text: "You don't have any releases" do
    element :new_release_btn, "#new-release-btn"
  end

  section :toolbar, "#releases-toolbar" do
    element :title, "h3"
    element :new_release_btn, "#new-release-btn"
  end
end

class EditAppPage < ApplicationLayoutBase
  set_url "/apps{/app_id}/edit"
  
  element :delete_btn, "#delete-app-btn"
  
  section :confirm_delete_modal, ConfirmDeleteModal, ".data-confirm-modal"
  
  fields :display_name, :color
  submit_button
  
  submission :edit_app
end

class SDKIntegrationPage < ApplicationLayoutBase
  set_url "/apps{/app_id}/integration"

  element :title, "#sdk-integration .title"
  element :content, "#sdk-integration .content"
end