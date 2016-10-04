class UserSchema < NormalizrRuby::Schema
  attribute :id
  attribute :first_name
  attribute :last_name, if: :with_last_name?
  attribute :full_name, if: :with_full_name?
  association :reactions
  association :team

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def with_full_name?
    props[:with_full_name]
  end

  def with_last_name?
    props[:with_last_name]
  end
end
