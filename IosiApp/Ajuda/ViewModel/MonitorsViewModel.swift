//
//  HelpViewModel.swift
//  IosiApp
//
//  Created by aluno001 on 15/03/21.
//

import UIKit


class MonitorsViewModel: NSObject {
    var monitors = [Monitor(photoUrl: "https://cdn4.buysellads.net/uu/1/72681/1600362731-MC_Carbon_Logo_260x200.png", name: "Monitor", id: 1), Monitor(photoUrl: "https://cdn4.buysellads.net/uu/1/72681/1600362731-MC_Carbon_Logo_260x200.png", name: "Monitor", id: 2), Monitor(photoUrl: "https://cdn4.buysellads.net/uu/1/72681/1600362731-MC_Carbon_Logo_260x200.png", name: "Monitor", id: 3), Monitor(photoUrl: "https://cdn4.buysellads.net/uu/1/72681/1600362731-MC_Carbon_Logo_260x200.png", name: "Monitor", id: 4)]
}

extension MonitorsViewModel:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monitors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monitorCell", for: indexPath) as? MonitorCollectionViewCell else { return UICollectionViewCell() }
        DispatchQueue.global(qos: .background) .async {
            guard let photoUrl = self.monitors[indexPath.item].photoUrl, let imageUrl = URL(string: photoUrl) else {
                return
            }
            do {
                let data = try Data(contentsOf: imageUrl)
                DispatchQueue.main.async {
                    cell.photo.image = UIImage(data: data)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        cell.name.text = monitors[indexPath.item].name
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 170)
    }
}
