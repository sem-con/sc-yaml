# == Schema Information
#
# Table name: stores
#
#  id         :integer          not null, primary key
#  item       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  prov_id    :integer
#

class Store < ApplicationRecord
end
