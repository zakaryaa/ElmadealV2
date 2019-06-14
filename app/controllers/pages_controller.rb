class PagesController < ApplicationController
  def home

  end

  def salons
    @user = User.first
    render 'pages/index.json.jbuilder'
  end

end
