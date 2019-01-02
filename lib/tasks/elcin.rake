namespace :elcin do
  task anton_bd: :environment do
    TelegramWebhooksController.cooll('Дорогой, Антон! Поздравляю тебя с днем рождения!')
  end

  task test: :environment do
    TelegramWebhooksController.cooll('Если я это не прислал в 13:00, то Антон криворукий мудак!')
  end

end
