require 'sinatra'
require 'sinatra/reloader'
require 'pry'

require_relative 'environment'
require 'json'


before do
    response.headers["Access-Control-Allow-Methods"] = "POST", "OPTIONS", "PUT", "DELETE", "GET", "PATCH"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers['Access-Control-Allow-Origin'] = 'http://localhost:3000'
    content_type :json
end

options "*" do
    200
end

def rating_questions
    RatingQuestion.all.to_a
end



get '/ratingQuestions' do
    rating_questions.to_json
end

get '/ratingQuestions/:id' do
    target_id = params["id"]
    question = RatingQuestion.find_by(id: target_id)
    return response.status = 404 if question.nil?

    response.status = 202 
    question.to_json
end


delete '/ratingQuestions/:id' do
    target_id = params["id"]
    # Find if the question exists
    q_to_del = RatingQuestion.find_by(_id: target_id)
    return response.status = 404 if q_to_del.nil?

    # If it exists, kill it lol
    response.status = 204
    q_to_del.destroy
    {}
end

post '/ratingQuestions' do
    # If they don't actually send us a body
    if request.body.size.zero?
        response.status = 400 
        response.body = {}.to_json
        return response
    end

    json_params = JSON.parse(request.body.read) 

    # If the title is empty, return an error 
    if json_params["title"] == ''
        response.status = 422
        # TODO: investigate cleaner way of sending errors 
        response.body = {"errors" => {"title" => ["cannot be blank"]}}.to_json
        return response
    end

    # ISSUE: Not working, new_question returns an empty object...why
    new_question = RatingQuestion.new(title: json_params["title"])
    status 201
    new_question.to_json
end
