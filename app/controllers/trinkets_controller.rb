class TrinketsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :load_trinket, :except => [ :index, :new, :create ]

  respond_to :json

  def index
    respond_to do |format|
      format.html { redirect_to @user }
      format.json { render :json => @user.trinkets}
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render :json => { :trinket => @trinket } }
    end
  end

  def new
    @trinket = @user.trinkets.new
  end

  def edit

  end

  def update
    if @trinket.update_attributes(params[:trinket])
      redirect_to user_trinket_path(current_user, @trinket), :flash => { :success => "Trinket updated." }
    else
      render :edit
    end
  end
=begin
  def update.json
    req = ActiveSupport::JSON.decode(request.body)

    begin
      @trinket.name = req["trinket"]["name"] unless req["trinket"]["name"].nil?
      @trinket.description = req["trinket"]["description"] unless req["trinket"]["description"].nil?
      @trinket.serial_number = req["trinket"]["serial_number"] unless req["trinket"]["serial_number"].nil?
      @trinket.date_acquired = req["trinket"]["date_acquired"] unless req["trinket"]["date_acquired"].nil?
      @trinket.original_value = req["trinket"]["original_value"] unless req["trinket"]["original_value"].nil?
      @trinket.current_value = req["trinket"]["current_value"] unless req["trinket"]["current_value"].nil?

      @trinket.save!
      render :json => @trinket
    rescue
      render :json => { :errors => @trinket.errors.full_messages }, :status => 422
    end
  end
=end
  def create
    @trinket = @user.trinkets.build(params[:trinket])
    begin
      @trinket.save!
      redirect_to user_trinket_path(@user, @trinket), :flash => { :success => "Trinket created" }
    rescue
      render :new
    end
  end
=begin
  def create.JSON
    req = ActiveSupport::JSON.decode(request.body)
    @trinket = @user.trinkets.build(req["trinket"])

    begin
      @trinket.save!
      render :json => @trinket
    rescue
      render :json => { :errors => @trinket.errors.full_messages }, :status => :unprocessable_entity
    end
  end
=end
  def destroy
    name = @trinket.name

    respond_to do |format|
      begin
        @trinket.destroy!
        format.html { redirect_to root_path, :flash => { :success => "#{name} deleted" } }
        format.json { render :json => { :status => 200 } }
      rescue
        format.html { redirect_to user_trinket_path(@user, @trinket), :flash => { :failure => "Error deleting trinket"} }
        format.json { render :json => { :errors => @trinket.errors.full_messages }, :status => 422 }
      end
    end
  end

  private

    def load_user
      begin
        @user = User.find(params[:user_id])

        #TODO - only an admin should be able to look at other people
        if !current_user?(@user)
          respond_to do |format|
            format.html { redirect_to error_path, :flash => { :failure => "No access to this user" } }
            #TODO - right error code?
            format.json { render :json => {:errors => ["No access to this user"] }, :status => 422 }
          end
        end
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "User does not exist" } }
          #TODO - is this the right error code?
          format.json { render :json => {:errors => ["User does not exist"] }, :status => 422 }
        end
      end
    end

    def load_trinket
      begin
        @trinket = @user.trinkets.find(params[:id])
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "Trinket does not exist"} }
          format.json { render :json => { :errors => ["Trinket does not exist."] }, :status => 422 }
        end
      end
    end
=begin
  def index
    #TODO - only can see other people's events if they give access
    if !current_user?(@user)
      respond_to do |format|
        format.html { redirect_to error_path, :flash => { :failure => "No permission to view this user's trinkets"} }
        format.json { render :json => { :errors => ["No permission to view this user's trinkets"] }, :status => 422 }
      end
    else
      @trinkets = @user.trinkets.all
      respond_to do |format|
        format.html
        format.json { render :json => @trinkets }
      end
    end
  end

  def show
    #TODO - only can see other people's trinkets if they give access
    if !current_user?(@user)
      render :json => { :errors => ["No permission to view this trinket"] }, :status => 422
    end

    if @trinket.nil?
      render :json => { :errors => ["Trinket does not exist."] }, :status => 422
    end

    respond_to do |format|
      #TODO - is the HTML version even needed?
      format.html
      format.json { render :json => { :user => @user, :trinket => @trinkets } }
    end
  end

  def new
    @trinket = @user.trinkets.new
  end

  def edit
    @trinket = @user.trinkets.find_by_id(params[:id])

    if @trinket.nil?
      redirect_to error_path, :flash => { :failure => "Trinket does not exist" }
    end
  end

  def update
    if !current_user?(@user)
      render :json => { :errors => ["No permission to update this trinket"] }, :status => 422
    end

    @trinket = @user.trinkets.find_by_id(params[:id])

    if @trinket.nil?
      render :json => { :errors => ["Trinket does not exist"] }, :status => 422
    end

    req = ActiveSupport::JSON.decode(request.body)

    begin
      @trinket.name = req["trinket"]["name"] unless req["trinket"]["name"].nil?
      @trinket.description = req["trinket"]["description"] unless req["trinket"]["description"].nil?
      @trinket.serial_number = req["trinket"]["serial_number"] unless req["trinket"]["serial_number"].nil?
      @trinket.date_acquired = req["trinket"]["date_acquired"] unless req["trinket"]["date_acquired"].nil?
      @trinket.original_value = req["trinket"]["original_value"] unless req["trinket"]["original_value"].nil?
      @trinket.current_value = req["trinket"]["current_value"] unless req["trinket"]["current_value"].nil?

      @trinket.save!
      render :json => @trinket
    rescue
      render :json => { :errors => @trinket.errors.full_messages }, :status => 422
    end
  end

  def create
    if !current_user?(@user)
      render :json => { :errors => ["No permission to create this user's trinkets"] }, :status => 422
    end

    req = ActiveSupport::JSON.decode(request.body)
    @trinket = @user.trinkets.build(req["trinket"])

    respond_to do |format|
      begin
        @trinket.save!
        format.html { redirect_to(@trinket, :notice => "Trinket was successfully created") }
        format.json { render :json => @trinket }
      rescue
        format.html { render :action => "new" }
        format.json { render :json => { :errors => @trinket.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    if !current_user?(@user)
      render :json => { :errors => ["No permission to delete this trinket"] }, :status => 422
    end

    @trinket = @user.trinkets.find_by_id(params[:id])

    if @trinket.nil?
      render :json => { :errors => ["Trinket does not exist"] }, :status => 422
    end

    begin
      @trinket.destroy
      #TODO - what is the right status?
      render :json => { :status => 200 }
    rescue
      render :json => { :errors => @trinket.errors.full_messages }, :status => 422
    end
  end

  private
    def load_user
      begin
        #TODO - allow an admin to see any user
        @user = User.find(params[:user_id])
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "User does not exist"} }
          format.json { render :json => { :errors => ["User does not exist"] }, :status => 422 }
        end
      end
    end

    def load_trinket
      begin
        #TODO - allow an admin to see any trinket
        @trinket = @user.trinkets.find(params[:id])
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "Trinket does not exist" } }
          #TODO - is this the right error code?
          format.json { render :json => {:errors => ["Trinket does not exist"] }, :status => 422 }
        end
      end
    end
=end
end