# app/services/json_importer.rb
require 'json'
require 'net/http'

class JsonImporter

  def self.import_users
    begin
      uri = URI(ENV['JSON_USER_URL'])
      response = Net::HTTP.get(uri)
      users = JSON.parse(response)

      users.each do |user_data|

        # Create or find the associated address
        address = Address.find_or_create_by!(
          street: user_data.dig('address', 'street'),
          suite: user_data.dig('address', 'suite'),
          city: user_data.dig('address', 'city'),
          zipcode: user_data.dig('address', 'zipcode'),
          lat: user_data.dig('address', 'geo', 'lat'),
          lng: user_data.dig('address', 'geo', 'lng')
        )

        # Create or find the associated company
        company = Company.find_or_create_by!(
          name: user_data.dig('company', 'name'),
          catch_phrase: user_data.dig('company', 'catchPhrase'),
          bs: user_data.dig('company', 'bs')
        )

        # Create or update the user
        User.create!(
          id: user_data['id'], # Only include this if you want to use the JSON `id`
          name: user_data['name'],
          username: user_data['username'],
          email: user_data['email'],
          phone: user_data['phone'],
          address: address,
          company: company
        )
      end
    rescue StandardError => e
        Rails.logger.error("Failed to import user: #{user_data}, Error: #{e.message}")
    end
  end
end
