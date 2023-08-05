//
//  ChatParameters.swift
//  OpenAIKit
//
//  Copyright (c) 2023 MarcoDotIO
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

public struct ChatParameters {
    /// ID of the model to use. Currently, only `gpt-3.5-turbo` and `gpt-3.5-turbo-0301` are supported.
    var model: ChatModels

    /// The messages to generate chat completions for, in the
    /// [chat format](https://platform.openai.com/docs/guides/chat/introduction).
    var messages: [ChatMessage]

    /// What [sampling temperature](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277)
    /// to use.
    ///
    /// Higher values means the model will take more risks.
    /// Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.
    ///
    /// We generally recommend altering this or `top_p` but not both.
    var temperature: Double

    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with `top_p` probability mass.
    ///
    /// So 0.1 means only the tokens comprising the top 10% probability mass are considered.
    /// We generally recommend altering this or `temperature` but not both.
    var topP: Double

    /// How many completions to generate for each prompt.
    ///
    /// **Note:** Because this parameter generates many completions, it can quickly consume your token quota.
    /// Use carefully and ensure that you have reasonable settings for `max_tokens` and `stop`.
    var numberOfCompletions: Int

    /// Whether to stream back partial progress. If set, tokens will be sent as data-only
    /// [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format)
    /// as they become available, with the stream terminated by a data: [DONE] message.
    var stream: Bool

    /// Up to 4 sequences where the API will stop generating further tokens.
    /// The returned text will not contain the stop sequence.
    var stop: [String]?

    /// Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far,
    /// increasing the model's likelihood to talk about new topics.
    ///
    /// [See more information about frequency and presence penalties.](https://beta.openai.com/docs/api-reference/parameter-details)
    var presencePenalty: Double

    /// Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far,
    /// decreasing the model's likelihood to repeat the same line verbatim.
    ///
    /// [See more information about frequency and presence penalties.](https://beta.openai.com/docs/api-reference/parameter-details)
    var frequencyPenalty: Double

    /// Modify the likelihood of specified tokens appearing in the completion.
    ///
    /// Accepts a json object that maps tokens (specified by their token ID in the GPT tokenizer) to an associated bias value from -100 to 100.
    /// You can use this [tokenizer tool](https://beta.openai.com/tokenizer?view=bpe) (which works for both GPT-2 and GPT-3) to convert text to token IDs.
    /// Mathematically, the bias is added to the logits generated by the model prior to sampling.
    /// The exact effect will vary per model, but values between -1 and 1 should decrease or increase likelihood of selection;
    /// values like -100 or 100 should result in a ban or exclusive selection of the relevant token.
    ///
    /// As an example, you can pass `{"50256": -100}` to prevent the `<|endoftext|>` token from being generated.
    var logitBias: [String: Int]?

    /// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    /// [Learn more.](https://beta.openai.com/docs/guides/safety-best-practices/end-user-ids)
    var user: String?

    public init(
        model: ChatModels,
        messages: [ChatMessage],
        temperature: Double = 1.0,
        topP: Double = 1.0,
        numberOfCompletions: Int = 1,
        stream: Bool = false,
        stop: [String]? = nil,
        presencePenalty: Double = 0.0,
        frequencyPenalty: Double = 0.0,
        logitBias: [String : Int]? = nil,
        user: String? = nil
    ) {
        self.model = model
        self.messages = messages
        self.temperature = temperature
        self.topP = topP
        self.numberOfCompletions = numberOfCompletions
        self.stream = stream
        self.stop = stop
        self.presencePenalty = presencePenalty
        self.frequencyPenalty = frequencyPenalty
        self.logitBias = logitBias
        self.user = user
    }

    // The body of the URL used for OpenAI API requests.
    public var body: [String: Any] {
        var result: [String: Any] = [
            "model": self.model.description,
            "temperature": self.temperature,
            "top_p": self.topP,
            "n": self.numberOfCompletions,
            "stream": self.stream,
            "presence_penalty": self.presencePenalty,
            "frequency_penalty": self.frequencyPenalty,
            "messages": self.messages.map { $0.body }
        ]

        if let stop = self.stop {
            result["stop"] = stop
        }

        if let logitBias = self.logitBias {
            result["logit_bias"] = logitBias
        }

        if let user = self.user {
            result["user"] = user
        }

        return result
    }
}