require "./deck"
require "./card"
require "./player"
require "./dealer"
require "./money"

def game_start
  money = Money.new

  puts <<~text
  ----------------------------------
  |                                |
  |           BLACK JACK           |
  |                                |
  ----------------------------------

  text
  # moneyは維持したまま、ゲームをループさせる
  while true
    # トランプデッキ、プレイヤー、ディーラーを生成
    deck = Deck.new
    player = Player.new
    dealer = Dealer.new

    # 変数初期化
    bust_flag = 0

    # 現在の所持金を取得
    @money_show = money.bet_money(0)

    puts <<~text

    現在の所持金は#{@money_show}円です。
    掛け金を入力して下さい。

    text

    while true
      @bet = gets.chomp.to_i

      # １円〜所持金のみ入力受け取り
      if @bet.between?(1, @money_show)
        @money_show = money.bet_money(@bet)
        puts <<~text

        ---------money_information--------
        掛け金 ： #{@bet}円
        残り所持金 ： #{@money_show}円
        ----------------------------------

        text
        break
      else
        puts <<~text

        ----------------------------------
        error ： 所持金以下の数値を入力してください
        ----------------------------------

        text
      end
    end

    puts <<~text

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
    player_use_11 = player.count_11
    if player_use_11 == 0
      puts <<~text
      あなたの手札の合計点数は#{@player_point}です。
      ----------------------------------
      text
    else
      puts <<~text
      あなたの手札の合計点数は#{@player_point}、もしくは#{@player_point-10}です。
      ----------------------------------
      text
    end

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
          bust_flag = 1
          break
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

    if bust_flag == 0
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
      judge(player, dealer, money)

    end

    # 所持金が0になったら終了
    if @money_show <= 0

      puts <<~text

      所持金が0円になりました。
      ----------------------------------

      ゲームオーバー

      text
      break
    else

      puts <<~text
      現在の所持金 ： #{@money_show}円
      ----------------------------------

      1.ゲームを続ける 2.ゲームをやめる

      text

      continue = gets.chomp.to_i
      if continue == 1
        
        puts <<~text

        ゲーム続行

        text

      elsif continue == 2
        puts <<~text

        ゲーム終了

        text
        break
      else
        puts <<~text

        ----------------------------------
        error ： 1か2を入力してください
        ----------------------------------

        text
      end

    end

  end

end

def judge(player, dealer, money)

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

    ---------money_information--------
    text

    @money_show = money.paid_money(@bet)

  # プレイヤーの点数が21ちょうど→ブラックジャック
  elsif @player_point == 21
    puts <<~text


    ブラックジャック！おめでとうございます。あなたの勝ちです。

    text

    # ブラックジャックの場合はベット額✖1.5倍の支払い
    paid = @bet + @bet*1.5
    @money_show = money.paid_money(paid.floor)
    puts "---------money_information--------"
    puts "支払い金額 ： #{paid.floor}円"

  # ディーラーの点数が22以上→ディーラーバースト
  elsif @dealer_point >= 22
    puts <<~text


    ディーラーがバーストしました。
    おめでとうございます。あなたの勝ちです！

    text

    # 勝利の場合はベット額✖1倍の支払い
    paid = @bet + @bet
    @money_show = money.paid_money(paid.floor)
    puts "---------money_information--------"
    puts "支払い金額 ： #{paid}円"

  # ディーラーの点数がプレイヤーの点数より高い→ディーラーの勝ち
  elsif @dealer_point > @player_point
    puts <<~text


    ディーラーの勝利。あなたの負けです。

    ---------money_information--------
    text

  # ディーラーの点数がプレイヤーの点数より低い→プレイヤーの勝ち
  else
    puts <<~text


    おめでとうございます。あなたの勝ちです。

    text

    paid = @bet + @bet
    @money_show = money.paid_money(paid.floor)
    puts "---------money_information--------"
    puts "支払い金額 ： #{paid}円"

  end

end

# ユーザがバーストした際の処理
def bust(name)
  puts <<~text


  バーストしました。#{name}の負けです

  ---------money_information--------
  text
end

# ここからスタート
game_start