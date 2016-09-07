class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @likeable = find_likeable
    if current_user.likes.create(likeable: @likeable)
      flash[:success] = "Liked it!"
      redirect_back_or @likeable
    else
      flash[:danger] = "Couldn't like it!"
      redirect_back_or @likeable
    end
  end

  def destroy
    correct_user!
    @like.destroy
    flash[:success] = "Unliked it"
    redirect_back_or @likeable
  end

  private

    # Ensures that the Like belongs to the current user.
    def correct_user!
      @like = Like.find(params[:id])
      unless @like.user_id == current_user.id
        redirect_to root_url and return
      end
    end

    # Find the likeable in question based on the request URL.
    def find_likeable
      resource, id = request.path.split('/')[1, 2]
      @likeable = resource.singularize.classify.constantize.find(id)
    end
end
