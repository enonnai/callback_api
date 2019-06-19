class HomepageController < ApplicationController
  include HTTParty

  def index
  end

  def create
    response = HTTParty.post('http://mic-leads.dev-test.makeiteasy.com/api/v1/create',
    :body => { :access_token => ENV['LEAD_API_ACCESS_TOKEN'],
               :pGUID => '-5584-4506-9c6f-5a65e14bfd08',
               :pAccName => '',
               :pPartner => '',
               :name => 'Joajdoajof',
               :business_name => '',
               :telephone_number => '089955857',
               :email => 'guybrushtesterexample.com'
             },
    :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' } )

    flash.now[:errors] = ErrorFormatter.new.format(response)

    render :index
  end
end
