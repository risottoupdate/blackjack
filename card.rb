class Card

  # カードオブジェクトの値を受け取る
  def initialize(mark, number)
    @mark = mark
    @number = number
  end

  # カードのmarkとnumberを表示する
  def show
    return "#{@mark}の#{@number}"
  end

  # 対象カードのポイントを返す
  def point
    if @number == "J" || @number == "Q" || @number == "K"
      return 10
    elsif @number == "A"
      return 1
    else
      # 数字は文字列として格納されているので、数値に変換して返す
      return @number.to_i
    end
      
  end

end