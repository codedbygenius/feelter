class ChatbotJob < ApplicationJob
  queue_as :default

  def perform(question)
    # 1. Fetch the AI response
    ai_response = fetch_ai_response(question)

    # 2. Save it to the database
    question.update!(ai_answer: ai_response)
  end

  private

  def fetch_ai_response(question)
    client = OpenAI::Client.new
    # Pass 'question' into the formatter
    messages = format_messages_for_openai(question)

    begin
      chatgpt_response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: messages
        }
      )

      return chatgpt_response.dig("choices", 0, "message", "content") || "I'm sorry, I couldn't generate a response right now."
    rescue StandardError => e
      Rails.logger.error "Chatbot API Error: #{e.message}"
      return "Oops, something went wrong. Please try again later."
    end
  end

  def format_messages_for_openai(question)
    # Use the 'question' passed into the method, NOT '@question'
    user = question.user

    # 1. Context from Moods
    recent_moods = user.moods.order(created_at: :desc).limit(3).pluck(:feeling)
    mood_context = recent_moods.any? ? "The user has recently felt: #{recent_moods.join(', ')}." : "No recent mood logs available."

    # 2. System Message
    messages = [
      { role: "system", content: "You are a compassionate therapist trained in mindfulness and emotional well-being. #{mood_context} Tailor your response accordingly. Your responses should be concise." }
    ]

    # 3. Chat History
    history = user.questions.where.not(id: question.id).order(created_at: :asc).last(5)

    history.each do |q|
      messages << { role: "user", content: q.user_question }
      messages << { role: "assistant", content: q.ai_answer || "..." }
    end

    # 4. The current question
    messages << { role: "user", content: question.user_question }

    messages
  end
end
