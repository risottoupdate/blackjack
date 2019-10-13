require "./deck"
require "./card"
require "./player"
require "./dealer"


def game_start
  # トランプデッキ、プレイヤー、ディーラーを生成
  deck = Deck.new
  player = Player.new
  dealer = Dealer.new

  puts <<~text
  ----------------------------------
  |                                |
  |           BLACK JACK           |
  |                                |
  ----------------------------------

  まずはディーラー、プレイヤー共に
  デッキからカードを2枚引きます

  text

  # 生成したdeckからカードを引いてくる
  dealer.first_draw_dealer(deck)

  # dealerのポイントを計算
  @dealer_point = dealer.point_dealer

  # 生成したdeckからカードを引いてくる
  player.first_draw_player(deck)

  # playerのポイントを計算
  @player_point = player.point_player
  puts <<~text
  あなたの手札の合計点数は#{@player_point}です。
  ----------------------------------
  text

  # PlayerがStandを選択するまでカードを引き続けるループ処理
  while true
    puts <<~text

    あなたの行動を選択してください

    1.Hit 2.Stand

    text

    # ユーザの入力数値をaction変数に代入
    action = gets.chomp.to_i

    if action == 1

      # ユーザがHitを選択。デッキからカードを引く
      player.draw_player(deck)

      # playerのポイントを計算
      @player_point = player.point_player
      puts <<~text
      あなたの手札の合計点数は#{@player_point}です。
      ----------------------------------
      text

      if @player_point >= 22

        # playerのポイントが22を超えるとバースト。即ゲーム終了
        bust("あなた")

        # ゲームを終了するので、breakではなくreturn
        return
      end

    elsif action == 2
      # ユーザがStandを選択。ループ処理を抜ける
      break
    else
      # ユーザが指定数以外を入力。ループ継続
      puts <<~text
      ----------------------------------
      error ： 1か2を入力してください
      ----------------------------------
      text
    end
  end

  # ディーラーのポイントが17以上になるまでカードを引き続ける
  while @dealer_point <= 16

    # デッキからカードを1枚引く
    dealer.draw_dealer(deck)

    # dealerポイントを計算
    @dealer_point = dealer.point_dealer
  end
  puts <<~text

  ディーラーがカードを引き終わりました
  勝敗判定に参りましょう

  text

  # judgeメソッドにて処理
  judge(player, dealer)

end

def judge(player, dealer)

  # ディーラーの手札公開、合計点数を表示
  dealer.hands_show_dealer
  @dealer_point = dealer.point_dealer
  puts <<~text
  ディーラーの手札の合計点数は#{@dealer_point}です。
  ----------------------------------
  text

  # プレイヤーの手札公開、合計点数を表示
  player.hands_show_player
  @player_point = player.point_player
  puts <<~text
  あなたの手札の合計点数は#{@player_point}です。
  ----------------------------------
  text

  # ディーラーの点数とプレイヤーの点数が同数→引き分け
  if @dealer_point == @player_point
    puts <<~text


    合計得点が同点となりました。引き分けです。

    text

  # プレイヤーの点数が21ちょうど→ブラックジャック
  elsif @player_point == 21
    puts <<~text


    ブラックジャック！おめでとうございます。あなたの勝ちです。

    text

  # ディーラーの点数が22以上→ディーラーバースト
  elsif @dealer_point >= 22
    puts <<~text


    ディーラーがバーストしました。
    おめでとうございます。あなたの勝ちです！

    text

  # ディーラーの点数がプレイヤーの点数より高い→ディーラーの勝ち
  elsif @dealer_point > @player_point
    puts <<~text


    ディーラーの勝利。あなたの負けです。

    text

  # ディーラーの点数がプレイヤーの点数より低い→プレイヤーの勝ち
  else
    puts <<~text


    おめでとうございます。あなたの勝ちです。

    text
  end

end

# ユーザがバーストした際の処理
def bust(name)
  puts <<~text


  バーストしました。#{name}の負けです

  text
end

# ここからスタート
game_start