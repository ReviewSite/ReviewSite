class JuniorConsultantsController < ApplicationController
  load_and_authorize_resource

  # GET /junior_consultants
  # GET /junior_consultants.json
  def index
    @junior_consultants = JuniorConsultant.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @junior_consultants }
    end
  end

  # GET /junior_consultants/1
  # GET /junior_consultants/1.json
  def show
    @junior_consultant = JuniorConsultant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @junior_consultant }
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
  def edit
    @junior_consultant = JuniorConsultant.find(params[:id])
  end

  # POST /junior_consultants
  # POST /junior_consultants.json
  def create
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
    @junior_consultant = JuniorConsultant.find(params[:id])

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
    @junior_consultant = JuniorConsultant.find(params[:id])
    @junior_consultant.destroy

    respond_to do |format|
      format.html { redirect_to junior_consultants_url }
      format.json { head :no_content }
    end
  end
end
