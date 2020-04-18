return unless Rails.env.test?

CypressRails.hooks.before_server_start do
  # Called once, before ether the transaction or the server is started
end

CypressRails.hooks.after_transaction_start do
  User.connection.truncate User.table_name
  FactoryBot.create :user, username: 'cypress', password: 'cypress'
end

CypressRails.hooks.after_state_reset do
  Episode.connection.truncate Episode.table_name

  # published
  FactoryBot.create :episode, title: "Published", processed: true
  # unpublished
  FactoryBot.create :episode, title: "Unpublished", processed: true, published_at: 1.week.from_now
  # blocked
  FactoryBot.create :episode, title: "Blocked", processed: true, blocked: true
  # draft
  FactoryBot.create :episode, title: "Draft", audio: nil
end

CypressRails.hooks.before_server_stop do
  # Called once, at_exit
end
