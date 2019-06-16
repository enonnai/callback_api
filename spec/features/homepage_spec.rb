require 'rails_helper'

describe 'homepage' do
  describe 'root path' do
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
