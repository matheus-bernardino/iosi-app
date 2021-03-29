//
//  HomeViewModel.swift
//  IosiApp
//
//  Created by aluno001 on 14/03/21.
//

import UIKit

protocol HomeViewModelDelegate: class {
    func updateNextVideoTitle(title: String)
    func updateNextVideoImage(image: Data)
    
    func updateVideoClasses()
}

class HomeViewModel: NSObject {
    weak var delegate: HomeViewModelDelegate?
    private let months = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
    private var videos: [Video] = []
    private var videoImages: [String: Data] = [:]
    private var numberOfPhotoRet = 0
    
    func setCurrentDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let requestComponents : Set<Calendar.Component> = [
            .year,
            .month,
            .day
        ]
        
        let dateComponents = calendar.dateComponents(requestComponents, from: date)
        var dateString = ""
        if let day = dateComponents.day, let month = dateComponents.month, let year = dateComponents.year {
            let realMonth = months[month - 1]
            dateString = "\(day)  de \(realMonth) de \(year)"
        }
        
        return dateString
    }
    
    func getNextVideo() {
        Repository.apiAcssess.getVideoById(completion: { result in
            switch result {
            case .success(let video):
                if let url = video.imageURL {
                    self.getNextVideoImage(url: url)
                }
                DispatchQueue.main.async {
                    self.delegate?.updateNextVideoTitle(title: video.title ?? "")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }, videoId: "605111e3977f59b9e2b4949e")
    }
    
    func getNextVideoImage(url: String) {
        Repository.apiAcssess.getImage(completion: { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.delegate?.updateNextVideoImage(image: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }, stringUrl: url)
        
    }
    
    func getAllVideos() {
        Repository.apiAcssess.getVideos(completion: { result in
            switch result {
            case .success(let videos):
                self.videos = videos
                self.getAllVideoImages()
                DispatchQueue.main.async {
                    self.delegate?.updateVideoClasses()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getAllVideoImages () {
        for video in videos {
            if let url = video.imageURL, let id = video._id {
                Repository.apiAcssess.getImage(completion: { result in
                    self.numberOfPhotoRet += 1
                    switch result {
                    case .success(let data):
                        self.videoImages[id] = data
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    if (self.numberOfPhotoRet == self.videos.count) {
                        self.numberOfPhotoRet = 0
                        DispatchQueue.main.async {
                            if let delegate = self.delegate {
                                delegate.updateVideoClasses()
                            }
                        }
                    }
                }, stringUrl: url)
            }
        }
    }
    
}

extension HomeViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as? ClassTableViewCell else { return UITableViewCell() }
        cell.className.text = videos[indexPath.item].title
        if let videoId = videos[indexPath.item]._id, let image = videoImages[videoId] {
            cell.classImage.image = UIImage(data: image)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
        
    }
}
