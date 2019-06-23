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
    context "and the form failed to submit due to an error" do

      before do
        allow(SecureRandom).to receive(:uuid).and_return("189a607d-9950-4f8c-845e-20d4b0b4b3f4")
        stub_request(:post, "http://mic-leads.dev-test.makeiteasy.com/api/v1/create").
             with(
               body: {"access_token"=>"fb1988cfdd74e7ecb2ea291e2096b44e", "business_name"=>"Hello Fresh Ltd", "email"=>"hello@example.com", "name"=>"Guybrush Threepwood", "pAccName"=>"Account", "pGUID"=>"189a607d-9950-4f8c-845e-20d4b0b4b3f4", "pPartner"=>"Partner", "telephone_number"=>"07456333214"},
               headers: {
               'Content-Type'=>'application/x-www-form-urlencoded'
               }).
               to_return(status: [500, "Internal Server Error"])
      end

      it "displays a customer friendly error message" do
        visit '/'
        fill_in 'First name last name', with: 'Guybrush Threepwood'
        fill_in 'Business name', with: 'Hello Fresh Ltd'
        fill_in 'Telephone number', with: '07456333214'
        fill_in 'Email', with: 'hello@example.com'
        click_button 'Submit'

        expect(page).to have_content 'Sorry, our services are temporarily down. Please try again later. If the problem persists, please contact support.'
      end
    end

    context "and the form is successfully submitted" do
      let!(:response) { {"message" => "Enqueue success","errors" => []} }

      before do
        allow(SecureRandom).to receive(:uuid).and_return("189a607d-9950-4f8c-845e-20d4b0b4b3f4")
        stub_request(:post, "http://mic-leads.dev-test.makeiteasy.com/api/v1/create").
             with(
               body: {"access_token"=>"fb1988cfdd74e7ecb2ea291e2096b44e", "business_name"=>"Hello Fresh Ltd", "email"=>"hello@example.com", "name"=>"Guybrush Threepwood", "pAccName"=>"Account", "pGUID"=>"189a607d-9950-4f8c-845e-20d4b0b4b3f4", "pPartner"=>"Partner", "telephone_number"=>"07456333214"},
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
        fill_in 'Email', with: 'hello@example.com'
        click_button 'Submit'

        expect(page).to have_content 'Thank you! Your request was submitted successfully! Makeitcheaper will contact you soon.'
      end
    end
  end

  context "when the user DOES NOT fill in the form correctly and submits it" do
    let!(:response) { {"message" => "Format errors on validation","errors" => ["Field 'name' wrong format, 'name' must be composed with 2 separated words (space between)","Field 'telephone_number' wrong format (must contain have valid phone number with 11 numbers. string max 13 chars)","Field 'email' wrong format"]} }

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

    it "re-renders the index page, showing formatted validation errors" do
      visit '/'
      fill_in 'First name last name', with: 'Invalidname'
      fill_in 'Business name', with: '123'
      fill_in 'Telephone number', with: '78375837862732763'
      fill_in 'Email', with: 'invalidemail.example.com'
      click_button 'Submit'

      expect(page).not_to have_content "Thank you! Your request was submitted successfully! Makeitcheaper will contact you soon."
      expect(page).to have_content "Field 'Fist Name and Last Name' wrong format, 'Fist Name and Last Name' must be composed with 2 separated words (space between)"
      expect(page).to have_content "Field 'Telephone Number' wrong format (must contain have valid phone number with 11 numbers. string max 13 chars)"
      expect(page).to have_content "Field 'Email' wrong format"
    end
  end
end
