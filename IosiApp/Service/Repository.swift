//
//  File.swift
//  IosiApp
//
//  Created by aluno001 on 17/03/21.
//

import Foundation
import UIKit

class Repository {
    static let apiAcssess = Repository()
    let baseUrl = "https://iosi.herokuapp.com/"
    
    func getAllChatsFromUser(completion: @escaping (_ result: Result<[Chat], Error>)->Void) {
        let key = "605119ae977f59b9e2b494a4"
        if let baseUrl = URL(string: baseUrl) {
            let url = baseUrl.appendingPathComponent("chats").appendingPathComponent(key)
            let session = URLSession.shared
            session.dataTask(with: url) {
                (Data, URLResponse, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                if let data = Data {
                    do {
                        let decoder = JSONDecoder.init()
                        let chats = try decoder.decode([Chat].self, from: data)
                        completion(.success(chats))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
    
    func getAllMessages(completion: @escaping (_ result: Result<[Message], Error>)->Void, key: String) {
        if let baseUrl = URL(string: baseUrl) {
            let url = baseUrl.appendingPathComponent("messages").appendingPathComponent(key)
            let session = URLSession.shared
            session.dataTask(with: url) {
                (Data, URLResponse, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                if let data = Data {
                    do {
                        let decoder = JSONDecoder.init()
                        let messages = try decoder.decode([Message].self, from: data)
                        completion(.success(messages))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
    
    func getUser(completion: @escaping (_ result: Result<User, Error>)->Void, userId: String) {
        if let baseUrl = URL(string: baseUrl) {
            let url = baseUrl.appendingPathComponent("users").appendingPathComponent(userId)
            let session = URLSession.shared
            session.dataTask(with: url) {
                (Data, URLResponse, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                if let data = Data {
                    do {
                        let decoder = JSONDecoder.init()
                        let user = try decoder.decode(User.self, from: data)
                        completion(.success(user))
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func geAllUsers(completion: @escaping (_ result: Result<[User], Error>)->Void, typeOfUser: String = "") {
        if let baseUrl = URL(string: baseUrl) {
            var url = baseUrl.appendingPathComponent("users")
            if typeOfUser != "" {
                url.appendPathComponent(typeOfUser)
            }
            let session = URLSession.shared
            session.dataTask(with: url) {
                (Data, URLResponse, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                if let data = Data {
                    do {
                        let decoder = JSONDecoder.init()
                        let users = try decoder.decode([User].self, from: data)
                        completion(.success(users))
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func getImage(completion: @escaping (_ result: Result<Data, Error>)->Void, stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) {
            (Data, URLResponse, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            if let data = Data {
                completion(.success(data))
            }
        }.resume()
    }
    
    func getVideoById(completion: @escaping (_ result: Result<Video, Error>)->Void, videoId: String) {
        if let baseUrl = URL(string: baseUrl) {
            var url = baseUrl.appendingPathComponent("videos")
            url.appendPathComponent(videoId)
            let session = URLSession.shared
            session.dataTask(with: url) {
                (Data, URLResponse, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                if let data = Data {
                    do {
                        let decoder = JSONDecoder.init()
                        let video = try decoder.decode(Video.self, from: data)
                        completion(.success(video))
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func getVideos(completion: @escaping (_ result: Result<[Video], Error>)->Void) {
        if let baseUrl = URL(string: baseUrl) {
            let url = baseUrl.appendingPathComponent("videos")
            let session = URLSession.shared
            session.dataTask(with: url) {
                (Data, URLResponse, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                if let data = Data {
                    do {
                        let decoder = JSONDecoder.init()
                        let videos = try decoder.decode([Video].self, from: data)
                        completion(.success(videos))
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
 
