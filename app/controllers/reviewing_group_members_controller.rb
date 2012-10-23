class ReviewingGroupMembersController < ApplicationController
  load_and_authorize_resource

  # GET /reviewing_group_members
  # GET /reviewing_group_members.json
  def index
    @reviewing_group_members = ReviewingGroupMember.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviewing_group_members }
    end
  end


  # GET /reviewing_group_members/new
  # GET /reviewing_group_members/new.json
  def new
    @reviewing_group_member = ReviewingGroupMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reviewing_group_member }
    end
  end

  # GET /reviewing_group_members/1/edit
  def edit
    @reviewing_group_member = ReviewingGroupMember.find(params[:id])
  end

  # POST /reviewing_group_members
  # POST /reviewing_group_members.json
  def create
    @reviewing_group_member = ReviewingGroupMember.new(params[:reviewing_group_member])

    respond_to do |format|
      if @reviewing_group_member.save
        format.html { redirect_to reviewing_group_members_path, notice: 'Reviewing group member was successfully created.' }
        format.json { render json: @reviewing_group_member, status: :created, location: reviewing_group_members_path }
      else
        format.html { render action: "new" }
        format.json { render json: @reviewing_group_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reviewing_group_members/1
  # PUT /reviewing_group_members/1.json
  def update
    @reviewing_group_member = ReviewingGroupMember.find(params[:id])

    respond_to do |format|
      if @reviewing_group_member.update_attributes(params[:reviewing_group_member])
        format.html { redirect_to reviewing_group_members_path, notice: 'Reviewing group member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reviewing_group_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviewing_group_members/1
  # DELETE /reviewing_group_members/1.json
  def destroy
    @reviewing_group_member = ReviewingGroupMember.find(params[:id])
    @reviewing_group_member.destroy

    respond_to do |format|
      format.html { redirect_to reviewing_group_members_url }
      format.json { head :no_content }
    end
  end
end
