class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    @events = @events.where(bowler_id: params[:bowler_id]) if params[:bowler_id].present?
    @events = @events.where(batsman_id: params[:batsman_id]) if params[:batsman_id].present?
    @events = @events.where(important: params[:important]) if params[:important].present?
    @events = @events.where(match_id: params[:match_id]) if params[:match_id].present?
    @events = @events.where(run: params[:run]) if params[:run].present?
    filter_on_country
  end

  def filter_on_country
    @events = @events.joins("inner join players as bowler_players on bowler_players.id = events.bowler_id").where("bowler_players.country = ?", params[:bowler_country]) if params[:bowler_country].present?
    @events = @events.joins("inner join players as batsman_players on batsman_players.id = events.batsman_id").where("batsman_players.country = ?", params[:batsman_country]) if params[:batsman_country].present?
    @events
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:batsman_id, :bowler_id, :run, :comment, :important, :over, :match_id)
    end
end
