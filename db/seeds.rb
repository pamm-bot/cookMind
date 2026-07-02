# Supprime les données existantes pour repartir clean
puts "Cleaning database..."
Message.destroy_all
Chat.destroy_all
Recipe.destroy_all
Profil.destroy_all
User.destroy_all

# Crée un utilisateur de démo
puts "Creating demo user..."
user = User.create!(
  email: "demo@cookmind.com",
  password: "password123"
)

# Crée un profil
puts "Creating profil..."
Profil.create!(
  user: user,
  dietary_preferences: "vegetarian, gluten-free"
)

# Crée un chat de démo
puts "Creating demo chat..."
chat = Chat.create!(
  title: "What do you want to eat today 🧑‍🍳 ?",
  user: user
)

puts "Done! 🎉"
puts "Demo user: demo@cookmind.com / password123"
