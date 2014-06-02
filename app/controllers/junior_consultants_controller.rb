class JuniorConsultantsController < ApplicationController
  load_and_authorize_resource
  before_filter :load_jc, :only => [:edit, :update, :destroy]

  # GET /junior_consultants
  # GET /junior_consultants.json
  def index
    @junior_consultants = JuniorConsultant.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @junior_consultants }
    end
  end

  # GET /junior_consultants/new
  # GET /junior_consultants/new.json
  def new
    @junior_consultant = JuniorConsultant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @junior_consultant }
    end
  end

  # GET /junior_consultants/1/edit
  def edit; end

  # POST /junior_consultants
  # POST /junior_consultants.json
  def create
    params[:junior_consultant][:user_id] = find_user(params[:junior_consultant][:user_id]) if params[:junior_consultant][:user_id] 
    params[:junior_consultant][:coach_id] = find_user(params[:junior_consultant][:coach_id]) if params[:junior_consultant][:coach_id] 
    @junior_consultant = JuniorConsultant.new(params[:junior_consultant])

    respond_to do |format|
      if @junior_consultant.save
        format.html { redirect_to junior_consultants_path, notice: 'Junior consultant was successfully created.' }
        format.json { render json: @junior_consultant, status: :created, location: junior_consultants_path }
      else
        format.html { render action: "new" }
        format.json { render json: @junior_consultant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /junior_consultants/1
  # PUT /junior_consultants/1.json
  def update
    params[:junior_consultant][:user_id] = find_user(params[:junior_consultant][:user_id]) {} if params[:junior_consultant][:user_id]
    params[:junior_consultant][:coach_id] = find_user(params[:junior_consultant][:coach_id]) if params[:junior_consultant][:coach_id]

    respond_to do |format|
      if @junior_consultant.update_attributes(params[:junior_consultant])
        format.html { redirect_to junior_consultants_path, notice: 'Junior consultant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @junior_consultant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /junior_consultants/1
  # DELETE /junior_consultants/1.json
  def destroy
    @junior_consultant.destroy
    respond_to do |format|
      format.html { redirect_to junior_consultants_url }
      format.json { head :no_content }
    end
  end

  def autocomplete_jc_name
    jc_names = JuniorConsultant.select([:name]).where("name ILIKE ?", "%#{params[:name]}%")
    @result = jc_names.collect { |jc| {value: jc.name}  }
    render json: @result
  end

  private 
  def load_jc
    @junior_consultant = JuniorConsultant.find(params[:id])
  end

  def find_user(data, &block)
    return nil if data.empty?
    block ? JuniorConsultant.find_by_name(data).user_id : User.find_by_name(data).id
  end
end
