class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]#トップページと詳細以外はログインしている人だけ  
  before_action :move_to_index, only: [:edit]
  
def index
  @prototypes = Prototype.includes(:user).order("created_at DESC")
end

def new
  @prototype = Prototype.new #投稿画面でform_withするときこのインスタンス変数が必要
end

def create
  
  @prototype=Prototype.new(prototype_params)
     if @prototype.save
       redirect_to root_path
     else
      render :new, status: :unprocessable_entity
    end
end

def edit
  @prototype = Prototype.find(params[:id])
end

def update
  @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
     redirect_to prototype_path(@prototype)
    else
     render :edit, status: :unprocessable_entity
    end
end

def destroy
  prototype = Prototype.find(params[:id])
  if prototype.destroy
  redirect_to root_path
end
end

def show
  @prototype = Prototype.find(params[:id])
  @comment = Comment.new 
  @comments = @prototype.comments.includes(:user) 
end

private

def prototype_params
  params.require(:prototype).permit(:title, :catch_copy, :image, :concept).merge(user_id: current_user.id)
end

def move_to_index
  @prototype = Prototype.find(params[:id])
  unless @prototype.user == current_user
    redirect_to action: :index
  end
end
end