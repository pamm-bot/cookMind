class LlmService
  def initialize
    @client = RubyLLM::Client.new(
      api_key: ENV["OPENAI_API_KEY"],
      base_url: ENV["LLM_BASE_URL"]
    )
  end

  def call(prompt)
    response = @client.chat(
      model: "meta-llama/llama-3.1-8b-instruct",
      messages: [
        { role: "user", content: prompt }
      ]
    )

    response.content
  end
end
