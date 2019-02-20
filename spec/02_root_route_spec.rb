require 'spec_helper'

RSpec.describe "GET /ratingQuestions" do
  let(:response) { HTTP.get("#{SERVER}/ratingQuestions") }

  it "returns a 200 OK" do
    expect(response.status).to eq(200)
  end

  it "returns an array" do
    expect(response.parse.is_a?(Array)).to eq(true)
  end
end
