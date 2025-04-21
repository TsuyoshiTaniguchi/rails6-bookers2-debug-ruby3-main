class BookCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    @book_comment = BookComment.new(book_comment_params)
    @book_comment.book_id = @book.id
    @book_comment.user_id = current_user.id
    unless @book_comment.save
      render 'error'  # app/views/book_comments/error.js.erbを参照する ※要件外
    end
    # app/views/book_comments/create.js.erbを参照する
  end

  def destroy
    @book = Book.find(params[:book_id])
    book_comment = @book.book_comments.find_by(id: params[:id])
    if book_comment
      book_comment.destroy
      respond_to do |format|
        format.html { redirect_to book_path(@book), notice: "コメントを削除しました。" }
        format.js  # Ajax リクエストが来た場合
      end
    else
      respond_to do |format|
        format.html { redirect_to book_path(@book), alert: "コメントが見つかりませんでした。" }
        format.json { render json: { error: "Comment not found" }, status: :not_found }
      end
    end
  end
  
  
  
  

  private
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end

