class Chore < ActiveRecord::Base
  validates :title, presence: true

  extend Slugify::ClassMethod
  include Slugify::InstanceMethod

  has_many :chore_tasks
  has_many :tasks, through: :chore_tasks
  belongs_to :user


end
