class Task < ActiveRecord::Base
  has_many :chore_tasks
  has_many :chores, through: :chores
end
