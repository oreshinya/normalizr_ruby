# NormalizrRuby

[Normalizr](https://github.com/paularmstrong/normalizr) format JSON generator.

## Installation

```ruby
gem "normalizr_ruby"
```

## Getting Started

Include `NormalizrRuby::Normalizable` in your 'ApplicationController':

```ruby
class ApplicationController < ActionController::API
  include NormalizrRuby::Normalizable
end
```

Create a new normalizr's schema:

```
bundle exec rails g normalizr_ruby:schema user
```

This will generate a schema in `app/schemas/user_schema.rb` for your `User` model:

```ruby
class UserSchema < NormalizrRuby::Schema
  attribute :id
end
```

You can customize it like this:

```ruby
class UserSchema < NormalizrRuby::Schema
  attribute :id
  attribute :first_name
  attribute :last_name
  attribute :full_name, if: :has_last_name?
  association :team
  association :comments, schema: CustomCommentSchema, if: :has_last_name?

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def has_last_name?
    object.last_name.present?
  end
end
```

Render json like this:

```ruby
class UsersController < Applicationcontroller
  def index
    users = User.all
    render json: users
  end
end
```

You will get response like this:

```json
{
  "result": [1, 2],
  "entities": {
    "teams": {
      "1": { "id": 1, "name": "Team A" }
    },
    "users": {
      "1": { "id": 1, "firstName": "Michael", "lastName": "Jackson", "fullName": "Michael Jackson", "team": 1, "comments": [2, 4] },
      "2": { "id": 2, "firstName": "Tom", "lastName": null, "team": 1 }
    },
    "comments": {
      "2": { "id": 2, "body": "Hello :)" },
      "4": { "id": 4, "body": "World ;)" }
    }
  }
}
```

## Documents

### Schema
#### `::attribute(key, options)`
Add an attribute to normalized entity.
`if` option can make an attribute conditional, and it takes a symbol of a method name on the schema.

#### `::association(key, options)`
Add an association to normalized entity, and add associated entity to entities.
`if` option can make an attribute conditional, and it takes a symbol of a method name on the schema.
`schema` option can make specifying a schema.

#### `#object`
You can refer unnormalized resource.

#### `#props`
You can refer arbitray options.

For example:

```ruby
class UserSchema < NormalizrRuby::Schema
  attribute :id
  attribute :hoge

  def hoge
    props[:arbitray_option]
  end
end

def UsersController < Applicationcontroller
  def show
    user = User.find(params[:id])
    render json: user, normalizr: { arbitray_option: 1 }
  end
end
```

#### `#context`
You can refer any values in all schemas

For example:

```ruby
class UserSchema < NormalizrRuby::Schema
  attribute :id
  attribute :is_current_user

  def is_current_user 
    context[:current_user].id == object.id
  end
end
```

### Render options

You can pass `normalizr`, and can pass any options as `props`.
But `schema` option can make specifying a schema.

```ruby
render json: user, normalizr: { schema: CustomUserSchema, hoge: 1, fuga: 2 }
```

### How to use context

You have to implement `normalizr_context` in any controller.

```ruby
class ApplicationController < ActionController::API
  include NormalizrRuby::Normalizable

  def normalizr_context
    { current_user: User.first }
  end
end
```

### Configuration

You can specify key transform in your `config/initializers/normalizr_ruby.rb`.

```ruby
NormalizrRuby.config.key_transform = :camel_lower # default
```

| Option | Result |
|----|----|
| `:camel` | ExampleKey |
| `:camel_lower` | exampleKey |
| `:dash` | example-key |
| `:unaltered` | the original, unaltered key |
| `:underscore` | example_key |
| `nil` | use the default |

## License

MIT
