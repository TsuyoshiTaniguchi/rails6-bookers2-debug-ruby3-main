class RoomsController < ApplicationController
  before_action :authenticate_user!

  def show
    @room = Room.find(params[:id])
    @chats = @room.chats.includes(:user) # メッセージ一覧を取得
  end
  

  def create
    recipient = User.find(params[:user_id])
    if current_user.mutual_follow?(recipient)
      room = Room.create
      UserRoom.create(user: current_user, room: room)
      UserRoom.create(user: recipient, room: room)
      redirect_to room_path(room)
    else
      redirect_to users_path, alert: "相互フォローのユーザーのみDM可能です。"
    end
  end
end
