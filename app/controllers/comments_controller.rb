class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
  @comment = Comment.new(comment_params)
  @prototype = Prototype.find(params[:prototype_id])
  if @comment.save
    redirect_to prototype_path(@comment.prototype) # 正しいパスを使用 # 今回の実装には関係ありませんが、このようにPrefixでパスを指定することが望ましいです。
  else
    #@prototype = @comment.prototype
    @comments = @prototype.comments
    render "prototypes/show", status: :unprocessable_entity
    # views/tweets/show.html.erbのファイルを参照しています。
  end
end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end
end

