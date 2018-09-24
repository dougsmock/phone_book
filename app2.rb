require 'sinatra'
require 'pg'
# require 'bcrypt'
# require 'securerandom'
load './local_ENV.rb' if File.exists?('./local_ENV.rb')
enable :sessions
#
#
#
# #############################

conn = PG::Connection.open(:host => ENV['RDS_HOST'], :dbname => ENV['RDS_DB_NAME'], :user => ENV['RDS_USERNAME'], :password => ENV['RDS_PASSWORD'], :port => ENV['RDS_PORT'])

def prepare_statements(conn)
	# conn.prepare("newuser4", "insert into login (uuid, userid, pword) values ($1, $2, $3)")
	conn.prepare("cons", "insert into numbers (lastname, firstname, phone, address1, address2, city, state, zip) values($1, $2, $3, $4, $5, $6, $7, $8)")
end
prepare_statements(conn)

#
# ###############################
#
# get '/' do
# 	erb :login_page, locals:{error: "", error2: ""}
# end
#
# post '/login_page' do
#   uuid = params[:uuid]
#   pword = params[:pword]
#   userid = params[:userid]
#   loginname = params[:loginname]
#   session[:loginname] = loginname
#   logininfo = []
#   conn.exec_prepared('newuser4', [uuid, params[:userid], params[:pword]])
#   results2 = conn.query("SELECT uuid FROM login WHERE userid = '#{userid}' AND pword = '#{pword}'")
#   results2.each do |row|
#     logininfo << [[row['uuid']], [row['userid']], [row['pword']]]
#   end
#
# 	logininfo.each do |accounts|
# 		salt = accounts[1][0].split('')
# 		salt = salt[0..28].join
# 		encrypt = BCrypt::Engine.hash_secret(pword, salt)
# 		if (accounts[0][0] == loginname) && (accounts[1][0] == encrypt)
# 			redirect '/phone_form'
#     end
#   end
#   erb :phone_form, locals:{loginname: loginname, logininfo: logininfo, error: "Incorrect Username/Password", error2: ""}
# end
#
#
# get '/login_page' do
#   erb :register, locals:{loginname: loginname, logininfo: logininfo, error: "Incorrect Username/Password", error2: ""}
#   erb :phone_form, locals:{loginname: loginname, logininfo: logininfo, error: "Incorrect Username/Password", error2: ""}
# end
#
# post '/register1' do
#   erb :register, locals:{error: "Incorrect Username/Password", error2: ""}
# end
#
# post '/register' do
#   uuid = 0
#   p "Look here #{params}"
# 	results2 = conn.query("SELECT * FROM login")
# 	loginname = params[:loginname]
#   pword = params[:password]
# 	confirmpass = params[:confirmpass]
# 	# session[:loginname] = loginname
#   #
#   # unless pword == nil
#   #   pword = conn.escape(pword)
#   # end
#
#   encryption = BCrypt::Password.create(pword)
#   unless loginname == nil
#     loginname1 = loginname.split('')
#   end
#   counter = 0
#   p "Reaching login #{loginname1}"
# 	loginname1.each do |elements|
# 		if elements == " "
# 			counter += 1
# 		end
# 	end
# 	userid_arr = []
# 	results2.each do |row|
# 		userid_arr << row['userid']
# 	end
# 	# if counter >= 2
# 	# 	erb :login_page, locals:{error: "", error2: "Invalid Username Format"}
# 	# elsif userid_arr.include?(loginname)
# 	# 	erb :login_page, locals:{error: "", error2: "Username Already Exists"}
# 	# elsif pword != confirmpass
# 	# 	erb :login_page, locals:{error: "", error2: "Check Passwords"}
# 	# else
#   p "#{pword}"
# 		loginname = conn.escape(loginname)
# 		conn.query("INSERT INTO login(uuid, userid, pword) VALUES('#{uuid}, #{loginname}, #{pword}')");
#    		redirect '/phone_form' #for updating stuff.
#    	# end
# end
#
# post '/phone_form' do
#   lastname = params[:lastname]
#   firstname = params[:firstname]
# 	phone = params[:phone]
# 	address1 = params[:address1]
#   address2 = params[:address2]
#   city = params[:city]
#   state = params[:state]
#   zip = params[:zip]
# 	loginname = session[:loginname]
#   unless lastname == nil
#     lastname = conn.escape(lastname)
#     firstname = conn.escape(firstname)
#     phone = conn.escape(phone)
#     address1 = conn.escape(address1)
#     address2 = conn.escape(address2)
#     city = conn.escape(city)
#     state = conn.escape(state)
#     zip = conn.escape(zip)
# 	  loginname = conn.escape(loginname)
#   end
#
# 	conn.query("INSERT INTO numbers (lastname, firstname, phone, address1, address2, city, state, zip)
#   	VALUES('#{lastname}', '#{firstname}', '#{phone}', '#{address1}', '#{address2}', '#{city}', '#{state}', '#{zip}')")
#   	results = conn.query("SELECT * FROM numbers WHERE 'lastname'='#{lastname}'")
# 	info = []
#   	results.each do |row|
#     	info << [[row['lastname']], [row['firstname']], [row['phone']], [row['address1']], [row['address2']], [row['city']], [row['state']], [row['zip']]]
#  	end
#   	erb :login_page, locals:{info: info, loginname: session[:loginname]}
# end
#
#
#
#
# ###########################
#
#
#
# # update and delete functions
# # p "Go take a hike!"
# # get '/contacts_page' do
# #   loginname = session[:loginname]
# #   loginname = conn.escape(loginname)
# #   results = conn.query("SELECT * FROM entry WHERE 'ID'='#{loginname}'")
# #   info = []
# #     results.each do |row|
# #       info << [[row['ID']], [row['Lastname']], [row['Firstname']], [row['Phone']], [row['Address1']], [row['Address2']], [row['City']], [row['State']], [row['ZIP']], [row['Notes']]]
# #   end
# #   erb :login_page, locals:{info: info, loginname: session[:loginname]}
# # end
# #
#
#
# #
#
# #
# # post '/contacts_page_update' do
# # 	uuid_arr = params[:uuid_arr]
# # 	firstname_arr = params[:firstname_arr]
# #   lastname_arr = params[:lastname_arr]
# # 	phone_arr = params[:phone_arr]
# # 	address1_arr = params[:address1_arr]
# #   address2_arr = params[:address2_arr]
# #   city_arr = params[:city_arr]
# #   state_arr = params[:state_arr]
# #   zip_arr = params[:zip_arr]
# # 	notes_arr = params[:notes_arr]
# # 	loginname = session[:loginname]
# # 	loginname = conn.escape(loginname)
# # 	counter = 0
# # 	unless id_arr == nil
# # 		  id_arr.each do |ind|
# # 			     ind = conn.escape(ind)
# # 			     id_arr[counter] = conn.escape(id_arr[counter])
# #            conn.query("UPDATE 'entry' SET 'Lastname'='#{lastname_arr[counter]}' WHERE 'ID='#{ind}'")
# #            lastname_arr[counter] = conn.escape(lastname_arr[counter])
# #            conn.query("UPDATE 'entry' SET 'Firstname'='#{name_arr[counter]}' WHERE 'ID'='#{ind}'")
# # 			     phone_arr[counter] = conn.escape(phone_arr[counter])
# #            conn.query("UPDATE 'entry' SET 'Phone'='#{phone_arr[counter]}' WHERE 'ID'='#{ind}'")
# #
# #            address1_arr[counter] = conn.escape(address1_arr[counter])
# #            conn.query("UPDATE 'entry' SET 'Address'='#{address1_arr[counter]}' WHERE 'ID'='#{ind}'")
# #            address2_arr[counter] = conn.escape(address2_arr[counter])
# #            conn.query("UPDATE 'entry' SET 'Address'='#{address2_arr[counter]}' WHERE 'ID'='#{ind}'")
# #
# #            city_arr[counter] = conn.escape(address_arr[counter])
# #            conn.query("UPDATE 'entry' SET 'Address'='#{city_arr1[counter]}' WHERE 'ID'='#{ind}'")
# #            state_arr[counter] = conn.escape(address_arr[counter])
# #            conn.query("UPDATE 'entry' SET 'Address'='#{state_arr1[counter]}' WHERE 'ID'='#{ind}'")
# #            zip_arr[counter] = conn.escape(address_arr[counter])
# #            conn.query("UPDATE 'entry' SET 'Address'='#{zip_arr1[counter]}' WHERE 'ID'='#{ind}'")
# #
# #
# #            notes_arr[counter] = conn.escape(notes_arr[counter])
# #            conn.query("UPDATE 'entry' SET 'Notes'='#{notes_arr[counter]}' WHERE 'ID'='#{ind}'")
# # 			     counter += 1
# # 		end
# # 	end
# # 	results = conn.query("SELECT * FROM entry WHERE 'ID'='#{loginname}'")
# # 	info = []
# #   	results.each do |row|
# #     	info << [[row['uuid']], [row['Lastname']], [row['Firstname']], [row['Phone']], [row['Address1']], [row['Address2']], [row['City']], [row['State']], [row['ZIP']], [row['Notes']]]
# #  	end
# # 	erb :contacts_page, locals:{info: info, loginname: session[:loginname]}
# # end
# #
# # post '/contacts_page_delete' do
# # 	id_arr = params[:id_arr]
# #   lastname_arr = params[:lastname_arr]
# # 	firstname_arr = params[:firstname_arr]
# # 	phone_arr = params[:phone_arr]
# # 	address1_arr = params[:address1_arr]
# #   address2_arr = params[:address1_arr]
# #   city_arr = params[:city_arr]
# #   state_arr = params[:state_arr]
# #   zip_arr = params[:zip_arr]
# # 	notes_arr = params[:notes_arr]
# # 	loginname = session[:loginname]
# # 	loginname = conn.escape(loginname)
# # 	counter = 0
# # 	unless uuid_arr == nil
# # 		uuid_arr.each do |ind|
# # 			ind = conn.escape(ind)
# #
# #       conn.query("UPDATE 'entry' SET 'Lastname'='#{lastname_arr[counter]}' WHERE 'ID='#{ind}'")
# #       lastname_arr[counter] = conn.escape(lastname_arr[counter])
# #       conn.query("UPDATE 'entry' SET 'Firstname'='#{name_arr[counter]}' WHERE 'ID'='#{ind}'")
# #       phone_arr[counter] = conn.escape(phone_arr[counter])
# #       conn.query("UPDATE 'entry' SET 'Phone'='#{phone_arr[counter]}' WHERE 'ID'='#{ind}'")
# #
# #       address1_arr[counter] = conn.escape(address1_arr[counter])
# #       conn.query("UPDATE 'entry' SET 'Address'='#{address1_arr[counter]}' WHERE 'ID'='#{ind}'")
# #       address2_arr[counter] = conn.escape(address2_arr[counter])
# #       conn.query("UPDATE 'entry' SET 'Address'='#{address2_arr[counter]}' WHERE 'ID'='#{ind}'")
# #
# #       city_arr[counter] = conn.escape(address_arr[counter])
# #       conn.query("UPDATE 'entry' SET 'Address'='#{city_arr1[counter]}' WHERE 'ID'='#{ind}'")
# #       state_arr[counter] = conn.escape(address_arr[counter])
# #       conn.query("UPDATE 'entry' SET 'Address'='#{state_arr1[counter]}' WHERE 'ID'='#{ind}'")
# #       zip_arr[counter] = conn.escape(address_arr[counter])
# #       conn.query("UPDATE 'entry' SET 'Address'='#{zip_arr1[counter]}' WHERE 'ID'='#{ind}'")
# #
# #
# #       notes_arr[counter] = conn.escape(notes_arr[counter])
# #       conn.query("UPDATE 'entry' SET 'Notes'='#{notes_arr[counter]}' WHERE 'ID'='#{ind}'")
# #
# # 			counter += 1
# # 		end
# #   end
# # end
# #
# # 	number = conn.escape(number)
# # 	conn.query("DELETE FROM 'entry' WHERE 'Number'='#{number}' AND `Owner`='#{loginname}'")
# # 	results = conn.query("SELECT * FROM entry WHERE `Owner`='#{loginname}'")
# # 	info = []
# #   	results.each do |row|
# #     	info << [[row['uuid']], [row['Name']], [row['Phone']], [row['Address']], [row['Notes']], [row['Owner']], [row['Number']]]
# #  	end
# # 	erb :contacts_page, locals:{info: info, loginname: session[:loginname]}
# # end
