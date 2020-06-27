class Item < ApplicationRecord

	def self.options
		all.map{|o| ["#{o.name} (#{o.unit})", o.id]}.sort.uniq
	end

	def full_name
		"#{name} (#{unit})"
	end
end
