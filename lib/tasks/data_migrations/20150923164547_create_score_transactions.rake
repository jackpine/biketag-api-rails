namespace :data_migrate do

  desc 'backfill score transactions for existing users/guesses'
  task :create_score_transactions do
    puts 'Adding new user scores'
    User.find_each do |user|
      # attempt idempotency
      if user.score_transactions.where(amount: ScoreTransaction::ScoreAmounts::NEW_USER).empty?
        print 'x'
        ScoreTransaction.credit_for_new_user(user)
      else
        print '.'
      end
    end
    puts ' done!'

    puts 'Adding correct guess scores'
    Guess.where(correct: true).find_each do |guess|
      # only gives users one correct guess. will have to be revisited if we're
      # going to use it down the road when real users have more than one
      # correct guess
      if guess.user.score_transactions.where(amount:
          ScoreTransaction::ScoreAmounts::CORRECT_GUESS).empty?
        print 'x'
        ScoreTransaction.credit_for_correct_guess(guess)
      else
        print '.'
      end
    end
    puts ' done!'
  end
end
