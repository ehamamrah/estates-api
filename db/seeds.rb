require 'csv'

csv_file = File.read('estates.csv')
csv_data = CSV.parse(csv_file, headers: true)

csv_data.each do |row|
  Estate.create(row.to_hash)
end
