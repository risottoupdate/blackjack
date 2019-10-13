class Deck

  # カードデッキを作成し、シャッフルまで行う
  def initialize
    # デッキの配列を生成
    @cards = []

    mk = ["スペード", "ハート", "ダイア", "クラブ"]
    num = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q" ,"K"]

    mk.each do |mark|
      num.each do |number|
        # markとnumberの組み合わせを一つずつcardクラスに渡し、それぞれのcardオブジェクトを生成する
        card = Card.new(mark, number)
        # 生成したcardを配列に格納していく
        @cards << card
      end
    end

    # デッキをシャッフルする
    @cards.shuffle!
  end

  def draw
    # 配列の最初の要素を抜き出す。最後から抜き出す場合はpop
    @cards.shift
  end

end