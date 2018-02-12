class PagesController < ApplicationController
  
  before_action :authenticate_user!
  def index
    @purchases = current_user.purchases
    @latest_content = Content.limit(9)
  end
end
