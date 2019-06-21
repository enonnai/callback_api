require 'rails_helper'

RSpec.describe HomepageController do
  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "POST create" do
    before(:each) do
      allow(SecureRandom).to receive(:uuid).and_return("189a607d-9950-4f8c-845e-20d4b0b4b3f4")

      stub_request(:post, "http://mic-leads.dev-test.makeiteasy.com/api/v1/create").
         with(
           body: {"access_token"=>"fb1988cfdd74e7ecb2ea291e2096b44e",
                   "business_name"=>    "Hello Fresh Ltd",
                   "email"=>            "hello@example.com",
                   "name"=>             "Guybrush Threepwood",
                   "pAccName"=>         "Account",
                   "pGUID"=>            "189a607d-9950-4f8c-845e-20d4b0b4b3f4",
                   "pPartner"=>         "Partner",
                   "telephone_number"=> "07456888596"},
             headers: {
               'Content-Type'=>'application/x-www-form-urlencoded'
            }
          ).
      to_return(status: 200, body: '{"message":"Enqueue success","errors":[]}', headers: {'Content-Type' => 'application/json'},)
      post :create, params: {"contact_form"=>{"first_name_last_name"=>"Guybrush Threepwood", "business_name"=>"Hello Fresh Ltd", "telephone_number"=>"07456888596", "email"=>"hello@example.com"} }
    end

    it "renders the index page" do
      expect(response).to render_template("index")
    end

    it "makes a POST request to the Makeiteasy API" do
      expect(WebMock).to have_requested(:post, 'http://mic-leads.dev-test.makeiteasy.com/api/v1/create').
      with(body: 'access_token=fb1988cfdd74e7ecb2ea291e2096b44e&pGUID=189a607d-9950-4f8c-845e-20d4b0b4b3f4&pAccName=Account&pPartner=Partner&name=Guybrush%20Threepwood&business_name=Hello%20Fresh%20Ltd&telephone_number=07456888596&email=hello%40example.com',
        headers: {
         'Content-Type'=>'application/x-www-form-urlencoded'
        }
      ).once
    end
  end
end
