require 'securerandom'
require 'pry'

class HomepageController < ApplicationController
  include HTTParty

  def index
  end

  def create
    begin
      response = send_callback_data
      case response.code
      when 500, 501, 502, 503
        downtime_error
      when 400, 404
        format_errors(response)
      when 200, 201, 202, 203
        success_message
      end
    rescue => e
      downtime_error
    end
    render :index
  end

  private

  def send_callback_data
    HTTParty.post('http://mic-leads.dev-test.makeiteasy.com/api/v1/create',
    :body => { :access_token =>     ENV['LEAD_API_ACCESS_TOKEN'],
               :pGUID =>            SecureRandom.uuid,
               :pAccName =>         'Account',
               :pPartner =>         'Partner',
               :name =>             params["contact_form"][:first_name_last_name],
               :business_name =>    params["contact_form"][:business_name],
               :telephone_number => params["contact_form"][:telephone_number],
               :email =>            params["contact_form"][:email]
             },:headers => { 'Content-Type' => 'application/x-www-form-urlencoded' } )
  end

  def downtime_error
    flash.now[:errors] = ['Sorry, our services are temporarily down. Please try again later. If the problem persists, please contact support.']
  end

  def format_errors(response)
    flash.now[:errors] = ErrorFormatter.new.format(response)
  end

  def success_message
    flash.now[:message] = "Thank you! Your request was submitted successfully! Makeitcheaper will contact you soon."
  end
end
