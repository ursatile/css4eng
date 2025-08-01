File.readlines("test_content.html").each_with_index { |line, i| puts "#{i + 1}: #{line.chomp}" }
