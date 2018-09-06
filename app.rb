require 'sinatra'
require 'aws-sdk'
require 'mysql2'
require 'bcrypt'
load 'local_ENV.rb' if File.exist?('local_ENV.rb')
enable :sessions
client = Postgresql::Client.new(:person_id => ENV['RDS_PERSON_ID'], :username => ENV['RDS_USERNAME'], :password => ENV['RDS_PASSWORD'], :host => ENV['RDS_HOSTNAME'], :port => ENV['RDS_PORT'], :database => ENV['RDS_DB_NAME'], :socket => '/tmp/mysql.sock')

get '/' do
	erb :login, locals:{error: "", error2: ""}
end

post '/login_page' do
  loginname = params[:loginname]
	loginname = client.escape(loginname)
  results2 = client.query("SELECT * FROM login WHERE 'Last Name' = '#{loginname}'")
  password = params[:password]
  session[:loginname] = loginname
  logininfo = []
  results2.each do |row|
  	logininfo << [[row['username']], [row['password']]]
  end
  logininfo.each do |accounts|
		salt = accounts[1][0].split('')
		salt = salt[0..28].join
		encrypt = BCrypt::Engine.hash_secret(password, salt)
		if accounts[0][0] == loginname && accounts[1][0] == encrypt
			redirect '/contacts_page'
		end
	end
	  erb :login_page, locals:{logininfo: logininfo, error: "Incorrect Username/Password", error2: ""}
end

