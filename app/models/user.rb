class User

  #Heroku
  uri = URI.parse(ENV['DATABASE_URL'])
  DB = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password);

  #Local
  # DB = PG.connect(host: "localhost", port: 5432, dbname: 'simpleRenderBackend_development')


  #GET: A user by id
  DB.prepare("users_find",
    <<-SQL
      SELECT *
      FROM users
      WHERE id = $1;
    SQL
  );

    #GET: A user by username/password match
    DB.prepare("users_authenticate",
      <<-SQL
        SELECT *
        FROM users
        WHERE username = $1 AND password= $2;
      SQL
    );

    #POST: A new user
    DB.prepare("users_create",
      <<-SQL
        INSERT INTO users (username, password, mostrecentver)
        VALUES ($1, $2, 0)
        RETURNING id, username, password, mostrecentver;
      SQL
    );

    #PUT: Edit an existing user
    DB.prepare("users_update",
      <<-SQL
        UPDATE users
        SET mostrecentver = $2
        WHERE id = $1
      SQL
    );


    #GET: Index of users - returns array of user objects
    def self.all
      results = DB.exec("SELECT * FROM users;");
      usersList = [];
      results.each do |result|
        usersList.push(result);
      end
      puts usersList;
      return usersList;
    end

    #GET: A user by id
    def self.find(id)
      results = DB.exec_prepared("users_find", [id]);
      return results;
    end

    #POST: Check for user by username/password match
    def self.authenticate(options)
      enteredUsername = options["username"];
      enteredPassword = options["password"];
      results = DB.exec_prepared("users_authenticate", [enteredUsername, enteredPassword]);

      return results.first;
    end

    #POST: A new user
    def self.create(options)
      newUsername = options["username"];
      newPassword = options["password"];

      result = DB.exec_prepared("users_create", [newUsername, newPassword]);

      return result.first
    end

    #PUT: Change a user's most recently downloaded version
    def self.update(id, options)
      newVersion = options["currentVersion"];

      results = DB.exec_prepared("users_update", [id, newVersion]);

      return results.first;
    end

end #End user class
