class WordAnswer < ActiveRecord::Base
  belongs_to :word
  has_and_belongs_to_many :lessons

  validates :content,  presence: true

  scope :correct, -> { where(correct: true) }
  scope :correct_content, -> { correct.first.content }

  def to_s
    content
  end
end