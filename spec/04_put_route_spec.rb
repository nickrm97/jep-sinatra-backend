require "spec_helper"

RSpec.describe "PUT /ratingQuestions/:id" do
  context "when the question exists" do
    json = { title: "Hello Mars" }.to_json
    question = nil
    it "returns a 200 OK" do
      post("/ratingQuestions", json, { "CONTENT_TYPE" => "application/json" })
      question = JSON.parse(last_response.body)
      put("/ratingQuestions/#{question["id"]}", json, { "CONTENT_TYPE" => "application/json" })
      expect(last_response.status).to eq(200)
    end

    it "changes just the title attribute" do
      expect(question.is_a?(Hash)).to eq(true)
      expect(question["title"]).to eq("Hello Mars")
      expect(question.key?("tag")).to be true
    end
  end

  context "asking to PUT a question that doesn't exist" do
    it "returns a 404 Not Found" do
      put("/ratingQuestions/i-will-never-exist", {title: "who cares"}.to_json, { "CONTENT_TYPE" => "application/json" })
      expect(last_response.status).to eq(404)
    end
  end
end
