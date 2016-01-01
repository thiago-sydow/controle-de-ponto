namespace :migrate do
  desc 'Migrate from Mongo to Postgresql'
  task :mongo_to_postgresql => :environment do
    MongoModel::User.each.with_progress('Migrating users...') do |user|
      # user = MongoModel::User.where(email: 'fabiana.fontana@gmail.com').first #for debug single user
      pg_user = User.new(MongoModel::Parser.parsed_user_attributes(user.attributes))
      current_account_name = ''

      user.accounts.each do |account|
        pg_acc = pg_user.accounts.build(MongoModel::Parser.parsed_account_attributes(account.attributes))
        current_account_name = account.name if account.active

        account.day_records.each do |day|
          pg_day = pg_acc.day_records.build(MongoModel::Parser.parsed_day_record_attributes(day.attributes))

          day.time_records.each do |time_record|
            pg_time = pg_day.time_records.build(MongoModel::Parser.parsed_time_record_attributes(time_record.attributes))
          end

          # puts "DAY - MONGO => #{day.total_worked} ------- PG => #{pg_day.total_worked} -------- #{user.id}|#{user.email}|#{account.id}|#{day.id}" unless day.total_worked == pg_day.total_worked
        end

        account.closures.each do |closure|
          pg_closure = pg_acc.closures.build(MongoModel::Parser.parsed_closure_attributes(closure.attributes))

          pg_days_balance = pg_acc.day_records.select { |d| d.reference_date >= pg_closure.start_date && d.reference_date <= pg_closure.end_date }.inject(TimeBalance.new) { |sum_balance, day| sum_balance.sum(day.balance) }
          # puts "CLOSURE - MONGO  => #{closure.balance.to_seconds} ------- PG => #{pg_days_balance.to_seconds} -------- #{user.id}|#{user.email}|#{account.id}|#{closure.id}" unless closure.balance.to_seconds == pg_days_balance.to_seconds
        end
      end

      pg_user.skip_confirmation!
      pg_user.skip_confirmation_notification!
      pg_user.save!(validate: false) #if !pg_user.valid? && pg_user.errors.size == 1 && user.errors[:password].present?
      pg_user.reload

      pg_user.update!(current_account: pg_user.accounts.where(name: current_account_name).first)

      puts "WRONG CURRENT #{user.id}|#{user.email}|#{user.current_account.id}" unless user.current_account.name == pg_user.current_account.name
    end
  end
end
