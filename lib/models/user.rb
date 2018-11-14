class User < ActiveRecord::Base

  has_many :userskill
  has_many :matches
  has_many :buddies, :through => :matches, :source => 'buddy'

end
