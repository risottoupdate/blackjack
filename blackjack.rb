require "./deck"
require "./card"
require "./player"
require "./dealer"

# トランプデッキを作成
deck = Deck.new
player = Player.new

puts "BLACK JACKを開始します"
puts "まずはデッキからカードを2枚引きます"

# 生成したdeckからカードを引いてくる
player.first_draw_player(deck)

# playerのポイントを表示
player.point_player









# デッキ確認したい
# deck.view