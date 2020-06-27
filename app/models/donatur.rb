class Donatur < User

	def self.options
		all.map{|x| [x.name, x.id]}.sort.unshift(nil)
	end
end
