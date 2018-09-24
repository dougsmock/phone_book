require 'sinatra'
require 'pg'
require_relative 'func.rb'
# require "bcrypt"
enable :sessions
load './local_env.rb' if File.exist?('./local_env.rb')

get "/" do ## makes username and password
message = params[:message]
	if message == nil
		message = "Please Enter Username and Password"
	end
		erb :login, locals:{message:message}
end

post "/create_login" do
	redirect "/make_login"
end

get "/make_login" do ##Register?????
	erb :register
end

post '/register' do
  redirect "/"
end






post "/made_login" do ## on register page
	userid = params[:userid]
	pword = params[:pword]
	message = add_to_login(userid,pword)
	redirect "/?message=" + message
end


post "/login" do
	userid = params[:username]
	pword = params[:password]
	if check_creds?(userid,pword) == true
		redirect "/info"
	else
		message = "Incorrect username or password"
		redirect "/?message=" + message
	end
end

get "/info" do
    erb :phone_form
end






post "/results" do
	info = params[:info]
	answer = add_numbers(info)
	redirect '/resultspage?answer=' + answer
end

get '/resultspage' do
	answer = params[:answer]
	phone_book = database_info()
	erb :results, locals:{answer:answer,phone_book:phone_book}
end

post "/search" do
	lastname = params[:lastname]
	phone = params[:phone]

	if phone == "" and lastname == ""
		session[:search_answer] = "Need search term"
	elsif phone == ""
		session[:search_answer] = search_data_lastname(lastname)
	else
		session[:search_answer] = search_data_phone(phone)
	end
	redirect "/search_answer?"
end

get "/search_answer" do

erb :searchandupdate, locals:{search_answer:session[:search_answer]}
end

post "/update" do
	session[:info] = params[:info]
	choose = params[:choose]
	if session[:info] == nil
		answer = "Didn't Change"
		redirect "/resultspage?answer=" + answer
	else
		if choose == "update"
		   redirect "/update_answer?"
		else
		   redirect "/delete?"
		end
	end

end

get "/update_answer" do
erb :update, locals:{info:session[:info]}
end

post '/updated' do
	answer = "Info Updated"
    updated_info = params[:info]
	updated_slice = updated_info.each_slice(7).to_a
    info = session[:info]
    old_phone = []

  info.each do |row|
  	split = row.split(',')
  	old_phone << split[-1]
  end
   update_table(updated_slice,old_phone)
   redirect "/resultspage?answer=" + answer
end

get "/delete" do
	if session[:info]== nil

	else
		answer = "Info DELETED"
		deleting_info = session[:info]
		delete_from_table(deleting_info)
		redirect "/resultspage?answer=" + answer
	end

end
