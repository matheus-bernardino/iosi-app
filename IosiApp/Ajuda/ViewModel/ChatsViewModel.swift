//
//  ChatsViewModel.swift
//  IosiApp
//
//  Created by aluno001 on 15/03/21.
//

import UIKit

class ChatsViewModel: NSObject {
    private var messages: [Message]?
    private var chats:[Chat]?
    override init() {
        messages = [Message(text: "Ola", author: "Pessoa 1", dateTime: ""), Message(text: "Oi", author: "Pessoa 2", dateTime: "")]
        chats = [Chat(messages: messages, monitorId: "1"), Chat(messages: messages, monitorId: "2"), Chat(messages: messages, monitorId: "3"), Chat(messages: messages, monitorId: "4"), Chat(messages: messages, monitorId: "5")]
    }
}

extension ChatsViewModel:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = chats?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as? ChatsCollectionViewCell, let chatsUnwrapped = chats  else { return UICollectionViewCell() }
//        DispatchQueue.global(qos: .background) .async {
//            guard let photoUrl = self.chats[indexPath.item].photoUrl, let imageUrl = URL(string: photoUrl) else {
//                return
//            }
//            do {
//                let data = try Data(contentsOf: imageUrl)
//                DispatchQueue.main.async {
//                    cell.photo.image = UIImage(data: data)
//                }
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        }
        cell.name.text = chatsUnwrapped[indexPath.item].monitorId
        if let messages = chatsUnwrapped[indexPath.item].messages {
            if let author = messages[messages.count - 1].author, let message = messages[messages.count - 1].text {
                cell.lastMessages.text = "\(author): \(message)"
            }
//            var allMessages = [String]()
//            for message in messages {
//                allMessages.append(message.text ?? "")
//            }
//            cell.lastMessages.text = allMessages.joined(separator: "\n")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 388, height: 76)
    }
}
