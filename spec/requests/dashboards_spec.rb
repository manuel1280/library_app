require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  describe "GET /borrowings" do
    it "returns http success" do
      get "/dashboards/borrowings"
      expect(response).to have_http_status(:success)
    end
  end

end
