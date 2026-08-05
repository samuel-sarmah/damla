module Staff
  class BaseController < ApplicationController
    include Authentication

    layout "staff"

    # Internal staff tool for TRNC staff only — not locale-scoped, Turkish-only
    # views for Phase 0 (see plan: bilingual admin UI is not worth building yet).
    def default_url_options
      {}
    end

    private

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || staff_delivery_orders_path
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_staff_session_path
    end
  end
end
