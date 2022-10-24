# Speek

Speek is a type generator using schemafiles for Rails.

Speek supports rbs and GraphQL.

For example


```ruby.rbs
# cat example/schema/users.schema 
create_table "users", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB" do |t|
  t.string "name", null: false
  t.text "desc", null: true
  t.datetime "deleted_at"
  t.integer "weight", null: false, default: 0, unsigned: true
  t.boolean "is_banned", null: false, default: false

  t.timestamps
end

# speek -i example/schema/users.schema -s rbs
class User
  attr_accessor id: Integer
  attr_accessor name: String
  attr_accessor desc: (String | nil)
  attr_accessor deleted_at: (Time | nil)
  attr_accessor weight: Integer
  attr_accessor is_banned: Boolean
  attr_accessor created_at: Time
  attr_accessor updated_at: Time
end
```

日本語の紹介記事はこちら： https://gist.github.com/funwarioisii/2a9fa5f3f782c3752612887ccbd7c5fc

## Installation

    $ gem install speek

## Usage


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
