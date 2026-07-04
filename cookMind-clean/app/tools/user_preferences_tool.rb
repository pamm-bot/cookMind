class UserPreferencesTool < RubyLLM::Tool
  description "Gets the dietary preferences and available ingredients of the current user."

  def initialize(user:)
    @user = user
  end

  def execute
    profil = @user.profil

    return "No profile found for this user." unless profil

    {
      dietary_preferences: profil.dietary_preferences,
      ingredients: profil.ingredients
    }
  end
end
