class Chore < ActiveRecord::Base
  has_many :chore_tasks
  has_many :tasks, through: :tasks
  belongs_to :user

end
