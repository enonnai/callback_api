describe ErrorFormatter do
  describe "#format" do
    subject { described_class.new }
    let(:response) {
      {"message"=>"Format errors on validation",
      "errors"=>
       ["Field 'pGUID' wrong format",
        "Field 'pAccName' is blank",
        "Field 'pPartner' is blank",
        "Field 'name' wrong format, 'name' must be composed with 2 separated words (space between)",
        "Field 'business_name' is blank",
        "Field 'telephone_number' wrong format (must contain have valid phone number with 11 numbers. string max 13 chars)",
        "Field 'email' wrong format"]}
     }

    context "when the 'pAccName' field is blank" do
      it "saves a customer friendly error message in flash" do
        expect(subject.format(response)).to include "Field 'Account Name' is blank"
      end
    end

    context "when the 'name' field has the wrong format" do
      it "saves a customer friendly error message in flash" do
        expect(subject.format(response)).to include "Field 'Fist Name and Last Name' wrong format, 'Fist Name and Last Name' must be composed with 2 separated words (space between)"
      end
    end
  end
end
