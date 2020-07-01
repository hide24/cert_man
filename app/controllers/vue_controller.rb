class VueController < ApplicationController
  skip_authorization_check
  layout 'vue'

  def index
  end
end
