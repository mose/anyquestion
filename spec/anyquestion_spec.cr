require "./spec_helper"

describe "Anyquestion web" do
  # TODO: Write tests

  it "works" do
    false.should eq(true)
  end

  it "loads homepage" do
    client_response = http_request("GET", "/")
    client_response.body.should match /Any Question/
  end
end
