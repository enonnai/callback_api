require 'rails_helper'

describe 'Homepage Feature Tests' do
  describe 'main page' do
  	it 'can be reached successfully' do
  		visit root_path
  		expect(page.status_code).to eq(200)
  	end

  	it 'shows the company name' do
  		visit root_path
  		expect(page).to have_content('make it cheaper')
  	end
  end
end

describe "the form completion process", type: :feature do
  context "when the user fills in the form correctly and submits it" do
    let!(:response) { {"message" => "Enqueue success","errors" => []} }
    before do
      allow(SecureRandom).to receive(:uuid).and_return("189a607d-9950-4f8c-845e-20d4b0b4b3f4")
      stub_request(:post, "http://mic-leads.dev-test.makeiteasy.com/api/v1/create").
           with(
             body: {"access_token"=>"fb1988cfdd74e7ecb2ea291e2096b44e", "business_name"=>"Hello Fresh Ltd", "email"=>"beerahoy@example.com", "name"=>"Guybrush Threepwood", "pAccName"=>"Account", "pGUID"=>"189a607d-9950-4f8c-845e-20d4b0b4b3f4", "pPartner"=>"Partner", "telephone_number"=>"07456333214"},
             headers: {
             'Content-Type'=>'application/x-www-form-urlencoded'
             }).
             to_return(status: 200, body: '{"message":"Enqueue success","errors":[]}', headers: {'Content-Type' => 'application/json'},)
    end
    it "re-renders the index page, showing a 'thank you' message" do
      visit '/'
      fill_in 'First name last name', with: 'Guybrush Threepwood'
      fill_in 'Business name', with: 'Hello Fresh Ltd'
      fill_in 'Telephone number', with: '07456333214'
      fill_in 'Email', with: 'beerahoy@example.com'
      click_button 'Submit'

      expect(page).to have_content 'Thank you!'
    end
  end

  context "when the user DOES NOT fill in the form correctly and submits it" do
    let!(:response) { {"message" => "Enqueue success","errors" => []} }
    before do
      allow(SecureRandom).to receive(:uuid).and_return("189a607d-9950-4f8c-845e-20d4b0b4b3f4")
      stub_request(:post, "http://mic-leads.dev-test.makeiteasy.com/api/v1/create").
           with(
             body: {"access_token"=>"fb1988cfdd74e7ecb2ea291e2096b44e", "business_name"=>"123", "email"=>"invalidemail.example.com", "name"=>"Invalidname", "pAccName"=>"Account", "pGUID"=>"189a607d-9950-4f8c-845e-20d4b0b4b3f4", "pPartner"=>"Partner", "telephone_number"=>"78375837862732763"},
             headers: {
             'Content-Type'=>'application/x-www-form-urlencoded'
             }).
             to_return(status: 400, body: "{\"message\":\"Format errors on validation\",\"errors\":[\"Field 'name' wrong format, 'name' must be composed with 2 separated words (space between)\",\"Field 'telephone_number' wrong format (must contain have valid phone number with 11 numbers. string max 13 chars)\",\"Field 'email' wrong format\"]}", headers: {'Content-Type' => 'application/json'},)
    end
    it "re-renders the index page, showing validation errors" do
      visit '/'
      fill_in 'First name last name', with: 'Invalidname'
      fill_in 'Business name', with: '123'
      fill_in 'Telephone number', with: '78375837862732763'
      fill_in 'Email', with: 'invalidemail.example.com'
      click_button 'Submit'

      expect(page).not_to have_content 'Thank you!'
      expect(page).not_to have_content "Field 'name' wrong format, 'name' must be composed with 2 separated words (space between)"
    end
  end
end
