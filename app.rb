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
	# add create function
	redirect "/make_login"
end

get "/make_login" do
	erb :make_login
end

post '/make_login' do
	p "Hello World"
		userid = params[:userid]
		pword = params[:pword]
	p "Here, have a side order of #{params}."
		message = add_to_login(userid,pword)
		# if message == "Username or Password Taken"
		# 	redirect "/?message=" + message
		# elsif
		# 	message == "Login Created"
			redirect "/"
		# end
end

get '/register2' do
	"Hello World Again!"
	erb :login
end


get "/" do
	message = params[:message]
	if message == nil
		message = "Please Enter Username and Password"
	end
		erb :login, locals:{message:message}
end

post '/login' do ##couldn't check creds here
	p "Hello Canadians"

	redirect '/logged_in'
end

get '/logged_in' do
	erb :welcome
end


post '/welcome_new' do
	p "Hello Fresh People"

	puts "Do we have #{params}?"
	firstname = params[:firstname]
	lastname = params[:lastname]
	phone = params[:phone]
	address1 = params[:address1]
	address2 = params[:address2]
	city = params[:city]
	state = params[:state]
	zip = params[:zip]

	add_numbers()
  redirect "/phone_form"
end

get '/phone_form' do
	erb :phone_form
end

post '/filling_form' do
	p "Yo."
	redirect '/back_to_welcome'
end

get '/back_to_welcome' do
	erb :welcome
end


post '/welcome_new' do
	p "Yo you too."

	puts "Do we have #{params}?"
	firstname = params[:firstname]
	lastname = params[:lastname]
	phone = params[:phone]
	address1 = params[:address1]
	address2 = params[:address2]
	city = params[:city]
	state = params[:state]
	zip = params[:zip]

	add_numbers()
  redirect "/phone_form"
end

post '/welcome_update' do
	p "Yeah, right."

	p "Look at these #{params}"
	info_new = params[:info_new]
	old_phone = params[:old_phone]
	changes = params[:changes]
	changes = update_table(info_new, old_phone)
  redirect "/welcomed_update"
end

post '/welcome_search' do
	p "Hello Dingbats"

  redirect "/welcomed_search"
end

post '/welcome_delete' do
	p "Hello Santa Claus."

  redirect "/welcomed_delete"
end




get "/welcomed_new" do
	erb :phone_form
end



get "/welcomed_update" do
	erb :update, locals:{info:session[:info]}
end

# get "/update_answer" do ##similar to above
# erb :update, locals:{info:session[:info]}
# end
#




get "/welcomed_search" do
	erb :searchandupdate
end

get "/welcomed_delete" do
	erb :deleted
end

post '/phone_form' do
	p "Hello Julius"

  "You have a new record, maybe."
end

post '/update' do
  p "Hello Update World"
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

# post '/updated' do ###similar to above item
# 	answer = "Info Updated"
#     updated_info = params[:info]
# 	updated_slice = updated_info.each_slice(7).to_a
#     info = session[:info]
#     old_phone = []
#
#   info.each do |row|
#   	split = row.split(',')
#   	old_phone << split[-1]
#   end
#    update_table(updated_slice,old_phone)
#    redirect "/resultspage?answer=" + answer
# end

post "/searchandupdate" do
	"Hello somebody."
	lastname = params[:lastname]
	phone = params[:phone]

	if phone == "" && lastname == ""
		session[:search_answer] = "Need search term."
	elsif phone == ""
		session[:search_answer] = search_data_lastname(lastname)
	else
		session[:search_answer] = search_data_phone(phone)
	end
	redirect "/search_answer?"
end

post '/phone_form' do
  p "Hello Deleted World"
end


#
#
#
#
#
#
#
#
#
# post "/login" do ### add check creds last
# 	userid = params[:username]
# 	pword = params[:password]
# 	if check_creds?(userid,pword) == true
# 		redirect "/info"
# 	else
# 		message = "Incorrect username or password"
# 		redirect "/?message=" + message
# 	end
# end
#
#
#
#
#
#
# post "/results" do
# 	info = params[:info]
# 	answer = add_numbers(info)
# 	redirect '/resultspage?answer=' + answer
# end
#
# get '/resultspage' do
# 	answer = params[:answer]
# 	phone_book = database_info()
# 	erb :results, locals:{answer:answer,phone_book:phone_book}
# end
#
#
#
#
#

#
# get "/search_answer" do
#
# erb :searchandupdate, locals:{search_answer:session[:search_answer]}
# end
#
# post "/update" do
# 	session[:info] = params[:info]
# 	choose = params[:choose]
# 	if session[:info] == nil
# 		answer = "Didn't Change"
# 		redirect "/resultspage?answer=" + answer
# 	else
# 		if choose == "update"
# 		   redirect "/update_answer?"
# 		else
# 		   redirect "/delete?"
# 		end
# 	end
#
# end
#

#
# get "/delete" do
# 	if session[:info]== nil
#
# 	else
# 		answer = "Info DELETED"
# 		deleting_info = session[:info]
# 		delete_from_table(deleting_info)
# 		redirect "/resultspage?answer=" + answer
# 	end
#
# end
