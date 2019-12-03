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

  def number
    @number
  end

end