# README

**Import and persist the users from the following API.**

- Tables: User, Address, & Company
- Service: JsonImporter.import_users
- Rake Task: rake import:users

**Create a JSON API endpoint for users**
```
Rails.application.routes.draw do
  namespace :api do
    get 'users/search', to: 'users#search'
    get 'users', to: 'users#index'
  end
end
```

**Create a basic search JSON API endpoint that will return user data based on any
combination of the following parameters:**
● Name
● Email
● Street address
● Phone
● Zip
● Company name

- localhost:3000/api/search?name=John+Doe&email=abc@gmail.com&street_address=123+Main+St

  


