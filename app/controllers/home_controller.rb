class HomeController < ApplicationController
  def index
    FetchDataJob.perform_later
    # @messages = Message.all
  end
end
