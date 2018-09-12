require 'sinatra'
# require 'aws-sdk'
require 'pg'
require 'bcrypt'
load './local_ENV.rb' if File.exists?('./local_ENV.rb')
enable :sessions

db_params = {
  host: ENV['RDS_HOSTNAME'],
  dbname: ENV['RDS_DB_NAME'],
  user: ENV['RDS_USERNAME'],
  port: ENV['RDS_PORT'],
  password: ENV['RDS_PASSWORD']
}

client = PG::Connection.new(db_params)

get '/' do
	erb :login_page, locals:{error: "", error2: ""}
end

post '/login_page' do
  username = params[:username]
  password = params[:password]
  personid = params[:personid]
  # session[:loginname] = loginname
  logininfo = []
  client.query("INSERT INTO login VALUES (UUID(), username, password)")
  results2 = client.query("SELECT personid FROM login WHERE username = '#{username}' AND password = '#{password}'")
  results2.each do |row|
    logininfo << [[row['personid']], [row['Username']], [row['Password']]]
  end

	logininfo.each do |accounts|
		salt = accounts[1][0].split('')
		salt = salt[0..28].join
		encrypt = BCrypt::Engine.hash_secret(password, salt)
		if accounts[0][0] == loginname && accounts[1][0] == encrypt
			redirect '/contacts_page'
		end
		erb :login_page, locals:{logininfo: logininfo, error: "Incorrect Username/Password", error2: ""}
  end
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
		erb :login_page, locals:{error: "", error2: "Check Passwords"}
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
	results = client.query("SELECT * FROM entry WHERE 'ID'='#{loginname}'")
	info = []
  	results.each do |row|
    	info << [[row['ID']], [row['Lastname']], [row['Firstname']], [row['Phone']], [row['Address1']], [row['Address2']], [row['City']], [row['State']], [row['ZIP']], [row['Notes']]]
 	end
	erb :login_page, locals:{info: info, loginname: session[:loginname]}
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
	counter = 0
	unless id_arr == nil
		  id_arr.each do |ind|
			     ind = client.escape(ind)
			     id_arr[counter] = client.escape(id_arr[counter])
           client.query("UPDATE 'entry' SET 'Lastname'='#{lastname_arr[counter]}' WHERE 'ID='#{ind}'")
           lastname_arr[counter] = client.escape(lastname_arr[counter])
           client.query("UPDATE 'entry' SET 'Firstname'='#{name_arr[counter]}' WHERE 'ID'='#{ind}'")
			     phone_arr[counter] = client.escape(phone_arr[counter])
           client.query("UPDATE 'entry' SET 'Phone'='#{phone_arr[counter]}' WHERE 'ID'='#{ind}'")

           address1_arr[counter] = client.escape(address1_arr[counter])
           client.query("UPDATE 'entry' SET 'Address'='#{address1_arr[counter]}' WHERE 'ID'='#{ind}'")
           address2_arr[counter] = client.escape(address2_arr[counter])
           client.query("UPDATE 'entry' SET 'Address'='#{address2_arr[counter]}' WHERE 'ID'='#{ind}'")

           city_arr[counter] = client.escape(address_arr[counter])
           client.query("UPDATE 'entry' SET 'Address'='#{city_arr1[counter]}' WHERE 'ID'='#{ind}'")
           state_arr[counter] = client.escape(address_arr[counter])
           client.query("UPDATE 'entry' SET 'Address'='#{state_arr1[counter]}' WHERE 'ID'='#{ind}'")
           zip_arr[counter] = client.escape(address_arr[counter])
           client.query("UPDATE 'entry' SET 'Address'='#{zip_arr1[counter]}' WHERE 'ID'='#{ind}'")


           notes_arr[counter] = client.escape(notes_arr[counter])
           client.query("UPDATE 'entry' SET 'Notes'='#{notes_arr[counter]}' WHERE 'ID'='#{ind}'")
			     counter += 1
		end
	end
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
	counter = 0
	unless index_arr == nil
		index_arr.each do |ind|
			ind = client.escape(ind)

      client.query("UPDATE 'entry' SET 'Lastname'='#{lastname_arr[counter]}' WHERE 'ID='#{ind}'")
      lastname_arr[counter] = client.escape(lastname_arr[counter])
      client.query("UPDATE 'entry' SET 'Firstname'='#{name_arr[counter]}' WHERE 'ID'='#{ind}'")
      phone_arr[counter] = client.escape(phone_arr[counter])
      client.query("UPDATE 'entry' SET 'Phone'='#{phone_arr[counter]}' WHERE 'ID'='#{ind}'")

      address1_arr[counter] = client.escape(address1_arr[counter])
      client.query("UPDATE 'entry' SET 'Address'='#{address1_arr[counter]}' WHERE 'ID'='#{ind}'")
      address2_arr[counter] = client.escape(address2_arr[counter])
      client.query("UPDATE 'entry' SET 'Address'='#{address2_arr[counter]}' WHERE 'ID'='#{ind}'")

      city_arr[counter] = client.escape(address_arr[counter])
      client.query("UPDATE 'entry' SET 'Address'='#{city_arr1[counter]}' WHERE 'ID'='#{ind}'")
      state_arr[counter] = client.escape(address_arr[counter])
      client.query("UPDATE 'entry' SET 'Address'='#{state_arr1[counter]}' WHERE 'ID'='#{ind}'")
      zip_arr[counter] = client.escape(address_arr[counter])
      client.query("UPDATE 'entry' SET 'Address'='#{zip_arr1[counter]}' WHERE 'ID'='#{ind}'")


      notes_arr[counter] = client.escape(notes_arr[counter])
      client.query("UPDATE 'entry' SET 'Notes'='#{notes_arr[counter]}' WHERE 'ID'='#{ind}'")

			counter += 1
		end
  end
end

	# number = client.escape(number)
	# client.query("DELETE FROM 'entry' WHERE 'Number'='#{number}' AND `Owner`='#{loginname}'")
	# results = client.query("SELECT * FROM entry WHERE `Owner`='#{loginname}'")
	# info = []
  # 	results.each do |row|
  #   	info << [[row['Index']], [row['Name']], [row['Phone']], [row['Address']], [row['Notes']], [row['Owner']], [row['Number']]]
 	# end
	# erb :contacts_page, locals:{info: info, loginname: session[:loginname]}
# end
