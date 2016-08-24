class ReactionSchema < NormalizrRuby::Schema
  attribute :id
  attribute :user_id
  attribute :comment_id
  attribute :of_current_user
  association :comment, schema: CustomCommentSchema

  def of_current_user
    context[:current_user].id == object.user_id
  end
end
