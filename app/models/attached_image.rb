class AttachedImage < ActiveRecord::Base
  include ::SimpleSort::Base
  include ::Pagination::Base
  include ::AttachedImages::Base
  include ::TheSortableTree::Scopes
  include ::Notifications::LocalizedErrors

  acts_as_nested_set scope: [:user_id, :holder_id, :holder_type]

  belongs_to :user
  belongs_to :holder, polymorphic: true
  validates  :holder, presence: true
end