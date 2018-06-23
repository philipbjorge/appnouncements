class BillingsController < ApplicationController
  before_action :authenticate_user!
  before_action :skip_authorization
  
  def show
  end
end