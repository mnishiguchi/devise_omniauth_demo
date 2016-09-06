class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!, only: :destroy

  def create
    @likeable = find_likeable

    @like = current_user.likes.build(likeable: @likeable)

    if @like.save
      flash[:success] = "Liked it!"
      redirect_back_or @likeable
    else
      flash[:danger] = "Couldn't like it!"
      redirect_back_or @likeable
    end
  end

  def destroy
    @like.destroy
    flash[:success] = "Unliked successfully"
    redirect_to root_url
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
      likeable = resource.singularize.classify.constantize.find(id)
    end
end
