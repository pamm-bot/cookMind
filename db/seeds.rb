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

# Crée des recettes sauvegardées
puts "Creating recipes..."
Recipe.create!(
  title: "Shakshuka",
  content: "A delicious North African egg dish poached in spicy tomato sauce.",
  ingredients: "eggs, tomatoes, peppers, onions, garlic, cumin, paprika",
  calories: "350",
  meal_type: "breakfast",
  user: user
)

Recipe.create!(
  title: "Caprese Salad",
  content: "A simple Italian salad with fresh mozzarella, tomatoes and basil.",
  ingredients: "mozzarella, tomatoes, basil, olive oil, balsamic",
  calories: "250",
  meal_type: "lunch",
  user: user
)

# Crée un chat de démo
puts "Creating demo chat..."
chat = Chat.create!(
  title: "What do you want to eat today 🧑‍🍳 ?",
  user: user
)

puts "Done! 🎉"
puts "Demo user: demo@cookmind.com / password123"
