require 'net/http'
require 'uri'
require 'json'

class QuoteService
  def self.generate_zen_story(title, snippet)
    api_key = ENV['GEMINI_API_KEY'].to_s
    safe_title = title.to_s.presence || "A new discovery"
    safe_snippet = snippet.to_s.presence || "a change in the digital landscape"

    # The NEW Poetic Prompt
    poetic_prompt = <<-PROMPT
      Act as a contemplative philosopher and poetic diarist writing in a weathered, handmade notebook.
      The news is: '#{safe_title}'.
      Context: #{safe_snippet}.

      TASK: Write a 3-paragraph reflective entry. Do not summarize the news.

      1. Paragraph 1: Start with a metaphor for the current atmosphere of the world (use sensory details like light, rain, or silence).
      2. Paragraph 2: Connect the news title to a deeper human truth or the shifting weight of our collective soul.
      3. Paragraph 3: Offer a quiet, breath-like closing thought that leaves the reader in a state of peace.

      STYLE: Lyrical, soft, grounded. No bold text, no headers, no links. Use words that feel like ink flowing onto paper.
    PROMPT

    begin
      uri = URI.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=#{api_key}")
      request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')

      request.body = {
        contents: [{
          parts: [{ text: poetic_prompt }]
        }],
        safetySettings: [
          { category: "HARM_CATEGORY_HARASSMENT", threshold: "BLOCK_NONE" },
          { category: "HARM_CATEGORY_HATE_SPEECH", threshold: "BLOCK_NONE" },
          { category: "HARM_CATEGORY_SEXUALLY_EXPLICIT", threshold: "BLOCK_NONE" },
          { category: "HARM_CATEGORY_DANGEROUS_CONTENT", threshold: "BLOCK_NONE" }
        ],
        generationConfig: {
          temperature: 0.8, # Slightly higher for more creative/poetic word choices
          maxOutputTokens: 1000
        }
      }.to_json

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      result = JSON.parse(response.body)
      story = result.dig("candidates", 0, "content", "parts", 0, "text")

      return story if story.present?

      puts "DEBUG: API Response Code: #{response.code}"
      puts "DEBUG: API Response Body: #{response.body}"

    rescue => e
      puts "DEBUG: Rescue Error: #{e.message}"
    end

    local_story(safe_title, safe_snippet)
  end

  private

  def self.local_story(title, snippet)
    opening = snippet.downcase.include?("ai") ? "A digital hum fills the air, a vibration of logic and light." : "The world turns quietly today, carrying new whispers upon a restless wind."

    "#{opening}\n\n" \
    "The news of '#{title}' arrived like a stone cast into a deep, still pond. We watch the ripples move outward, " \
    "wondering where they will eventually touch the shore of our shared experience. In this shift, we see the " \
    "duality of our time: the closing of one heavy door while another opens toward a horizon we cannot yet name.\n\n" \
    "Perhaps the lesson is not in the change itself, but in our quiet ability to witness it. " \
    "We remain breathing and observant, finding a rhythm amidst the noise of the machine. " \
    "The world is vast and loud, but here, the ink is steady."
  end
end
