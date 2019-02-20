require "spec_helper"

RSpec.describe "DELETE /ratingQuestions/:id" do
  context "with an existing question" do
    let(:question) do
      response = HTTP.post("#{SERVER}/ratingQuestions", json: { title: "Hello World" })
      response.parse
    end

    it "actually deletes the question" do
      route = "#{SERVER}/ratingQuestions/#{question["id"]}"
      HTTP.delete(route)
      response = HTTP.get(route)
      expect(response.status).to eq(404)
    end
  end
end
