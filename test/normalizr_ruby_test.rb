require 'test_helper'

class NormalizrRubyTest < Minitest::Test
  def setup
    team = Team.create(name: "Team 1")
    shinji = User.create(team: team, first_name: "Shinji", last_name: "Okazaki")
    shinji.comments.create(body: "Shinji's comment")
    keisuke = User.create(first_name: "Keisuke", last_name: "Honda")
    keisuke.comments.create(body: "Keisuke's comment")
    User.all.each do |user|
      Reaction.create(user: user, comment: Comment.first)
    end
    converter = NormalizrRuby::Converter.new({current_user: shinji})
    @normalized = converter.normalize(User.all, {
      with_full_name: true,
      with_last_name: false
    })
  end

  def test_normalized
    expected = {
      result: [1, 2],
      entities: {
        comments: {
          1 => {id: 1, body: "Shinji's comment"}
        },
        reactions: {
          1 => {id: 1, userId: 1, commentId: 1, ofCurrentUser: true, comment: 1},
          2 => {id: 2, userId: 2, commentId: 1, ofCurrentUser: false, comment: 1}
        },
        users: {
          1 => {id: 1, firstName: "Shinji", fullName: "Shinji Okazaki", reactions: [1], team: 1},
          2 => {id: 2, firstName: "Keisuke", fullName: "Keisuke Honda", reactions: [2], team: nil}
        },
        teams: {
          1 => {id: 1, name: "Team 1"}
        }
      }
    }
    assert { @normalized == expected }
  end
end
