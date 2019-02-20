require "spec_helper"

RSpec.describe "PATCH /ratingQuestions/:id" do
  context "when the question exists" do
    let(:question) do
      response = HTTP.post("#{SERVER}/ratingQuestions", json: { title: "Hello World" })
      response.parse
    end

    let(:response) { HTTP.patch("#{SERVER}/ratingQuestions/#{question["id"]}", json: { tag: "greetings" })}

    it "returns a 200 OK" do
      expect(response.status).to eq(200)
    end

    it "returns a question -- with an additional field" do
      question = response.parse
      expect(question.is_a?(Hash)).to eq(true)
      expect(question["title"]).to eq("Hello World")
      expect(question["tag"]).to eq("greetings")
    end
  end

  context "asking to get a question that doesn't exist" do
    let(:response) do
      HTTP.patch("#{SERVER}/ratingQuestions/i-will-never-exist", json: { title: "not here"})
    end

    it "returns a 404 Not Found" do
      expect(response.status).to eq(404)
    end
  end
end
