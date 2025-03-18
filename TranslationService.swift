//
//  TranslationService.swift
//  TranslateMe
//
//  Created by Christopher Petit on 3/17/25.
//

import Foundation

class TranslationService {
    static let shared = TranslationService()
    private let apiUrl = "https://api.mymemory.translated.net/get"

    // Translate text using MyMemory API
    func translate(text: String, from sourceLang: String = "en", to targetLang: String = "es", completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(apiUrl)?q=\(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&langpair=\(sourceLang)|\(targetLang)") else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let responseData = jsonResponse["responseData"] as? [String: Any],
                   let translatedText = responseData["translatedText"] as? String {
                    completion(translatedText)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
