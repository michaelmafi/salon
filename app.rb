require "sinatra"
require "sinatra/reloader"
also_reload "lib/**/*.rb"
require "./lib/client"
require "./lib/stylist"
require "pg"

DB = PG.connect({:dbname => "salon"})

get("/") do
  @stylists = Stylist.all
  erb(:index)  
end

post("/clients") do
  client_name = params.fetch("client_name")
  stylist_id = params.fetch("stylist_id").to_i
  client = Client.new({:name => client_name, :id => nil, :stylist_id => stylist_id})
  client.save
  @stylist = Stylist.find(stylist_id)
  erb(:stylist)
end

post("/stylists") do
  name = params.fetch("name")
  stylist = Stylist.new({:name => name, :id => nil})
  stylist.save
  @stylists = Stylist.all
  erb(:index)
end

get("/stylists/:id") do
  @stylist = Stylist.find(params.fetch("id").to_i)
  erb(:stylist)
end

get("/stylists/:id/edit") do
  @stylist = Stylist.find(params.fetch("id").to_i)
  erb(:stylist_edit)
end

patch("/stylists/:id") do
  name = params.fetch("name")
  @stylist = Stylist.find(params.fetch("id").to_i)
  @stylist.update({:name => name})
  erb(:stylist)
end

delete("/stylists/:id") do
  @stylist = Stylist.find(params.fetch("id").to_i)
  @stylist.delete
  @stylists = Stylist.all
  erb(:index)
end