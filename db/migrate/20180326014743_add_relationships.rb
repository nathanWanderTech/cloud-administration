# frozen_string_literal: true

class AddRelationships < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :user_id, :integer
    add_column :comments, :user_id, :integer
  end
end
