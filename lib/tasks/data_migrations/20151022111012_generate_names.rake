namespace :data_migrate do

  desc 'generate names for users without one'
  task :generate_user_names do
    initial_count = User.where(name: nil).count
    puts "Generating usernames for #{initial_count} users without names."

    name_generator = NameGenerator.new
    User.where(name: nil).find_each do |user|
      generated_name = name_generator.generate
      puts generated_name
      user.update_attribute(:name, generated_name)
    end

    ending_count = User.where(name: nil).count
    puts "There are #{ending_count} users left without names."

  end
end
