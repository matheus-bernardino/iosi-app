//
//  HelpViewModel.swift
//  IosiApp
//
//  Created by aluno001 on 15/03/21.
//

import UIKit

protocol MonitorsViewModelDelegate: class {
    func updateMonitors()
}

class MonitorsViewModel: NSObject {
    weak var delegate: MonitorsViewModelDelegate?
    private var professors: [User] = []
    private var photos: [String: Data] = [:]
    private var numberOfPhotoRet = 0
    
    func getAllProfessors() {
       Repository.apiAcssess.geAllUsers(completion: { result in
            switch result {
            case .success(let users):
                self.professors = users
                    
                self.getAllProfessorsPhotos()
                DispatchQueue.main.async {
                    if let delegate = self.delegate {
                        delegate.updateMonitors()
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
       }, typeOfUser: "professors")
    }
    
    func getAllProfessorsPhotos () {
        for professor in professors {
            if let url = professor.profilePictureURL, let id = professor._id {
                Repository.apiAcssess.getImage(completion: { result in
                    self.numberOfPhotoRet += 1
                    switch result {
                    case .success(let data):
                        self.photos[id] = data
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    if (self.numberOfPhotoRet == self.professors.count) {
                        self.numberOfPhotoRet = 0
                        DispatchQueue.main.async {
                            if let delegate = self.delegate {
                                delegate.updateMonitors()
                            }
                        }
                    }
                }, stringUrl: url)
            }
        }
    }
}

extension MonitorsViewModel:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return professors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monitorCell", for: indexPath) as? MonitorCollectionViewCell else { return UICollectionViewCell() }
        cell.name.text = professors[indexPath.item].name
        if let professorId = professors[indexPath.item]._id, let photo = photos[professorId] {
            cell.photo.image = UIImage(data: photo)
        }
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 170)
    }
}
