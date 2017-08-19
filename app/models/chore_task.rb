class ChoreTask < ActiveRecord::Base
  belongs_to :chore
  belongs_to :task
end
