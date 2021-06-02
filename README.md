# here_present_backend

### Requirements

+ [Frontend](https://github.com/unisocisec/here_present_frontend)
  
+ With Docker
  + Docker
  + Docker compose
  + MariaDb
  + Rails 6.x
  + Ruby 3.0.0

### Quick Start
1. create environment file - set credentials
* `cp config/application.example.yml config/application.yml`
* `cp config/database.example.yml config/database.yml`
* `cp docker-compose.example.yml docker-compose.yml`
2. `docker-compose build` -> build docker environment
3. `docker-compose up` -> start docker environment
4. `docker exec -it here_present_api bash` -> enter in docker container
5. `rails db:setup` -> create tables and database updates
6. `rails db:migrate` -> create tables and database updates
7. `rails db:seed` -> populate database with real data
8. `rails db:populate_start` -> populate database with fake data
9. `rails s -b 0.0.0.0` -> start server

+ `http://localhost:3000/api/v1` -> api endpoint
+ `http://localhost:3000/auth` -> api auth endpoint


### Default users in db:populate

+ Email
  + `user@default.com`
+ password:
  + `password1234`
  
## Contributing

* Fork it
* Write your changes
* Commit
* Send a pull request
