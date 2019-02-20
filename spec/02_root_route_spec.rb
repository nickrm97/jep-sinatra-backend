require 'spec_helper'

RSpec.describe "GET /ratingQuestions" do
  it "returns a 200 OK" do
    get "/ratingQuestions"
    expect(last_response.status).to eq(200)
  end

  it "returns an array" do
    get "/ratingQuestions"
    questions = JSON.parse(last_response.body)
    expect(questions.is_a?(Array)).to eq(true)
  end
end
