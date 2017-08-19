class Chore < ActiveRecord::Base
  has_many :chore_tasks
  has_many :tasks, through: :tasks
  belongs_to :user

  validates :title, presence: true

  def self.find_by_slug(slugged)
    found = []
    self.all.each do |obj|
      if slugged == obj.slug
        found << obj
      end
    end
    found[0]
  end

  def slug
    strip_chars_array = self.title.downcase.scan(/[a-z0-9]+/)
    slug = strip_chars_array.join("-")
  end
end
