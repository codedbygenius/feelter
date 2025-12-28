# db/seeds.rb
puts "Cleaning database..."
JournalEntry.destroy_all
Content.destroy_all
Mood.destroy_all
Category.destroy_all
User.destroy_all

puts "Creating categories..."
uplifting = Category.create!(name: "uplifting")
calming = Category.create!(name: "calming")
motivational = Category.create!(name: "motivational")
serious = Category.create!(name: "serious")

puts "Creating sample contents..."

# Uplifting Quotes
Content.create!(
  category: uplifting,
  content_type: :quote,
  title: "Joy Quote",
  blog: "The most wasted of days is one without laughter."
)

Content.create!(
  category: uplifting,
  content_type: :quote,
  title: "Happiness Quote",
  blog: "Happiness is not by chance, but by choice."
)

# Calming Quotes
Content.create!(
  category: calming,
  content_type: :quote,
  title: "Peace Quote",
  blog: "Peace comes from within. Do not seek it without."
)

Content.create!(
  category: calming,
  content_type: :quote,
  title: "Tranquility Quote",
  blog: "In the midst of movement and chaos, keep stillness inside of you."
)

# Motivational Quotes
Content.create!(
  category: motivational,
  content_type: :quote,
  title: "Success Quote",
  blog: "The only way to do great work is to love what you do."
)

Content.create!(
  category: motivational,
  content_type: :quote,
  title: "Perseverance Quote",
  blog: "Success is not final, failure is not fatal: it is the courage to continue that counts."
)

# Serious Quotes
Content.create!(
  category: serious,
  content_type: :quote,
  title: "Wisdom Quote",
  blog: "The unexamined life is not worth living."
)

# Sample Blogs
Content.create!(
  category: uplifting,
  content_type: :blog,
  title: "10 Ways to Brighten Your Day",
  blog: "Start your morning with gratitude. Research shows that practicing gratitude can significantly improve your mood and overall well-being. Try writing down three things you're grateful for each morning...",
  url: "https://example.com/brighten-day"
)

Content.create!(
  category: calming,
  content_type: :blog,
  title: "Mindfulness for Beginners",
  blog: "Mindfulness is the practice of being present in the moment. Start with just 5 minutes a day of quiet breathing exercises. Find a comfortable spot, close your eyes, and focus on your breath...",
  url: "https://example.com/mindfulness"
)

Content.create!(
  category: motivational,
  content_type: :blog,
  title: "Achieving Your Goals in 2025",
  blog: "Setting clear, achievable goals is the first step to success. Break down your big dreams into smaller, manageable tasks. Create a timeline and celebrate small wins along the way...",
  url: "https://example.com/goals-2025"
)

# Sample Music
Content.create!(
  category: uplifting,
  content_type: :music,
  title: "Happy Vibes Playlist",
  url: "https://open.spotify.com/playlist/37i9dQZF1DXdPec7aLTmlC"
)

Content.create!(
  category: calming,
  content_type: :music,
  title: "Peaceful Piano",
  url: "https://open.spotify.com/playlist/37i9dQZF1DX4sWSpwq3LiO"
)

Content.create!(
  category: motivational,
  content_type: :music,
  title: "Workout Motivation",
  url: "https://open.spotify.com/playlist/37i9dQZF1DX76Wlfdnj7AP"
)

# Sample Pictures
Content.create!(
  category: uplifting,
  content_type: :picture,
  title: "Beautiful Sunset",
  url: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4"
)

Content.create!(
  category: calming,
  content_type: :picture,
  title: "Zen Garden",
  url: "https://images.unsplash.com/photo-1528319725582-ddc096101511"
)

Content.create!(
  category: motivational,
  content_type: :picture,
  title: "Mountain Peak",
  url: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4"
)

puts "Creating test user..."
user = User.create!(
  email: "test@feelter.com",
  password: "password",
  first_name: "Test",
  last_name: "User"
)

puts "Creating sample moods and journal entries..."
mood1 = Mood.create!(user: user, feeling: :happy, category: uplifting)
JournalEntry.create!(
  user: user,
  mood: mood1,
  note: "Had a great day today! Feeling energized and positive."
)

mood2 = Mood.create!(user: user, feeling: :sad, category: calming)
JournalEntry.create!(
  user: user,
  mood: mood2,
  note: "Feeling a bit down, but trying to stay calm and centered."
)

mood3 = Mood.create!(user: user, feeling: :meh, category: motivational)
JournalEntry.create!(
  user: user,
  mood: mood3,
  note: "Just an average day, looking for some motivation."
)

puts "✅ Seed data created successfully!"
puts "📧 Test user: test@feelter.com / password"
