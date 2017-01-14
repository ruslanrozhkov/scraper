class PagesController < ApplicationController
  def home
    if current_user
      redirect_to movies_url
    end
  end
end
