class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_or_initialize_by(book_id: @book.id)
  
    if favorite.new_record?
      if favorite.save
        respond_to do |format|
          format.js
          format.json { render json: { book_id: @book.id, favorites_count: @book.favorites.count, favorite_button_html: render_to_string(partial: 'favorites/favorite-btn', locals: { book: @book }) } }
        end
      else
        render json: { error: favorite.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
  
  

  def destroy
    @book = Book.find(params[:book_id])
    favorite = Favorite.find_by(user_id: current_user.id, book_id: params[:book_id])
  
    if favorite.present?
      favorite.destroy
      respond_to do |format|
        format.js
        format.json { render json: { book_id: @book.id, favorites_count: @book.favorites.count, favorite_button_html: render_to_string(partial: 'favorites/favorite-btn', locals: { book: @book }) } }
      end
    else
      render json: { error: "Favorite not found", book_id: @book.id, favorites_count: @book.favorites.count }, status: :not_found
    end
  end
  
  
  
end
