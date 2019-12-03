class Player

  @@money = 100000

  # 手札の配列を生成
  def initialize
    @hands = []
  end

  def money
    @@money
  end

  # 所持金からベット額を減額
  def bet_money(money)
    @@money -= money
  end

  # 所持金に支払われた金額を増額
  def paid_money(money)
    @@money += money
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

  def hands
    @hands
  end

  def count_11
    @count_11
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