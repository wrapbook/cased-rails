class HomeController < ApplicationController
  def index
    Cased.publish({})
  end
end
