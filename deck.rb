class Deck

  # カードの初期設定
  def initialize

    card = []

    mk = ["spade", "Heart", "Dia", "Club"]

    num = ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q" ,"K"]

    # カードの生成
    for i in(0..3)
      for k in(0..12)
        card << mk[i] + num[k].to_s
      end
    end

  end

  def shuffle
    # カードをシャッフル
    card = card.shuffle
    puts card
  end

end