require "./deck"
require "./card"
require "./player"
require "./dealer"
require "./money"
require "./message"

class Blackjack
  include Message

  BLACK_JACK = 21
  BUST_NUMBER = 22
  DEALER_DRAW_NUMBER = 16
  RATE = 1.5

  def start

    # Messageモジュール
    start_message

    # moneyは維持したまま、ゲームをループさせる
    while true

      # トランプデッキ、プレイヤー、ディーラーを生成
      build_player
      build_dealer
      build_deck

      # 変数初期化
      @player_bust_flag = 0
      @dealer_bust_flag = 0
      @count_11 = 0

      # Messageモジュール
      disp_money(@player)

      request_bet(@player)

      # Messageモジュール
      information1

      # 生成したdeckからカードを引いてくる
      @dealer.first_draw_dealer(@deck)

      # dealerのポイントを計算
      @dealer_point = point_dealer

      # 生成したdeckからカードを引いてくる
      @player.first_draw_player(@deck)

      # playerのポイントを計算
      @player_point = point_player
      if @count_11 == 0
        # Messageモジュール
        player_point_information1

      else
        # Messageモジュール
        player_point_information2
      end

      # PlayerがStandを選択するまでカードを引き続けるループ処理
      while true
        # Messageモジュール
        information2

        # ユーザの入力数値をaction変数に代入
        action = gets.chomp.to_i

        if action == 1

          # ユーザがHitを選択。デッキからカードを引く
          @player.draw_player(@deck)

          # playerのポイントを計算
          @player_point = point_player
          # Messageモジュール
          player_point_information3

          bust_check

          if @player_bust_flag == 1
            information13
            break
          end

        elsif action == 2
          # ユーザがStandを選択。ループ処理を抜ける
          break
        else
          # ユーザが指定数以外を入力。ループ継続
          # Messageモジュール
          information3

        end
      end

      if @player_bust_flag == 0
        # ディーラーのポイントが17以上になるまでカードを引き続ける
        while @dealer_point <= DEALER_DRAW_NUMBER

          # デッキからカードを1枚引く
          @dealer.draw_dealer(@deck)

          # dealerポイントを計算
          @dealer_point = point_dealer

          # dealerのバーストチェック
          bust_check

        end
        # Messageモジュール
        information4

        # judgeメソッドにて処理
        judge

      end

      # 所持金が0になったら終了
      if @money_show <= 0

        # Messageモジュール
        end_message

        break
      else

        # Messageモジュール
        continue_or_end_message

        continue = gets.chomp.to_i
        if continue == 1

          # Messageモジュール
          information5

        elsif continue == 2

          # Messageモジュール
          information6

          break
        else

          # Messageモジュール
          information7

        end

      end

    end

  end

  def judge

    # ディーラーの手札公開、合計点数を表示
    @dealer.hands_show_dealer
    @dealer_point = point_dealer
    # Messageモジュール
    dealer_point_information1

    # プレイヤーの手札公開、合計点数を表示
    @player.hands_show_player
    @player_point = point_player
    # Messageモジュール
    player_point_information4

    # ディーラーの点数とプレイヤーの点数が同数→引き分け
    if @dealer_point == @player_point
      # Messageモジュール
      information8

      @money_show = @player.paid_money(@bet)

    # プレイヤーの点数が21ちょうど→ブラックジャック
    elsif @player_point == BLACK_JACK
      # Messageモジュール
      information9

      # ブラックジャックの場合はベット額✖1.5倍の支払い
      paid = @bet + @bet*RATE
      @money_show = @player.paid_money(paid.floor)
      # Messageモジュール
      money_information1

    # ディーラーの点数が22以上→ディーラーバースト
    elsif @dealer_bust_flag == 1
      # Messageモジュール
      information10

      # 勝利の場合はベット額✖1倍の支払い
      @paid = @bet + @bet
      @money_show = @player.paid_money(@paid.floor)
      # Messageモジュール
      money_information2

    # ディーラーの点数がプレイヤーの点数より高い→ディーラーの勝ち
    elsif @dealer_point > @player_point
      # Messageモジュール
      information11

    # ディーラーの点数がプレイヤーの点数より低い→プレイヤーの勝ち
    else
      # Messageモジュール
      information12

      @paid = @bet + @bet
      @money_show = @player.paid_money(@paid.floor)
      # Messageモジュール
      money_information3

    end

  end

  # ユーザがバーストした際の処理
  def bust
    # Messageモジュール
    information13
  end

  def bust_check
    if @player_point >= BUST_NUMBER

      @player_bust_flag = 1

    elsif @dealer_point >= BUST_NUMBER

      @dealer_bust_flag = 1

    end
  end

  private

    def build_player
      @player = Player.new
    end

    def build_dealer
      @dealer = Dealer.new
    end

    def build_deck
      @deck = Deck.new
    end

    # playerの点数を表示
    def point_player

      # 点数の初期化
      player_point = 0
      count_a = 0

      # 手札のカードを一枚ずつ確認して点数を計算していく
      @player.hands.each do |draw_card|

        # カードに対して、pointメソッドを用いて点数を確認。それを点数に足していく
        player_point += point(draw_card)
        if point(draw_card) == 0
          count_a += 1
        end

      end
      count_a.times do |i|
        if player_point <= 10
          player_point += 11
          @count_11 = 1
        else
          player_point += 1
          @count_11 = 0
        end
      end

      return player_point
    end

    # dealerの点数を表示
    def point_dealer

      # 点数の初期化
      dealer_point = 0

      # 手札のカードを一枚ずつ確認して点数を計算していく
      @dealer.hands.each do |draw_card|

        # カードに対して、pointメソッドを用いて点数を確認。それを点数に足していく
        dealer_point += point(draw_card)
        #puts player_point
      end
      dealer_point
    end

    # 対象カードのポイントを返す
    def point(card)
      if card.number == "J" || card.number == "Q" || card.number == "K"
        return 10
      elsif card.number == "A"
        return 0
      else
        # 数字は文字列として格納されているので、数値に変換して返す
        return card.number.to_i
      end
    end

    def request_bet(player)
      while true
        @bet = gets.chomp.to_i

        # １円〜所持金のみ入力受け取り
        if @bet.between?(1, player.money)
          @money_show = player.bet_money(@bet)

          # Messageモジュール
          money_information4

          break
        else

          # Messageモジュール
          information14

        end
      end
    end
end