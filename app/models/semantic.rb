# == Schema Information
#
# Table name: semantics
#
#  id         :integer          not null, primary key
#  uid        :string
#  validation :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Semantic < ApplicationRecord
end
