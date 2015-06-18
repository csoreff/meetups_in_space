configure :development do
  require 'dotenv'
  Dotenv.load

  require 'sinatra/reloader'
  require 'pry'

  also_reload 'app/**/*.rb'
end

configure do
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']

  set :views, 'app/views'

  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'],
      scope: 'user:email'
  end
end

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

def join_meetup
  @user = User.find(current_user.id)
  @meetup_to_join = Meetup.find(params[:meetup])
  attendee = MeetupUser.new(user: @user, meetup: @meetup_to_join)
  if attendee.save
    flash[:notice] = 'You have joined this event.'
    redirect "/meetups/#{@meetup_to_join.id}"
  else
    flash[:notice] = 'You have already registered for this event!'
    redirect "/meetups/#{@meetup_to_join.id}"
  end
end