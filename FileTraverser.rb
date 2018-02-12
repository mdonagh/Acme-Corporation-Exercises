class FileTraverser
  require 'pathname'
  require 'find'
  require 'ptools'

  def self.calculate_average_file_size
    count = 0
    bytes = 0
    f = File.open('secondary_action.txt', "r")
    f.each_line do |line|
      count += 1
      bytes += line.to_i
    end
    f.close
    f = File.open('secondary_action.txt', "w")
    average_file_size = bytes.to_f / count / 1024
    f.puts("Average Size of #{count} files: #{average_file_size.round(2)}k") 
    f.close
  end

  def self.record_file_size
    Proc.new do |file|
      next if File.directory?(file)
      File.open('secondary_action.txt', 'a+') do |secondary_action|
        secondary_action.puts("#{ File.size(file) }") 
      end
    end
  end

  def self.file_is_text?(file)
    return false if ['.ai', 
                     '.bmp', 
                     '.gif', 
                     '.ico', 
                     '.jpeg', 
                     '.jpg', 
                     '.png', 
                     '.svg', 
                     '.wmv', 
                     '.mp3', 
                     '.mp4'].include?(File.extname(file))
    true
  end

  def self.record_line_count
    Proc.new do |file|
      next if File.directory?(file) || File.binary?(file)
      next unless file_is_text?(file)
      line_count = File.foreach(file).inject(0) {|c, line| c+1}
      File.open('secondary_action.txt', 'a+') do |secondary_action|
        secondary_action.puts("#{file}, line count: #{ line_count }") 
      end
    end
  end

  def self.parse_arguments
    return ['default', Dir.pwd] if ARGV.length == 0
    pathname = Pathname.new(ARGV[0])
    if pathname.directory?
      target_path = pathname
      action = ARGV[1] if ARGV.length == 2
    else
      target_path = Dir.pwd
      action = ARGV[0]
    end
    action =  'default' unless action
    return [target_path, action]
  end

  def self.crawl_directory(target_path, action = false)
    File.open('file_list.txt', 'w') do |output| 
      Find.find(target_path) do |file| 
        next if file.include?('/.')
        next unless File.exists?(file)
        output.puts("#{file}, #{File.mtime(file) }") 
        action.call(file) if action
      end
    end
  end

  def self.main
    File.delete('file_list.txt') if File.exists?('file_list.txt')
    File.delete('secondary_action.txt') if File.exists?('secondary_action.txt')
    actions_hash = {'file_size' => record_file_size, 'line_count' => record_line_count, 'default' => nil}
    target_path, action = parse_arguments
    crawl_directory(target_path, actions_hash[action])
    calculate_average_file_size if action == 'file_size'
  end

end

FileTraverser::main()