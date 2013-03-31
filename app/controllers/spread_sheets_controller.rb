class SpreadSheetsController < ApplicationController

	before_filter :authenticate_user!

	def new
		@sheet = SpreadSheet.new
	end

	def create
		
		file = params[:spread_sheet][:file]

		if file
			
			new_path = "#{File.dirname(file.path)}/work#{current_user.id}#{File.extname(file.original_filename)}"

			File.rename(file.path, new_path)

			sheet = Roo::Spreadsheet.open(new_path)
			
			3.upto(sheet.last_row) do |row|
				Record.create(get_records_from_sheet_row(sheet, row))
			end
			
			redirect_to records_path, notice: 'Dados importados com sucesso!'
		else
			render :new, error: 'Corrija os erros abaixo'
		end
		
	end

	private

	def get_date_from_string(date_string)
		if date_string =~ /\d{2}\/\d{2}\/\d{4}/
			DateTime.strptime(date_string, '%d/%m/%Y')
		else
			DateTime.strptime(date_string, '%d/%m/%y')
		end
	end

	def get_records_from_sheet_row(sheet, row)
		
		returned_date = get_date_from_string(sheet.cell(row, 'A'))
		date = Date.new(returned_date.year, returned_date.month, returned_date.day).to_time
		records = Array.new

		'B'.upto('I') do |col|
			record_time = (Time.now.midnight + sheet.cell(row, col).seconds) rescue nil
			if record_time				

				date = date.change(hour: record_time.hour, min: record_time.min).utc

				records << {time: date, user: current_user}
			end
		end
		
		records
	end

end