class TrinketAttachmentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :load_trinket
  before_filter :load_trinket_attachment, :except => [ :create ]

  respond_to :json

  def update
    if @trinket_attachment.update_attributes(params[:trinket_attachment])
      redirect_to user_trinket_path(@user, @trinket), :flash => { :success => "Trinket Attachment updated." }
    else
      redirect_to user_trinket_path(@user, @trinket), :flash => { :error => @trinket_attachment.errors.full_messages }
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
      @trinket.quantity = req["trinket"]["quantity"] unless req["trinket"]["quantity"].nil?
      @trinket.current_value = req["trinket"]["current_value"] unless req["trinket"]["current_value"].nil?

      @trinket.save!
      render :json => @trinket
    rescue
      render :json => { :errors => @trinket.errors.full_messages }, :status => 422
    end
  end
=end
  def create
    @trinket_attachment = @trinket.trinket_attachments.build(params[:trinket_attachment])
    if @trinket_attachment.save
      redirect_to user_trinket_path(@user, @trinket), :flash => { :success => "Trinket Attachment created" }
    else
      redirect_to user_trinket_path(@user, @trinket), :flash => { :error => @trinket_attachment.errors.full_messages }
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
    name = @trinket_attachment.name

    respond_to do |format|
      @trinket_attachment.destroy
      if @trinket_attachment.errors.empty?
        format.html { redirect_to user_trinket_path(@user, @trinket), :flash => { :success => "#{name} deleted" } }
        format.json { render :json => { :status => 200 } }
      else
        format.html { redirect_to user_trinket_path(@user, @trinket), :flash => { :failure => "Error deleting trinket attachment"} }
        format.json { render :json => { :errors => @trinket_attachment.errors.full_messages }, :status => 422 }
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
        @trinket = @user.trinkets.find(params[:trinket_id])
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "Trinket does not exist"} }
          format.json { render :json => { :errors => ["Trinket does not exist."] }, :status => 422 }
        end
      end
    end

    def load_trinket_attachment
      begin
        @trinket_attachment = @trinket.trinket_attachments.find(params[:id])
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "Trinket Attachment does not exist"} }
          format.json { render :json => { :errors => ["Trinket Attachment does not exist."] }, :status => 422 }
        end
      end
    end
end