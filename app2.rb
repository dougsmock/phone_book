#alternate app.rb

require 'sinatra'
# require 'aws-sdk'
require 'pg'
require 'bcrypt'
load './local_ENV.rb' if File.exists?('./local_ENV.rb')
enable :sessions

db_params = {
  host: ENV['RDS_HOST'],
  dbname: ENV['RDS_DB_NAME'],
  user: ENV['RDS_USERNAME'],
  port: ENV['RDS_PORT'],
  password: ENV['RDS_PASSWORD']
}

client = PG::Connection.new(db_params)

get '/' do
	erb :login_page
  # , locals:{error: "", error2: ""}
end

post '/login_page' do
	loginname = params[:loginname]
	loginname = client.escape(loginname)
	results2 = client.query("SELECT * FROM login WHERE 'Username' = '#{loginname}'")
	pword = params[:pword]
	session[:loginname] = loginname
	logininfo = []
	results2.each do |row|
		logininfo << [[row['Username']], [row['Pword']]]
	end
	logininfo.each do |accounts|
		salt = accounts[1][0].split('')
		salt = salt[0..28].join
		encrypt = BCrypt::Engine.hash_secret(pword, salt)
		if accounts[0][0] == loginname && accounts[1][0] == encrypt
			redirect '/contacts_page'
		end
	end
	erb :login_page, locals:{logininfo: logininfo, error: "Incorrect Username/Password", error2: ""}
end

post '/login_page_new' do
	results2 = client.query("SELECT * FROM login")
	loginname = params[:loginname]
	pword = params[:pword]
	confirmpass = params[:confirmpass]
	session[:loginname] = loginname
	pword = client.escape(pword)
	encryption = BCrypt::Password.create(pword)
	loginname1 = loginname.split('')
	username_arr = []
	results2.each do |row|
		username_arr << row['username']
	end
	end

get '/contacts_page' do
	loginname = session[:loginname]
	loginname = client.escape(loginname)
	results = client.query("SELECT * FROM entry WHERE 'ID'='#{loginname}'")
	info = []
  	results.each do |row|c
    	info << [[row['ID']], [row['Name']], [row['Phone']], [row['Address1']], [row['Address2']], [row['City']], [row['State']], [row['ZIP']], [row['Notes']]]
 	end
	erb :contacts_page, locals:{info: info, loginname: session[:loginname]}
end

post '/contacts_page_add' do
	id = params[:id]
	lastname = params[:lastname]
  firstname = params[:firstname]
	phone = params[:phone]
	address1 = params[:address1]
  address2 = params[:address2]
  city = params[:city]
  state = params[:state]
  zip = params[:zip]
	notes = params[:notes]
	loginname = session[:loginname]
  id = client.escape(id)
  lastname = client.escape(lastname)
  firstname = client.escape(firstname)
  phone = client.escape(phone)
  address1 = client.escape(address1)
  address2 = client.escape(address2)
  city = client.escape(city)
  state = client.escape(state)
  zip = client.escape(zip)
  notes = client.escape(notes)
	loginname = client.escape(loginname)
	client.query("INSERT INTO entry(id, lastname, firstname, phone, address1, address2, city, state, zip, notes)
  	VALUES('#{id}', '#{lastname}', '#{lastname}', '#{phone}', '#{address1}', '#{address2}', '#{city}', '#{state}', '#{zip}', '#{notes}', '#{loginname}')")
  	results = client.query("SELECT * FROM entry WHERE 'ID'='#{loginname}'")
	info = []
  	results.each do |row|
    	info << [[row['ID']], [row['Lastname']], [row['Firstname']], [row['Phone']], [row['Address1']], [row['Address2']], [row['City']], [row['State']], [row['ZIP']], [row['Notes']]]
 	end
	erb :contacts_page, locals:{info: info, loginname: session[:loginname]}
end


post '/contacts_page_update' do
	id_arr = params[:index_arr]
	firstname_arr = params[:firstname_arr]
  lastname_arr = params[:lastname_arr]
	phone_arr = params[:phone_arr]
	address1_arr = params[:address1_arr]
  address2_arr = params[:address2_arr]
  city_arr = params[:city_arr]
  state_arr = params[:state_arr]
  zip_arr = params[:zip_arr]
	notes_arr = params[:notes_arr]
	loginname = session[:loginname]
	loginname = client.escape(loginname)
		results = client.query("SELECT * FROM entry WHERE 'ID'='#{loginname}'")
	info = []
  	results.each do |row|
    	info << [[row['Index']], [row['Lastname']], [row['Firstname']], [row['Phone']], [row['Address1']], [row['Address2']], [row['City']], [row['State']], [row['ZIP']], [row['Notes']]]
 	end
	erb :contacts_page, locals:{info: info, loginname: session[:loginname]}
end

post '/contacts_page_delete' do
	id_arr = params[:id_arr]
  lastname_arr = params[:lastname_arr]
	firstname_arr = params[:firstname_arr]
	phone_arr = params[:phone_arr]
	address1_arr = params[:address1_arr]
  address2_arr = params[:address1_arr]
  city_arr = params[:city_arr]
  state_arr = params[:state_arr]
  zip_arr = params[:zip_arr]
	notes_arr = params[:notes_arr]
	loginname = session[:loginname]
	loginname = client.escape(loginname)

	# number = client.escape(number)
	# client.query("DELETE FROM 'entry' WHERE `Number`='#{number}' AND `Owner`='#{loginname}'")
	# results = client.query("SELECT * FROM entry WHERE `Owner`='#{loginname}'")
	# info = []
  # 	results.each do |row|
  #   	info << [[row['Index']], [row['Name']], [row['Phone']], [row['Address']], [row['Notes']], [row['Owner']], [row['Number']]]
 	# end
	erb :contacts_page, locals:{info: info, loginname: session[:loginname]}
end
