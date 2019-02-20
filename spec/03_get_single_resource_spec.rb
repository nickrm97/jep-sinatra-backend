require "spec_helper"

RSpec.describe "GET /ratingQuestions/:id" do
  context "when the question exists" do
    let(:question) do
      response = HTTP.post("#{SERVER}/ratingQuestions", json: { title: "Hello World" })
      response.parse
    end

    let(:response) { HTTP.get("#{SERVER}/ratingQuestions/#{question["id"]}") }

    it "returns a 200 OK" do
      expect(response.status).to eq(200)
    end

    it "returns a question" do
      expect(response.parse.is_a?(Hash)).to eq(true)
    end
  end

  context "asking to get a question that doesn't exist" do
    let(:response) do
      HTTP.get("#{SERVER}/ratingQuestions/i-will-never-exist")
    end

    it "returns a 404 Not Found" do
      expect(response.status).to eq(404)
    end
  end
end
