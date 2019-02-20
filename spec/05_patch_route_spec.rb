require "spec_helper"

RSpec.describe "PATCH /ratingQuestions/:id" do
  context "when the question exists" do
    json = { title: "Hello World"}.to_json
    question = nil
    it "returns a 200 OK" do
      post("/ratingQuestions", json, { "CONTENT_TYPE" => "application/json" })
      question = JSON.parse(last_response.body)
      patch("/ratingQuestions/#{question["id"]}", { tag: "greetings" }.to_json, { "CONTENT_TYPE" => "application/json" })
      expect(last_response.status).to eq(200)
    end

    it "returns a question -- with an additional field" do
      binding.pry
      expect(question.is_a?(Hash)).to eq(true)
      expect(question["title"]).to eq("Hello World")
      expect(question["tag"]).to eq("greetings")
    end
  end

  context "asking to get a question that doesn't exist" do
    it "returns a 404 Not Found" do
      patch("/ratingQuestions/i-will-never-exist", { title: "not here"}.to_json, { "CONTENT_TYPE" => "application/json" })
      expect(last_response.status).to eq(404)
    end
  end
end
