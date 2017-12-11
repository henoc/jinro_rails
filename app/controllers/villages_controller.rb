class VillagesController < ApplicationController
  include VillagesHelper

  before_action :set_village, only: %i[edit update destroy join exit start]
  before_action :authorize_village, only: %i[index new create]

  def index
    @villages = Village.all
  end

  def new
    @village = Village.new
  end

  def edit
  end

  def create
    @village = current_user.villages.new(village_params)

    if @village.save
      redirect_to villages_path, notice: "#{@village.name} が作成されました"
    else
      render :new
    end
  end

  def update
    if @village.update(village_params)
      redirect_to villages_path, notice: "#{@village.name} が更新されました"
    else
      render :edit
    end
  end

  def destroy
    @village.destroy
    redirect_to villages_url, notice: "#{@village.name} が削除されました"
  end

  def join
    player = @village.create_player(current_user)
    @village.room_for_all.posts.create!(content: join_message(@village, player), day: @village.day, owner: :system)
    redirect_to village_room_path(@village, @village.room_for_all), notice: "#{@village.name} に参加しました"
  end

  def exit
    player = @village.make_player_exit(current_user)
    @village.room_for_all.posts.create!(content: exit_message(player), day: @village.day, owner: :system)
    redirect_to villages_path, notice: "#{@village.name} から退出しました"
  end

  def start
    @village.assign_role
    @village.update_to_next_day
    @village.update(status: :in_play)
    @village.room_for_all.posts.create!(content: start_message(@village), day: @village.day, owner: :system)
    ReloadBroadcastJob.perform_later(@village)
    redirect_to village_room_path(@village, @village.room_for_all), notice: "#{@village.name} を開始しました"
  end

  private

  def set_village
    @village = Village.find(params[:id])
    authorize @village
  end

  def authorize_village
    authorize Village
  end

  def village_params
    params.require(:village).permit(:name, :player_num, :discussion_time)
  end
end
