require "spec_helper"

RSpec.describe "DELETE /ratingQuestions/:id" do
  context "with an existing question" do
    json = { title: "Hello World" }.to_json
    question = nil
    response_body = nil

    it "returns a 204 No Content" do
      post("/ratingQuestions", json, { "CONTENT_TYPE" => "application/json" })
      question = JSON.parse(last_response.body)
      delete("/ratingQuestions/#{question["id"]}")
      response_body = last_response.body
      expect(last_response.status).to eq(204)
    end

    it "returns nothing" do
      expect(response_body.to_s).to eq('')
    end
  end

  context "asking to delete a question that doesn't exist" do
    it "returns a 404 Not Found" do
      delete("/ratingQuestions/i-will-never-exist")
      expect(last_response.status).to eq(404)
    end
  end
end
