# API Simple Call
- Getting Started:
    * get '/api/v1/estates'      [index]
    * get '/api/v1/estates/[id]' [Show]
    * post '/api/v1/estates/', **Params are required** [Create]
    * patch '/api/v1/estates/[id]' **Params are required** [Update]
    * delete '/api/v1/estates/[id]' [Delete]

- Searching
    * To Start searching
        - get '/api/v1/estates/search'
    * Use [type='xxxx'] to get all records with specific type.
    * Use [starting_price='xxxx' && ending_price='xxxx'] to get records with pricing range. [You can specify one only also]
    * Use [starting_square='xxxx' && ending_square='xxxx'] to get records with square feet range. [You can specify one only also]

- Pagination
    * get '/api/v1/estates?page=page_number'      [index]
    * get '/api/v1/estates/search?starting_price=xxx&&type=xxxx&&page=page_number'      [Search]

- Testing
    - Model & Controller Tests written with RSpec.
        - For testing: bundle exec rspec
        - **Controller Specs are inside spec/requests/**
- _After Database Setup & Migration, Keep 'estates.csv' inside the project folder and run 'rails db:seed' to populate data into the database._

