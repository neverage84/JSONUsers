namespace :import do
  desc "Import users from api"
  task users: :environment do
    JsonImporter.import_users
    puts "Starting import of users"
  end
end
