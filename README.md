# README
### Gems
for gems data and version go to the gemfile

### Setup the database
1. install postgres sql

 2. create data base user
```
sudo -u postgres createuser -s admin
```
```
sudo -u postgres psql
```
```
\password admin
```
```
\password admin
```

### run data base migration 

```
rails db:migrate
```

### run seed database
it create a user for the api
```
rails db:seed
```

### create database for test
```
rails db:test:prepare
```

### instructions to run endpoints 
all the end points need a user, the seed create a user with 
```
email: admin 
password: admin
```

the url to generate the JWT token is, you need to use post
```
http://127.0.0.1:3000/login
```

with this you get a bearer token that is used for run the endpoints

### Run test cases
```
rspec spec/
```

### Run the server
```
rails s
```

### adapter
the adapters is a layer between the models and the service layer, this help to create dummies and stubs more easy way, also desacoplate the database of the layer of services

### services
here is all the business code, the database is not directly connected, this help to create test cases without the need of a database, this is great because the majority of the code is going to be be here and without a db the tests run faster

### controller
the controller have a small code where, this help to create small test cases for the controler

### model
literaly the models are empty, sometimes is not posible to use the adapter as a complete sustitute of the model, but this help to have a small number of test cases and to 