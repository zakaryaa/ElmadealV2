class PagesController < ApplicationController
  def home

  end

  def salondata
    @user = User.first
    render 'pages/salondata.json.jbuilder'
  end

end
