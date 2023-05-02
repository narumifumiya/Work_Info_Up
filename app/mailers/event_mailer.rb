class EventMailer < ApplicationMailer
  # コントローラ？のように使用する

  # 下のクラスメソッド内で使用するメソッド
  # このメソッド（アクション）が発動するとviews/event_mailer/send_notification.text.erbを呼出して、
  # メールを引数のデータに従ってメールを作成する。
  def send_notification(member, event)
    @group = event[:group]
    @title = event[:title]
    @body = event[:body]

    #メールを新規作成
     #from→送り主、to→送り先、subject→メールタイトルを入力
    @mail = EventMailer.new()
    mail(
      from: ENV['KEY'],
      to:   member.email,
      subject: '新規お知らせ'
    )
  end

  #　このクラスメソッドが発動されるとメールをグループメンバにメールを送信する
  # フォームでメールを送信を押したタイミングで発動(event_noticesコントローラの#create発動時)
  def self.send_notifications_to_group(event) #引数のeventはevent_noticesコントローラでハッシュでデータを入れている
    group = event[:group] #group_idを呼出
    group.users.each do |member| #group_idに紐づくuserを順番に取り出す
      # 上のメソッドを発動すると各メンバー毎にメールが作られて、.deliver_nowで送信をしている
      EventMailer.send_notification(member, event).deliver_now
    end
  end
end
