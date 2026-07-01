class LlmService
  def initialize
    @client = RubyLLM::Client.new(
      api_key: ENV.fetch("OPENAI_API_KEY", nil),
      base_url: ENV.fetch("LLM_BASE_URL", nil)
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
