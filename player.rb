class Player

  # 手札の配列を生成
  def initialize
    @hands = []
  end

  # 初回に2回デッキからカードを引く
  def first_draw_player(deck)
    # 生成したdeckからdrawメソッドを用いてカードを一枚引いてくる
    card = deck.draw
    # 引いたカードを手札に追加する
    @hands << card
    puts "あなたの1枚目のカードは『#{card.show}』です"
    # 初回は2回なので再度繰り返す
    card = deck.draw
    @hands << card
    puts "あなたの2枚目のカードは『#{card.show}』です"
  end

  # playerの点数を表示
  def point_player

    # 点数の初期化
    player_point = 0

    # 手札のカードを一枚ずつ確認して点数を計算していく
    @hands.each do |draw_card|

      # カードに対して、pointメソッドを用いて点数を確認。それを点数に足していく
      player_point += draw_card.point
      #puts player_point
    end
    puts "あなたの手札の合計点数は#{player_point}です。"
  end

end