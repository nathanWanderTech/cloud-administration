# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  title      :text
#  content    :text
#  category   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Article < ApplicationRecord
  has_many :comments
  belongs_to :user

  ALLOWED_CATEGORIES = ["World News", "Local News", "New From Below"]

  validates :title, presence: true
  validates :content, presence: true
end
