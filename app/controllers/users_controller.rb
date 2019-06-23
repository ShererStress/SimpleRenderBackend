class UsersController < ApplicationController

  # GET: index route
  def baseURL
    render json: User.all
  end

  # GET: index route
  def index
    render json: User.all
  end

  # GET: show route
  def show
    render json: User.find(params["id"])
  end

  # POST: authenticate route
  def authenticate
    render json: User.authenticate(params["user"])
  end

  # POST: create route
  def create
    render json: User.create(params["user"])
  end

  # PUT: edit route
  def update
    render json: User.update(params["id"], params["user"])
  end

end
