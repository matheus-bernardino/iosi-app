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
    private var messages: [Message]?
    private var users: [String: User] = [:]
    private var photos: [String: Data] = [:]
    private var numberOfNameRet = 0
    private var numberOfPhotoRet = 0
    
    func getAllMessages() {
        Repository.apiAcssess.getAllMessages(completion: { result in
            switch result {
            case .success(let messagesReceived):
                self.messages = messagesReceived
                self.getAllChatUsersNames()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getAllChatUsersNames() {
        guard let actualMessages = messages else { return }
        for message in actualMessages {
            if let id = message.author {
                Repository.apiAcssess.getUser(completion: { result in
                    self.numberOfNameRet += 1
                    switch result {
                    case .success(let user):
                        self.users[id] = user
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    if (self.numberOfNameRet == self.messages?.count) {
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
                    if (self.numberOfPhotoRet == self.messages?.count) {
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
        guard let messages = messages?.count else {
            return 0
        }
        return messages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as? ChatsCollectionViewCell, let messagesUnwrapped = messages  else { return UICollectionViewCell() }
        
        if let id = messagesUnwrapped[indexPath.item].author, let user = users[id], let userName = user.name, let message = messagesUnwrapped[indexPath.item].message {
            cell.name.text = userName
            cell.lastMessages.text = "\(userName): \(message)"
        }
        
        if let isoDate = messagesUnwrapped[indexPath.item].dateTime {
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
        
        if let id = messagesUnwrapped[indexPath.item].author, let photo = photos[id] {
            cell.photo.image = UIImage(data: photo)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 388, height: 76)
    }
}
