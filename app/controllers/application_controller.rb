class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken

        private
        def render_not_found
                render json: { error: "Element not found" }, status: :not_found
        end
end
