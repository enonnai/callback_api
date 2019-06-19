require 'securerandom'

class HomepageController < ApplicationController
  include HTTParty

  def index
  end

  def create
    response = HTTParty.post('http://mic-leads.dev-test.makeiteasy.com/api/v1/create',
    :body => { :access_token =>     ENV['LEAD_API_ACCESS_TOKEN'],
               :pGUID =>            SecureRandom.uuid,
               :pAccName =>         'Account',
               :pPartner =>         'Partner',
               :name =>             params["contact_form"][:first_name_last_name],
               :business_name =>    params["contact_form"][:business_name],
               :telephone_number => params["contact_form"][:telephone_number],
               :email =>            params["contact_form"][:email]
             },
    :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' } )

    flash.now[:errors] = ErrorFormatter.new.format(response)

    render :index
  end
end
