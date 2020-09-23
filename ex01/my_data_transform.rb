require 'date'
require 'csv'

def format_date(date_string)
    return date_string.sub('2020', '20').gsub('-', '/')
end

def get_time(date_string)
    hour = DateTime.strptime(format_date(date_string), '%d/%m/%y %H:%M').hour
    return hour >= 18 && hour < 24 ? 'evening' : hour >= 12 && hour < 18 ? 'afternoon' : 'morning'
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

def transform(data)
    info = CSV.parse(data)
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
    return transformed.map! { |line| line.join(',') }.join('\n')
end

# sample = "Gender,FirstName,LastName,UserName,Email,Age,City,Device,Coffee Quantity,Order At\nMale,Carl,Wilderman,carl,wilderman_carl@yahoo.com,29,Seattle,Safari iPhone,2,2020-03-06 16:37:56\nMale,Marvin,Lind,marvin,marvin_lind@hotmail.com,77,Detroit,Chrome Android,2,2020-03-02 13:55:51\nFemale,Shanelle,Marquardt,shanelle,marquardt.shanelle@hotmail.com,21,Las Vegas,Chrome,1,2020-03-05 17:53:05\n"
# print transform(sample)