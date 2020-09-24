require 'date'
require 'json'
require_relative '../ex01/my_data_transform'
require_relative '../ex00/my_csv_parser'

def my_data_process(csv_string)
    array = my_csv_parser(csv_string)
    headers = array.first
    head_vals = Hash.new
    values = []
    headers.each_with_index do |header, index|
        next if [1,2,3,8].include?(index)
        array.each_with_index do |record, i|
            next if i == 0
            values << record[index].gsub('\\n', '')
        end 
        head_vals[header] = values
        values = []
    end
    results = head_vals.clone
    headers.each_with_index do |head, i| 
        next if [1,2,3,8].include?(i)
        header_values_count = Hash.new
        head_vals[head].each do |value|
            if header_values_count[value]
                header_values_count[value] += 1
            else
                header_values_count[value] = 1
            end
        end
        results[head] = header_values_count
    end
    return results.to_json
end

sample = "Gender,FirstName,LastName,UserName,Email,Age,City,Device,Coffee Quantity,Order At\nMale,Carl,Wilderman,carl,wilderman_carl@yahoo.com,53,Abuja,Safari iPhone,2,2020-03-06 16:37:56\nFemale,Marvin,Lind,marvin,marvin_lind@gmail.com,77,Detroit,Chrome Android,2,2020-03-02 8:55:51\nFemale,Shanelle,Marquardt,shanelle,marquardt.shanelle@hotmail.com,21,Las Vegas,Chrome,1,2020-03-05 21:53:05\n"
output = my_data_transform(sample)
transformed_output =  my_data_process(output)
puts transformed_output