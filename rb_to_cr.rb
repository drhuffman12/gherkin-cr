require 'fileutils'
paths.each do |path|
  to_path = path.gsub('.rb','.cr')
  puts "from_path: #{path}"
  puts "to_path  : #{to_path}"
  FileUtils.mv path, to_path
end
