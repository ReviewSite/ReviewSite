class ReviewingGroupsController < ApplicationController
  load_and_authorize_resource
  before_filter :load_reviewing_group, :only => [:show, :edit, :update, :destroy]

  # GET /reviewing_groups
  # GET /reviewing_groups.json
  def index
    @reviewing_groups = ReviewingGroup.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviewing_groups }
    end
  end

  # GET /reviewing_groups/new
  # GET /reviewing_groups/new.json
  def new
    @reviewing_group = ReviewingGroup.new
    @users = User.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reviewing_group }
    end
  end

  # GET /reviewing_groups/1/edit
  def edit; end

  # POST /reviewing_groups
  # POST /reviewing_groups.json
  def create

    @reviewing_group = ReviewingGroup.new(params[:reviewing_group])

    respond_to do |format|
      if @reviewing_group.save
        format.html { redirect_to reviewing_groups_url, notice: 'Reviewing Group was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @reviewing_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reviewing_groups/1
  # PUT /reviewing_groups/1.json
  def update
    respond_to do |format|
      if @reviewing_group.update_attributes(params[:reviewing_group])
        format.html { redirect_to reviewing_groups_url, notice: 'Reviewing group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reviewing_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviewing_groups/1
  # DELETE /reviewing_groups/1.json
  def destroy
    @reviewing_group.destroy
    respond_to do |format|
      format.html { redirect_to reviewing_groups_url }
      format.json { head :no_content }
    end
  end

  private
  def load_reviewing_group
    @reviewing_group = ReviewingGroup.find(params[:id])
  end
end
