# README

## Installation
--

```
bundle install
```
Application is not using database. Therefore no need to call `rails db:setup`

## Running
--

```
rails s
```

You can send GET request to the URL `localhost:3000/recipes?q=foo`.

## Tests
--

```
rspec
```

## TODO
--
* Instead of in_memory cache consider using Redis or Memcache.
* Implement API versioning
* Write specs that validates responses by using json-schema
* Add unit test suites for recipe_service.rb
* Validation happens in recipes_controller could be extracted to external validation class
