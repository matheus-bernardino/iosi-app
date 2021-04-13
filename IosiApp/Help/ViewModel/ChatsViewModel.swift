//
//  ChatsViewModel.swift
//  IosiApp
//
//  Created by aluno001 on 15/03/21.
//

import UIKit

protocol ChatsViewModelDelegate: class {
    func updateMessages()
}

class ChatsViewModel: NSObject {
    weak var delegate: ChatsViewModelDelegate?
    private var chats: [Chat]?
    private var messages: [String: [Message]] = [:]
    private var users: [String: User] = [:]
    private var photos: [String: Data] = [:]
    private var numberOfNameRet = 0
    private var numberOfPhotoRet = 0
    private var numberOfMessRet = 0
    
    func getAllChatsFromUser() {
        Repository.apiAcssess.getAllChatsFromUser(completion: { result in
            switch result {
            case .success(let chats):
                self.chats = chats
                self.getAllMessages()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getAllMessages() {
        guard let actualChats = chats else { return }
        for chat in actualChats {
            if let id = chat._id {
                Repository.apiAcssess.getAllMessages(completion: { result in
                    self.numberOfMessRet += 1
                    switch result {
                    case .success(let messagesReceived):
                        self.messages[id] = messagesReceived
                        self.getAllChatUsersNames(chatId: id)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    if (self.numberOfMessRet == self.chats?.count) {
                        self.numberOfMessRet = 0
                        DispatchQueue.main.async {
                            if let delegate = self.delegate {
                                delegate.updateMessages()
                            }
                        }
                    }
                }, key: id)
            }
        }
    }
    
    func getAllChatUsersNames(chatId: String) {
        guard let actualMesages = messages[chatId] else { return }
        for message in actualMesages {
            if let id = message.author {
                Repository.apiAcssess.getUser(completion: { result in
                    self.numberOfNameRet += 1
                    switch result {
                    case .success(let user):
                        self.users[id] = user
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    if (self.numberOfNameRet == self.chats?.count) {
                        self.numberOfNameRet = 0
                        self.getAllChatUsersPhotos()
                        DispatchQueue.main.async {
                            if let delegate = self.delegate {
                                delegate.updateMessages()
                            }
                        }
                    }
                }, userId: id)
            }
        }
    }
    
    func getAllChatUsersPhotos () {
        for user in users {
            if let url = user.value.profilePictureURL {
                let id = user.key
                Repository.apiAcssess.getImage(completion: { result in
                    self.numberOfPhotoRet += 1
                    switch result {
                    case .success(let data):
                        self.photos[id] = data
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    if (self.numberOfPhotoRet == self.chats?.count) {
                        self.numberOfPhotoRet = 0
                        DispatchQueue.main.async {
                            if let delegate = self.delegate {
                                delegate.updateMessages()
                            }
                        }
                    }
                }, stringUrl: url)
            }
        }
    }
}

extension ChatsViewModel:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let chats = chats?.count else {
            return 0
        }
        return chats
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as? ChatsCollectionViewCell, let chatsUnwrapped = chats  else { return UICollectionViewCell() }
        
        if let id = chatsUnwrapped[indexPath.item]._id, let messages = messages[id], let professorId = chatsUnwrapped[indexPath.item].professorId, let professorName = users[professorId]?.name {
            cell.name.text = professorName
            if messages.count >= 1 {
                if let lastMessageAuthor = messages[messages.count - 1].author, let lastMessage = messages[messages.count - 1].message {                    cell.lastMessages.text = "\(lastMessageAuthor): \(lastMessage)"
                }
                
                if let isoDate = messages[messages.count - 1].dateTime {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    if let date = dateFormatter.date(from:isoDate) {
                        
                        let calendar = Calendar.current
                        let requestComponents : Set<Calendar.Component> = [
                            .year,
                            .month,
                            .day,
                            .hour,
                            .minute
                        ]

                        let dateComponents = calendar.dateComponents(requestComponents, from: date)
                        var dateString = ""
                        if let day = dateComponents.day, let month = dateComponents.month, let year = dateComponents.year, let hour = dateComponents.hour, let minutes = dateComponents.minute {
                            dateString = "\(day)\\\(month)\\\(year) \(hour):\(minutes)"
                        }

                        cell.timeOfLastMessage.text = dateString
                    }
                }
            }
        }
        
//        if let isoDate = chatsUnwrapped[indexPath.item].dateTime {
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//            if let date = dateFormatter.date(from:isoDate) {
//
//                let calendar = Calendar.current
//                let requestComponents : Set<Calendar.Component> = [
//                    .year,
//                    .month,
//                    .day,
//                    .hour,
//                    .minute
//                ]
//
//                let dateComponents = calendar.dateComponents(requestComponents, from: date)
//                var dateString = ""
//                if let day = dateComponents.day, let month = dateComponents.month, let year = dateComponents.year, let hour = dateComponents.hour, let minutes = dateComponents.minute {
//                    dateString = "\(day)\\\(month)\\\(year) \(hour):\(minutes)"
//                }
//
//                cell.timeOfLastMessage.text = dateString
//            }
//        }
        
        if let id = chatsUnwrapped[indexPath.item].professorId, let photo = photos[id] {
            cell.photo.image = UIImage(data: photo)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 388, height: 76)
    }
}
