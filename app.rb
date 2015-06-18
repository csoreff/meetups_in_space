require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  redirect '/meetups'
end

get '/meetups' do
  erb :index
end

get '/newmeetup' do
  erb :create_meetup
end

post '/newmeetup' do
  if signed_in?
    new_meetup = Meetup.create(name: params[:meetup_name], location: params[:location],
      description: params[:description])
    new_meetup.save
    redirect "/meetups/#{new_meetup.id}"
  else
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/newmeetup'
  end
end

get '/meetups/:meetup' do
  @meetup = Meetup.find(params[:meetup])
  @meetup_users = @meetup.users
  erb :meetup_show
end

post '/meetups/:meetup' do
  if signed_in?
    join_meetup
  else
    authenticate!
  end
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/meetups'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end
