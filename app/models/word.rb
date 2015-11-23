class Word < ActiveRecord::Base
  belongs_to :category
  has_many :word_answers, dependent: :destroy

  has_and_belongs_to_many :lessons

  validates :content,  presence: true

  accepts_nested_attributes_for :word_answers, allow_destroy: true

  learned_word_ids = "SELECT words.id FROM lessons_words, lessons WHERE lessons.user_id = :user_id AND lessons.id = lessons_words.lesson_id"
  scope :learned_words, ->user {where "id IN (#{learned_word_ids})", user_id: user.id}
  scope :not_learned_words, ->user {where "id NOT IN (#{learned_word_ids})", user_id: user.id}
  scope :filter_category, ->category_id {where category_id: category_id if category_id.present?}

  def to_s
    content
  end
end