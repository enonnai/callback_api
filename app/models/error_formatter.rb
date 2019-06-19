class ErrorFormatter

  FIELD_NAMES = {
    "pAccName" => "'Account Name'",
    "pPartner" => "'Partner Name'",
    "name" => "'Fist Name and Last Name'",
    "business_name" => "'Business Name'",
    "telephone_number" => "'Telephone Number'",
    "email" => "'Email'"
  }

  def format(response)
    errors = []
    if response['errors'].any?
      response_errors = response['errors']
      response_errors.each do |message|
        if message.split[1] != "'pGUID'"
          quoteless_string = message.split[1].gsub("'", "")
          errors << message.gsub(message.split[1], FIELD_NAMES[quoteless_string])
        end
      end
    end
    errors
  end
end
