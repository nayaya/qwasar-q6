require 'json'

def my_data_process(data_array)

    data_array.map! do |row|
        row.split(",")
    end

    headers = data_array.first
    head_vals = Hash.new
    values = []
    headers.each_with_index do |header, index|
        next if [1,2,3,8].include?(index)
        data_array.each_with_index do |record, i|
            next if i == 0
            values << record[index].gsub('\\n', '')
        end 
        head_vals[header] = values
        values = []
    end
    results = head_vals.clone
    headers.each_with_index do |head, i| 
        next if [1,2,3,8].include?(i)
        header_value_count = Hash.new
        head_vals[head].each do |value|
            if header_value_count[value]
                header_value_count[value] += 1
            else
                header_value_count[value] = 1
            end
        end
        results[head] = header_value_count
    end
    return results.to_json
end

# transformed_output =  my_data_process(["Gender,FirstName,LastName,UserName,Email,Age,City,Device,Coffee Quantity,Order At", "Male,Carl,Wilderman,carl,yahoo.com,21->40,Seattle,Safari iPhone,2,afternoon", "Male,Marvin,Lind,marvin,hotmail.com,66->99,Detroit,Chrome Android,2,afternoon", "Female,Shanelle,Marquardt,shanelle,hotmail.com,21->40,Las Vegas,Chrome,1,afternoon", "Female,Lavonne,Romaguera,lavonne,yahoo.com,66->99,Seattle,Chrome,2,morning", "Male,Derick,McLaughlin,derick,hotmail.com,41->65,Chicago,Chrome Android,1,afternoon"])
# print transformed_output