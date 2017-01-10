# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(email:"Gibral@dbc.com", password: "password",first_name:"Gibral",last_name: "R")
User.create(email:"Jenna@dbc.com", password: "password",first_name:"Jenna",last_name: "R")
User.create(email:"Nadav@dbc.com", password: "password",first_name:"Nadav",last_name: "R")
User.create(email:"Mark@dbc.com", password: "password",first_name:"Mark",last_name: "R")
User.create(email:"Felix@dbc.com", password: "password",first_name:"Felix",last_name: "R")
User.create(email:"Jessie@dbc.com", password: "password",first_name:"Jessie",last_name: "R")


OwnedStock.create(user_id:1,stock_id:1, shares:10, original_price:20.50)
OwnedStock.create(user_id:2,stock_id:2, shares:20, original_price:30.50)
OwnedStock.create(user_id:3,stock_id:3, shares:30, original_price:40.50)
OwnedStock.create(user_id:3,stock_id:4, shares:40, original_price:50.50)
OwnedStock.create(user_id:1,stock_id:5, shares:50, original_price:60.50)
OwnedStock.create(user_id:4,stock_id:1, shares:60, original_price:70.50)
OwnedStock.create(user_id:5,stock_id:2, shares:70, original_price:80.50)
OwnedStock.create(user_id:5,stock_id:3, shares:80, original_price:30.50)
OwnedStock.create(user_id:2,stock_id:4, shares:90, original_price:40.50)
OwnedStock.create(user_id:1,stock_id:5, shares:100, original_price:50.50)
OwnedStock.create(user_id:1,stock_id:1, shares:100, original_price:60.50)


Stock.create(ticker:"FB")
Stock.create(ticker:"GOOG")
Stock.create(ticker:"AMZN")
Stock.create(ticker:"WMT")
Stock.create(ticker:"TSLA")
