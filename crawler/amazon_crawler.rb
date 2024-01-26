require 'nokogiri'
require 'net/http'
require 'uri'
require 'openssl'
require 'json'

ITEM_RESULT = '.s-result-item'
NAME_STRUCTURE = 'h2 span'
PRICE_STRUCTURE = '.a-offscreen'
USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'

def fetch_page(url)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri.scheme == 'https'
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(uri.request_uri, {'User-Agent' => USER_AGENT})
  response = http.request(request)

  if response.code == '200'
    Nokogiri::HTML(response.body)
  else
    puts "Error fetching page #{url}: #{response.code}"
    nil
  end
end

def search_amazon(product_name, pages = 1)
  results = []

  (1..pages).each do |page_number|
    base_url = "https://www.amazon.pl/s?k=#{URI.encode_www_form_component(product_name)}&page=#{page_number}"
    puts "Page #{page_number}: in progress"

    doc = fetch_page(base_url)
    next unless doc

    puts "Page #{page_number} successful"
    
    doc.css(ITEM_RESULT).each do |item|
      name = item.css(NAME_STRUCTURE).text.strip
      next if name.empty?

      price = item.css(PRICE_STRUCTURE).first&.text&.strip
      results << { name: name, price: price }
    end
  end

  File.open('results.json', 'w') { |file| file.write(JSON.pretty_generate(results)) }
  puts "Saving to: results.json."
end

puts "Enter the product you want to search for:"
product = gets.chomp

puts "Enter the number of pages of results you want to see:"
pages = gets.chomp.to_i

search_amazon(product, pages)