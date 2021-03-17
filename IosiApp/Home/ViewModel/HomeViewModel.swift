//
//  HomeViewModel.swift
//  IosiApp
//
//  Created by aluno001 on 14/03/21.
//

import UIKit

class HomeViewModel: NSObject {
    private let months = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
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
}
extension HomeViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 131, height: 106)
    }
    
}