post '/login_page_new' do
  results2 = client.query("SELECT * FROM login")
	loginname = params[:loginname]
	password = params[:password]
	confirmpass = params[:confirmpass]
	session[:loginname] = loginname
	password = client.escape(password)
	encryption = BCrypt::Password.create(password)
	loginname1 = loginname.split('')
	counter = 0
	loginname1.each do |elements|
		if elements == " "
			counter += 1
		end
	end
	username_arr = []
	results2.each do |row|
		username_arr << row['username']
	end
	if counter >= 2
		erb :login_page, locals:{error: "", error2: "Invalid Username Format"}
	elsif username_arr.include?(loginname)
		erb :login_page, locals:{error: "", error2: "Username Already Exists"}
	elsif password != confirmpass
		erb :login_page, locals:{error: "", error2: "Check Password"}
	else
		loginname = client.escape(loginname)
		client.query("INSERT INTO login(username, password)
  		VALUES('#{loginname}', '#{encryption}')")
   		redirect '/contacts_page'
   	end
end

get '/contacts_page' do
	loginname = session[:loginname]
	loginname = client.escape(loginname)
	results = client.query("SELECT * FROM numbers WHERE 'Last Name'='#{loginname}'")
	info = []
  	results.each do |row|
    	info << [[row['Name ID']], [row['Last Name']], [row['First Name']], [row['Phone No']], [row['Address1']], [row['Address2']], [row['city']], [row['state']], [row['zip']], [row['notes']]]
 	end

	erb :contacts_page, locals:{info: info, loginname: session[:loginname]}
end


post '/contacts_page_add' do
	nameID = params[:nameID]
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
	nameID = client.escape(nameID)
	lastname = client.escape(lastname)
	phone = client.escape(phone)
	address1 = client.escape(address1)
	address2 = client.escape(address2)
	city = client.escape(city)
	state = client.escape(state)
	zip = client.escape(zip)
	notes = client.escape(notes)
	loginname = client.escape(loginname)
	client.query("INSERT INTO numbers(nameID, lastname, firstname, phone, address1, address2, city, state, zip, notes)
  	VALUES('#{nameID}', '#{lastname}', '#{firstname}','#{phone}', '#{address1}', '#{address2}',#{city}',#{state}',#{zip}','#{notes}', '#{loginname}')")
  	results = client.query("SELECT * FROM numbers WHERE `Owner`='#{loginname}'")
	info = []
  	results.each do |row|
    	info << [[row['Name ID']], [row['Last Name']], [row['First Name']], [row['Phone']], [row['Address 1']], [row['Address 2']], [row['city']], [row['state']], [row['zip']], [row['notes']]]
 	end
	erb :contacts_page, locals:{info: info, loginname: session[:loginname]}
end

post '/contacts_page_update' do
	nameID_arr = params[:nameID_arr]
	lastname_arr = params[:lastname_arr]
	firstname_arr = params[:first_arr]
	phone_arr = params[:phone_arr]
	address1_arr = params[:address1_arr]
	address2_arr = params[:address2_arr]
	city_arr = params[:city_arr]
	state_arr = params[:state_arr]
	zip_arr = params[:zip_arr]
	notes_arr = params[:notes_arr]
	loginname = session[:loginname]
	loginname = client.escape(loginname)
	counter = 0
	unless index_arr == nil
			index_arr.each do |ind|
				ind = client.escape(ind)
				nameID_arr[counter] = client.escape(number_arr[counter])
				client.query("UPDATE 'number' SET 'Name ID'='#{number_arr[counter]}' WHERE 'Name ID'='#{ind}' AND 'Last Name'='#{loginname}'")
				lastname_arr[counter] = client.escape(lastname_arr[counter])
				client.query("UPDATE 'number' SET 'Last Name'='#{lastname_arr[counter]}' WHERE 'Last Name'='#{ind}'='#{loginname}'")
				firstname_arr[counter] = client.escape(firstname_arr[counter])
				client.query("UPDATE 'number' SET 'First Name'='#{name_arr[counter]}' WHERE 'First Name'='#{ind}' AND 'Last Name'='#{loginname}'")
				phone_arr[counter] = client.escape(phone_arr[counter])
				client.query("UPDATE 'number' SET 'Phone'='#{phone_arr[counter]}' WHERE 'Phone'='#{ind}' AND 'Last Name'='#{loginname}'")
				address1_arr[counter] = client.escape(address1_arr[counter])
				client.query("UPDATE 'number' SET 'Address 1'='#{address_arr[counter]}' WHERE 'Address 1'='#{ind}' AND 'Last Name'='#{loginname}'")
				address2_arr[counter] = client.escape(address2_arr[counter])
				client.query("UPDATE 'number' SET 'Address 2'='#{address_arr[counter]}' WHERE 'Address 2'='#{ind}' AND 'Last Name'='#{loginname}'")
				city_arr[counter] = client.escape(address2_arr[counter])
				client.query("UPDATE 'number' SET 'city'='#{address_arr[counter]}' WHERE 'city'='#{ind}' AND 'Last Name'='#{loginname}'")
				state_arr[counter] = client.escape(state_arr[counter])
				client.query("UPDATE 'number' SET 'state'='#{address_arr[counter]}' WHERE 'state'='#{ind}' AND 'Last Name'='#{loginname}'")
				zip_arr[counter] = client.escape(zip_arr[counter])
				client.query("UPDATE 'number' SET 'zip'='#{address_arr[counter]}' WHERE 'zip'='#{ind}' AND 'Last Name'='#{loginname}'")
				notes_arr[counter] = client.escape(notes_arr[counter])
				client.query("UPDATE 'number' SET 'notes'='#{notes_arr[counter]}' WHERE 'notes'='#{ind}' AND 'Last Name'='#{loginname}'")
				counter += 1
			end
		end
		results = client.query("SELECT * FROM numbers WHERE 'Last Name'='#{loginname}'")
		info = []
		results.each do |row|
		info << [[row['Name ID']], [row['Last Name']], [row['First Name']], [row['Phone']], [row['Address1']], [row['Address2']], [row['city']], [row['state']], [row['zip']], [row['notes']]]
		end
 		erb :contacts_page, locals:{info: info, loginname: session[:loginname]}
end


		post '/contacts_page_delete' do
			nameID_arr = params[:nameID_arr]
			lastname_arr = params[:lastname_arr]
			firstname_arr = params[:first_arr]
			phone_arr = params[:phone_arr]
			address1_arr = params[:address1_arr]
			address2_arr = params[:address2_arr]
			city_arr = params[:city_arr]
			state_arr = params[:state_arr]
			zip_arr = params[:zip_arr]
			notes_arr = params[:notes_arr]
			loginname = session[:loginname]
			loginname = client.escape(loginname)
			counter = 0
			unless index_arr == nil
					index_arr.each do |ind|
						ind = client.escape(ind)
						nameID_arr[counter] = client.escape(number_arr[counter])
						client.query("UPDATE 'number' SET 'Name ID'='#{number_arr[counter]}' WHERE 'Name ID'='#{ind}' AND 'Last Name'='#{loginname}'")
						lastname_arr[counter] = client.escape(lastname_arr[counter])
						client.query("UPDATE 'number' SET 'Last Name'='#{lastname_arr[counter]}' WHERE 'Last Name'='#{ind}'='#{loginname}'")
						firstname_arr[counter] = client.escape(firstname_arr[counter])
						client.query("UPDATE 'number' SET 'First Name'='#{name_arr[counter]}' WHERE 'First Name'='#{ind}' AND 'Last Name'='#{loginname}'")
						phone_arr[counter] = client.escape(phone_arr[counter])
						client.query("UPDATE 'number' SET 'Phone'='#{phone_arr[counter]}' WHERE 'Phone'='#{ind}' AND 'Last Name'='#{loginname}'")
						address1_arr[counter] = client.escape(address1_arr[counter])
						client.query("UPDATE 'number' SET 'Address 1'='#{address_arr[counter]}' WHERE 'Address 1'='#{ind}' AND 'Last Name'='#{loginname}'")
						address2_arr[counter] = client.escape(address2_arr[counter])
						client.query("UPDATE 'number' SET 'Address 2'='#{address_arr[counter]}' WHERE 'Address 2'='#{ind}' AND 'Last Name'='#{loginname}'")
						city_arr[counter] = client.escape(address2_arr[counter])
						client.query("UPDATE 'number' SET 'city'='#{address_arr[counter]}' WHERE 'city'='#{ind}' AND 'Last Name'='#{loginname}'")
						state_arr[counter] = client.escape(state_arr[counter])
						client.query("UPDATE 'number' SET 'state'='#{address_arr[counter]}' WHERE 'state'='#{ind}' AND 'Last Name'='#{loginname}'")
						zip_arr[counter] = client.escape(zip_arr[counter])
						client.query("UPDATE 'number' SET 'zip'='#{address_arr[counter]}' WHERE 'zip'='#{ind}' AND 'Last Name'='#{loginname}'")
						notes_arr[counter] = client.escape(notes_arr[counter])
						client.query("UPDATE 'number' SET 'notes'='#{notes_arr[counter]}' WHERE 'notes'='#{ind}' AND 'Last Name'='#{loginname}'")
						counter += 1
					end

				nameID = client.escape(nameID)
				client.query("DELETE FROM 'number' WHERE 'Name ID'='#{number}' AND 'Last Name'='#{loginname}'")
				results = client.query("SELECT * FROM number WHERE 'Last Name'='#{loginname}'")
				info = []
  			results.each do |row|
    		info << [[row['Name ID']], [row['Last Name']], [row['First Name']], [row['Phone']], [row['Address1']], [row['Address2']], [row['city']], [row['state']], [row['zip']], [row['Notes']]]
 				end
				erb :contacts_page, locals:{info: info, loginname: session[:loginname]}
end
end
