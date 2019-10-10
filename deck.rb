class Deck

  # カードの初期設定
  def initialize

    @card = {}

    mk = ["スペード", "ハート", "ダイア", "クラブ"]

    num = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q" ,"K"]

    mk.each do |mark|
      num.each do |number|
        # 別のインスタンスを作成し、破壊的操作を回避
        mark_remember = mark.dup
        # マーク記号＋ナンバー
        mark_remember.concat(number)
        @card.merge!(mark_remember => number)
      end
    end

    def shuffle
      puts @card
    end

  end

end