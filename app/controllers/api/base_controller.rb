class Api::BaseController < ApplicationController

  # Don't do regular CSRF protection over the json API, rather just ignore the entire session
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

end
