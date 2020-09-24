require 'date'
require 'json'

def get_time(date_string)
    hour = DateTime.parse(date_string, '%Y-%m-%d %H:%M:%S').hour
    return hour >= 18 && hour < 24 ? 'evening' : hour >= 12 && hour < 18 ? 'afternoon' : 'morning'
end

def my_csv_parser(param_1, param_2 = ",")
    param_1.split("\n").map! do |row|
        row.split(param_2)
    end
end

def get_age_range(age)
    if age > 1 && age <= 20
        return "1->20"
    elsif age > 20 && age <= 40
        return "21->40"
    elsif age > 40 && age <= 65
         return "41->65"
    elsif age > 65 && age < 100
         return "66->99"
    else
        return "Invalid range"
    end
end

def get_domain(email)
    return email.split("@").last
end

def my_data_transform(data)
    info = my_csv_parser(data)
    transformed = []
    transformed << info.first
    info.each_with_index do |line, i|
        next if i == 0
        line.each_with_index do |record, index|
            index == 4 && line[index] = get_domain(line[index])
            index == 5 && line[index] = get_age_range(line[index].to_i)
        end
        line[-1] = get_time(line[-1])
        transformed << line
    end
    return transformed.map! { |line| line.join(",") }.join("\n") + '\n'
end

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