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

def send_response(response, status, body)
    response.status = status
    response.body = body.to_json
    response
end

def serialize_question(question)
    {
      id: question.id.to_s,
      title: question.title,
      tag: question.tag
    }
end

get '/ratingQuestions' do
    new_questions = RatingQuestion.all.map{ |q| serialize_question(q) }
    return send_response(response, 200, new_questions)
end

get '/ratingQuestions/:id' do
    target_id = params["id"]
    question = RatingQuestion.find_by(_id: target_id)
    return send_response(response, 404, {}) if question.nil?

    return send_response(response, 200, serialize_question(question))
end


delete '/ratingQuestions/:id' do
    target_id = params["id"]
    # Find if the question exists
    q_to_del = RatingQuestion.find(target_id)
    return send_response(response, 404, {}) if q_to_del.nil?

    # If it exists, kill it lol
    q_to_del.destroy
    return send_response(response, 204, {})
end

post '/ratingQuestions' do
    body = request.body.read 
    return send_response(response, 400, nil) if body.size.zero?

    json_params = JSON.parse(body) 
    
    new_question = RatingQuestion.new(title: json_params["title"], tag: json_params["tag"])
    # binding.pry
    if new_question.save
        send_response(response, 201, serialize_question(new_question))
    else
        errors = { "errors" => new_question.errors.messages }
        return send_response(response, 422, errors )
    end    
end

put '/ratingQuestions/:id' do
    # binding.pry
    json_params = JSON.parse(request.body.read) 
    question = RatingQuestion.find_by(id: params["id"])
    return send_response(response, 404, {}) if json_params.nil? || question.nil?

    # If it exists, lets edit it
    question.update(title: json_params["title"], tag: json_params["tag"])
    return send_response(response, 200, serialize_question(question))
end

patch '/ratingQuestions/:id' do
    json_params = JSON.parse(request.body.read) 
    question = RatingQuestion.find_by(id: params["id"])
    return send_response(response, 404, {}) if json_params.nil? || question.nil?

    # Don't replace unless we were given a title - I'm sure this could be written cleaner
    title = json_params["title"].nil? ? question.title : json_params["title"]
    tag = json_params["tag"].nil? ? question.tag : json_params["tag"]

    question.update(title: title, tag: json_params["tag"])
    return send_response(response, 200, serialize_question(question))
end