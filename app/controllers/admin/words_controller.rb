class Admin::WordsController < ApplicationController
  before_action :logged_in_user, :load_dependencies
  before_action :admin_user, only: [:create, :new]

  def index
    @words = Word.all.paginate page: params[:page]
  end

  def new
    @word = Word.new
    4.times{@word.word_answers.build}
  end


  def create
    @word = Word.new word_params
    if @word.save
      redirect_to admin_words_path
    else
      render :new
    end
  end

  private

  def word_params
    params.require(:word).permit :id, :category_id, :content,
                                 word_answers_attributes: [:id, :content, :correct, :word_id]
  end

  def load_dependencies
    @categories = Category.all
    unless params[:category_id].nil?
      @category = Category.find params[:category_id]
      @words = generate_words
    end
  end

  def generate_words
    if params[:word_stat] == "not_learned"
      Word.not_learned_words(current_user).filter_category(@category.id)
    elsif params[:word_stat] == "learned"
      Word.learned_words(current_user).filter_category(@category.id)
    else
      Word.filter_category(@category.id)
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t :log_in_flash
      redirect_to login_url
    end
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end