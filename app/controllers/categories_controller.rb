class CategoriesController < ApplicationController
  before_action :load_dependency, only: [:index, :destroy]
  # before_action :admin_user, only:  [:new, :create, :destroy]

  def index
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t :category_created
      render 'show'
    else
      render :new
    end
  end

  def show

  end

  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = t :category_deleted
    render :index
  end

  private

  def category_params
    params.require(:category).permit :name
  end

  def load_dependency
    @categories = Category.all
  end
end
