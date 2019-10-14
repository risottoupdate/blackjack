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
    # 初回は2回なので再度繰り返す
    card = deck.draw
    @hands << card
    puts ""
    puts "------------Player手札------------"
    @hands.each.with_index(1) do |hand, i|
      puts " #{i}枚目 ： #{hand.show}"
    end
  end

  # playerの点数を表示
  def point_player

    # 点数の初期化
    player_point = 0
    count_a = 0
    @count_11 = 0

    # 手札のカードを一枚ずつ確認して点数を計算していく
    @hands.each do |draw_card|

      # カードに対して、pointメソッドを用いて点数を確認。それを点数に足していく
      player_point += draw_card.point
      if draw_card.point == 0
        count_a += 1
      end

    end
    count_a.times do |i|
      if player_point <= 10
        player_point += 11
        @count_11 += 1
      else
        player_point += 1
      end
    end

    return player_point
  end

  def count_11
    return @count_11
  end

  # カードを1枚引く
  def draw_player(deck)
    card = deck.draw
    @hands << card

    # 手札を1枚ずつ表示させる
    hands_show_player
  end

  # 手札を1枚ずつ表示する
  def hands_show_player
    puts <<~text
    
    ------------Player手札------------
    text

    # 手札を1枚ずつ表示していく。with_index(1)で1から連続する数値も表示
    @hands.each.with_index(1) do |hand, i|
      puts " #{i}枚目 ： #{hand.show}"
    end
  end

end