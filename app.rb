class Westportmakerspace < Sinatra::Base

#---------------SETUP-----------------
=begin
require 'bundler'
Bundler.require
include BCrypt
=end
#-----------SETTINGs--------------
configure do
  set :erb, :layout => :'layouts'
end


#-------------------------DATABASSE LINKING----------------------------
=begin
DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://db/main.db')
=end
=begin
require './models.rb'
=end
#------------------SESSION--------------------
use Rack::Session::Cookie, :key => 'rack.session',
    :expire_after => 2592000,
    :secret => SecureRandom.hex(64)
#---------GET ROUTES---------------
get '/' do

  @user = User.first(:id => session[:id])
  erb :landing
end
get '/dashboard' do
  if session[:visited]



    @posts = Post.where(:type => "update")
    @user = User.first(:id => session[:id])
    erb :dash
  else
    redirect not_found
  end
end
get '/blog' do
  @posts = Post.where(:type => "blog")
  if session[:visited]
    @user = User.first(:id => session[:id])
  end
  erb :blog
end
get '/settings' do
  if session[:visited]
    @user = User.first(:id => session[:id])
    erb :settings
  else
    redirect not_found
  end
end
get '/logout' do
  session.clear
  redirect '/'
end
not_found do
  @user=User.first(:id => session[:id])
  erb :notfound
end


#-------------POST ROUTES---------------------
post '/user/auth' do

  @u = User.first(:email => params[:email])
  puts @u
  puts Password.new(@u.password)
  puts @u.password
  puts params[:password]
  puts Password.create(@u.password)
  puts Password.create(params[:password])
  if @u && Password.new(@u.password) == params[:password]
    session[:id] = @u.id
    session[:visited] = true
    redirect '/dashboard'
  else
    redirect '/'
  end
end
post '/user/create' do
  u = User.new
  u.firstname = params[:firstname]
  u.lastname = params[:lastname]
  u.email = params[:email]
  u.password = Password.create("Maker20")
  u.perm = 1
  u.save

  @u = User.first(:email => params[:email])

  if @u && Password.new(@u.password) == params[:password]
    session[:id] = @u.id
    session[:visited] = true
    redirect '/dashboard'
  else

    redirect '/'
  end

end
post '/perms/edit' do
  u = User.first(:id => session[:id])
  if params[:permpassword] == ENV["permpass3"]
    u.perm = 3
    u.save
  elsif params[:permpassword] == ENV["permpass2"]
    u.perm = 2
    u.save
  elsif params[:permpassword] == ENV["permpass1"]
    u.perm = 1
    u.save
  elsif params[:permpassword] == ENV["permpass0"]
    u.perm = 0
    u.save
  else
    redirect '/'
  end
  puts u.perm
  redirect '/dashboard'

end
post '/test/email' do
  user = User.first(:id => session[:id])
  Pony.mail(
      :to => 'nqmetke@gmail.com',
      :from => 'betamakerspace@gmail.com',
      :subject=> "New Training Request from #{params[:firstname]} #{params[:lastname]}",
      :body => "This person would like to train on #{params[:date]} at #{params[:time]}. If you wish to contact #{params[:firstname]}, his/her email is #{params[:email]}",
      :via => :smtp,
      :via_options =>{
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => 'betamakerspace',
          :password             => 'wplmakerspace',
          :authentication       => :plain,
          :domain               => 'localhost.localdomain'


   }  )
  @test = 1
  redirect '/#contact'
end
post '/post/create' do
  time = Time.new
  i = Post.new
  i.title = params[:title]
  i.content = params[:content]
  name = Cloudinary::Uploader.upload(params['myfile'][:tempfile],api_key: ENV["Cloudinary_api"], api_secret: ENV["Cloudinary_secret"], cloud_name: ENV["Cloudinary_name"], :width => params[:width], :crop => :limit)
  i.url = name["url"]
  i.date = time
  i.type = "blog"
  i.save
  redirect '/blog'
end
post '/pass/edit' do
  @u = User.first(:id => session[:id])
  puts Password.new(@u.password)
  puts Password.create(params[:oldPassword])

  if Password.new(@u.password) == params[:oldPassword]
    @u.password = Password.create(params[:newPassword])
    @u.save
  else
    redirect '/settings'
  end

redirect '/dashboard'
end
post '/post/create/update' do
  time = Time.new
  i = Post.new
  i.title = params[:title]
  i.content = params[:content]
  i.url = params[:url]
  i.date = time
  i.type = "update"
  i.save
  redirect '/dashboard'
end
post '/post/delete/:id' do
  p = Post.first(:id => params[:id])
  p.destroy
  redirect request.env["HTTP_REFERER"]
end


  end
