require 'optparse'
require 'json'

options = {}
result = {}

OptionParser.new do |opt|
  opt.on('--user_id USER_ID') { |o| options[:user_id] = o }
  opt.on('--loyalty_card_id LOYALTY_CARD_ID') { |o| options[:loyalty_card_id] = o }
end.parse!

file = File.read('./input.json')
data = JSON.parse(file)

first_in_user = true
first_in_loyalty_card = true

data['rewards'].each { |reward, index|
    if options[:user_id].to_i == reward['user_id']
        if first_in_user
           result[:user] = {
             id: options[:user_id],
             total_points: 0,
             loyalty_cards: []
           }
           first_in_user = false
        end
        result[:user][:total_points] += reward['points']
        result[:user][:loyalty_cards] <<
            {
                id: reward['loyalty_card_id'],
                points: reward['points'],
                name: data['loyalty_cards'][reward['loyalty_card_id'] - 1]['name']
            }
    end
    if options[:loyalty_card_id].to_i == reward['loyalty_card_id']
        if first_in_loyalty_card
              result[:loyalty_card] = {
                id: options[:loyalty_card_id],
                name: data['loyalty_cards'][options[:loyalty_card_id].to_i - 1]['name'],
                total_points: 0
              }
            first_in_loyalty_card = false
        end
        result[:loyalty_card][:total_points] += reward['points']
    end
}

puts JSON.pretty_generate(result)
