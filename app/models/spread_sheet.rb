class SpreadSheet
	include ActiveModel::Validations
	include ActiveModel::Conversion

	attr_accessor :file

	validates_presence_of :file

	def persisted?
		false
	end

end