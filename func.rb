def add_numbers(arr) ## add phone number records
db_params = {
	host: ENV['RDS_HOST'],
	port: ENV['RDS_PORT'],
	dbname: ENV['RDS_DB_NAME'],
	user: ENV['RDS_USERNAME'],
	password: ENV['RDS_PASSWORD']
}
db = PG::Connection.new(db_params)
answer = ""
check = db.exec("SELECT * FROM numbers WHERE phone = '#{arr[-1]}'")

	if check.num_tuples.zero? == false
		answer = "Number already in use."
	else
		answer = "You may join this phone book!"
		db.exec("INSERT INTO numbers(lastname, firstname, phone, address1, address2, city, state, zip) VALUES('#{arr[0]}','#{arr[1]}','#{arr[2]}','#{arr[3]}','#{arr[4]}','#{arr[5]}','#{arr[6]}','#{arr[7]}')")
	end
	answer
end

def database_info()  ## select from numbers
	db_params = {
		host: ENV['RDS_HOST'],
		port: ENV['RDS_PORT'],
		dbname: ENV['RDS_DB_NAME'],
		user: ENV['RDS_USERNAME'],
		password: ENV['RDS_PASSWORD']
}
data = []
db = PG::Connection.new(db_params)
db.exec("SELECT * FROM numbers" ) do |result|
      result.each do |row|
      	data << row.values
      end
    end
   data
end

def search_data_phone(info) ## search by phone number
	db_params = {
		host: ENV['RDS_HOST'],
		port: ENV['RDS_PORT'],
		dbname: ENV['RDS_DB_NAME'],
		user: ENV['RDS_USERNAME'],
		password: ENV['RDS_PASSWORD']
}
	db = PG::Connection.new(db_params)
	check = db.exec("SELECT * FROM numbers WHERE phone = '#{info}'")

	if check.num_tuples.zero? == false
			search_answer = check.values
	else
		search_answer = "Not in phone book."
	end

	end



def search_data_lastname(info) ## search by last name
	db_params = {
		host: ENV['RDS_HOST'],
		port: ENV['RDS_PORT'],
		dbname: ENV['RDS_DB_NAME'],
		user: ENV['RDS_USERNAME'],
		password: ENV['RDS_PASSWORD']
}
db = PG::Connection.new(db_params)
check = db.exec("SELECT * FROM numbers WHERE lastname = '#{info}'")
yup = check.num_tuples
if check.num_tuples.zero? == false
	search_answer = check.values
else
	search_answer = "Not in phone book."
end
end
# get_info_database()



def update_table(info_new)
		db_params = {
			host: ENV['RDS_HOST'],
			port: ENV['RDS_PORT'],
			dbname: ENV['RDS_DB_NAME'],
			user: ENV['RDS_USERNAME'],
			password: ENV['RDS_PASSWORD']
}
db = PG::Connection.new(db_params)
	counter = 0
	info_new.each do |arr|
		db.exec("UPDATE numbers SET lastname = '#{arr[0]}', firstname = '#{arr[1]}', phone = '#{arr[2]}', address1 = '#{arr[3]}', address2 = '#{arr[4]}', city = '#{arr[5]}', state = '#{arr[6]}', zip = '#{arr[7]}' WHERE phone = '#{old_phone[counter]}'")
		counter =+ 1
	end
	info_new
end



def delete_from_table(delete_info) ## delete an entry
	db_params = {
		host: ENV['RDS_HOST'],
		port: ENV['RDS_PORT'],
		dbname: ENV['RDS_DB_NAME'],
		user: ENV['RDS_USERNAME'],
		password: ENV['RDS_PASSWORD']
}
db = PG::Connection.new(db_params)
	arr = []
	delete_info.each do |row|
		yup = row.split(',')
		arr << yup
	end
	arr.each do |row|
		delete_num = row[-1]
		db.exec("DELETE FROM numbers WHERE phone = '#{delete_num}'")
	end

end


def check_creds?(userid,pword) ## check credentials
	db_params = {
		host: ENV['RDS_HOST'],
		port: ENV['RDS_PORT'],
		dbname: ENV['RDS_DB_NAME'],
		user: ENV['RDS_USERNAME'],
		password: ENV['RDS_PASSWORD']
}
db = PG::Connection.new(db_params)

check = db.exec("SELECT*FROM login WHERE userid = '#{userid}'")
 		if check.num_tuples.zero? == false
 			check_val = check.values.flatten
  			if check_val[1] == pword
 				true
 			else
 				false
 			end
 		else
 			false
 		end
end


def add_to_login(userid,pword) ## add to logins as they register
		db_params = {
			host: ENV['RDS_HOST'],
			port: ENV['RDS_PORT'],
			dbname: ENV['RDS_DB_NAME'],
			user: ENV['RDS_USERNAME'],
			password: ENV['RDS_PASSWORD']
}
db = PG::Connection.new(db_params)
 check = db.exec ("SELECT * FROM login WHERE userid = '#{userid}'")
	message = ""
	if check.num_tuples.zero? == false
		message = "Username Already Taken"
	else
		db.exec("INSERT INTO login (userid, pword) VALUES ('#{userid}','#{pword}')")   
		message = "Login Created"
	end
	message
end
