class SearchRecipesTool < RubyLLM::Tool
  description "Searches saved recipes by keyword in title or ingredients."
  param :query, desc: "The keyword to search for"

  def initialize(user:)
    @user = user
  end

  def execute(query:)
    recipes = search_recipes(query)
    return "No saved recipes found for '#{query}'" if recipes.empty?

    format_recipes(recipes)
  end

  private

  def search_recipes(query)
    @user.recipes.where(
      "title ILIKE :q OR ingredients ILIKE :q",
      q: "%#{query}%"
    )
  end

  def format_recipes(recipes)
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
