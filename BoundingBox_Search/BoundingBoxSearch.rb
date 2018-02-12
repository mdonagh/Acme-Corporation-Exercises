# The default function of the looks for sample_data.csv and accepts four arguments: left_x, right_x, lower_y, upper_y, right_y
# If you don't want to include one of these limits, pass "nil" as a parameter
# If you want to run multiple queries, we can also read a CSV, which should have:
# left_x, right_x, lower_y, upper_y, right_y, path_to_target_csv . Target CSV will default to './sample_data.csv'

class BoundingBoxSearch
  require 'pathname'
  require 'csv'

  def self.main
    parse_arguments
    return analyze_csv(@left_x, @right_x, @lower_y, @upper_y, @input_csv) if !@query_csv
    read_query_csv
  end

  def self.read_query_csv
    puts @query_csv
    CSV.foreach(@query_csv) do |row|
      left_x = row[0].to_f
      right_x = row[1].to_f
      lower_y = row[2].to_f
      upper_y = row[3].to_f
      input_csv = row[4] if row[4]
      input_csv ||= "./sample_data.csv"
      input_csv = "./#{input_csv}" unless @query_csv.include?('/')

      analyze_csv(left_x, right_x, lower_y, upper_y, input_csv)
    end
  end

  def self.analyze_csv(left_x, right_x, lower_y, upper_y, input_csv)
  output_filename = "search_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}"
  append_row(output_filename, ["left_x: #{left_x}", "right_x: #{right_x}", "lower_y: #{lower_y}", "right_x: #{right_x}"])
  append_row(output_filename, ["X COORDINATE", "Y COORDINATE", "VALUE"])

   CSV.foreach(input_csv) do |row|
      x = row[0].to_f
      y = row[1].to_f
      next unless x >= left_x if left_x
      next unless x <= right_x if right_x
      next unless y >= lower_y if lower_y
      next unless y <= upper_y if upper_y
      append_row(output_filename, row)
    end
    puts "RESULT:"
    CSV.foreach(output_filename) do |row|
      output = "#{row[0]} | #{row[1]} | #{row[2]}"
      output << " | #{row[3]}" if row[3]
      output << " | #{row[4]}" if row[4]
      puts output
    end
  end


  def self.append_row(output_filename, row)
    CSV.open(output_filename, "ab") do |csv|
      csv << row
    end
  end

  def self.parse_arguments
      if ARGV.length > 3
        @left_x = ARGV[0]
        @right_x = ARGV[1]
        @lower_y = ARGV[2]
        @upper_y = ARGV[3]
        @input_csv = ARGV[4] if ARGV[4]
        @input_csv ||= "./sample_data.csv"
      elsif ARGV.length == 1
        @query_csv = ARGV[0]
        @query_csv = "./#{@query_csv}" unless @query_csv.include?('/')
      else
        puts "Invalid arguments - please provide either left_x, right_x, lower_y, upper_y, (path) or the path to a CSV"
      end

    # multiple arguments can be loaded if there is one argument and that argument is a CSV.
    # Otherwise, just accept four arguments, and if you don't want a limit, then just pass nil
    # for that value. 
    # upper y lower y left x right x - that's the order 
    return [ARGV[0], ARGV[1], ARGV[2], ARGV[3]] if ARGV.length == 4
  end

end

BoundingBoxSearch::main