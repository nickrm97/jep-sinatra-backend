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
    JSON.parse(File.read('db.json'))['ratingQuestions']
    # RatingQuestion.all.to_a.to_json
end

def replace_json(updated_questions_data)
    new_json = { "ratingQuestions": updated_questions_data }
    File.open("./db.json", "w"){ |f| f.write(new_json.to_json) }
end

get '/ratingQuestions' do
    # binding.pry
    content_type :json
    rating_questions.to_json
    # RatingQuestion.all.to_json
end

get '/ratingQuestions/:id' do
    target_id = params["id"].to_i
    question = rating_questions.find{ |q| q["id"] == target_id }
    return response.status = 404 if question.nil?

    response.status = 200 
    response.body = question.to_json
    response
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

    new_question = {"title" => json_params["title"], "id" => rating_questions.any? ? rating_questions.last["id"]+1 : 1}    
    new_questions = rating_questions << new_question
    status 201

    # Now lets replace the file with this new array 
    replace_json(new_questions)
    new_question.to_json
end

delete '/ratingQuestions/:id' do
    target_id = params["id"].to_i
    # Return a 404 if it's not in the array 

    question = rating_questions.find{ |q| q["id"] == target_id }
    return response.status = 404 if question.nil?

    new_questions = rating_questions.reject { |q| q["id"] == target_id }

    if new_questions
        # Put the new array into JSON
        replace_json(new_questions)
        response.status = 204 
        # response.body = {}.to_json
    end
    return response
end

put '/ratingQuestions/:id' do
    # In case of empty body
    if (request.body.nil?)
        return response
    end

    target_id = params["id"].to_i
    
    updated_questions = rating_questions
    question = updated_questions.find{ |q| q["id"] == target_id }
   
    if (question.nil? || target_id == 0)
        response.status = 404
        return response
    end

    json_params = JSON.parse(request.body.read) 

    # If all is well and we have a question object, set that shit
    question = {"id": target_id, "title": json_params["title"], tag: json_params["tag"]}.to_json
    response.body = question
    response.status = 200
    response
end

patch '/ratingQuestions/:id' do 
      # In case of empty body
      if (request.body.nil?)
        return response
    end

    target_id = params["id"].to_i
    
    updated_questions = rating_questions
    question = updated_questions.find{ |q| q["id"] == target_id }
   
    if (question.nil? || target_id == 0)
        response.status = 404
        return response
    end

    json_params = JSON.parse(request.body.read) 
    question.merge!(json_params)

    response.body = question
    response.status = 200
    response
end