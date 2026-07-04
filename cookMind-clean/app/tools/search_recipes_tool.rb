class SearchRecipesTool < RubyLLM::Tool
  description "Searches saved recipes by keyword in title or ingredients."
  param :query, desc: "The keyword to search for"

  def initialize(user:)
    @user = user
  end

  def execute(query:)
    recipes = @user.recipes.where(
      "title ILIKE :q OR ingredients ILIKE :q",
      q: "%#{query}%"
    )

    return "No saved recipes found for '#{query}'" if recipes.empty?

    recipes.map do |recipe|
      {
        id: recipe.id,
        title: recipe.title,
        ingredients: recipe.ingredients,
        meal_type: recipe.meal_type,
        calories: recipe.calories
      }
    end
  end
end
