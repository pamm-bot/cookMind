user = User.create!(
  email: "demo@example.com",
  password: "password"
)

Profil.create!(
  user: user,
  ingredients: ["chicken", "zucchini", "rice"],
  dietary_preferences: "No dietary restrictions"
)
