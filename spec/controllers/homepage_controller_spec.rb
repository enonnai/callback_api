require 'rails_helper'

RSpec.describe HomepageController do
  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  before(:each) do
    stub_request(:post, "http://mic-leads.dev-test.makeiteasy.com/api/v1/create").
       with(
         body: {"access_token"=>"fb1988cfdd74e7ecb2ea291e2096b44e",
           "business_name"=>"Test business",
           "email"=>"guybrush.threepwood@example.com",
           "name"=>"Guybrush Threepwood",
           "pAccName"=>"Test Account",
           "pGUID"=>"-5584-4506-9c6f-5a65e14bfd08",
           "pPartner"=>"Test Partner",
           "telephone_number"=>"07456333874"},
           headers: {
           'Content-Type'=>'application/x-www-form-urlencoded'
          }
        ).
    to_return(status: 200, body: '{"message":"Enqueue success","errors":[]}', headers: {'Content-Type' => 'application/json'},)
    get :create
  end

  describe "POST create" do
    context "when there are no errors" do
      it "sends the filled in form to the API and renders the index page" do
        expect(response).to render_template("index")
      end

      it "makes a POST request to the Makeiteasy API" do
        expect(WebMock).to have_requested(:post, "http://mic-leads.dev-test.makeiteasy.com/api/v1/create").
        with(body: {"access_token"=>"fb1988cfdd74e7ecb2ea291e2096b44e",
          "business_name"=>"Test business",
          "email"=>"guybrush.threepwood@example.com",
          "name"=>"Guybrush Threepwood",
          "pAccName"=>"Test Account",
          "pGUID"=>"-5584-4506-9c6f-5a65e14bfd08",
          "pPartner"=>"Test Partner",
          "telephone_number"=>"07456333874"},
          headers: {
           'Content-Type'=>'application/x-www-form-urlencoded'
          }
        ).once
      end
    end
  end
end
