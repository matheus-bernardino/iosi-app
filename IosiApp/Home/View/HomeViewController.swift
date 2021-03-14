//
//  HomeViewController.swift
//  IosiApp
//
//  Created by aluno001 on 09/03/21.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var perfilPhoto: UIImageView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 131, height: 106)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentDate()
        perfilPhotoSetup()
        // Do any additional setup after loading the view.
    }
    
    func perfilPhotoSetup() {
        perfilPhoto.layer.cornerRadius = perfilPhoto.frame.height / 2
    }
    
    func setCurrentDate() {
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
            let realMonth = getMonth(monthNumber: month)
            dateString = "\(day)  de \(realMonth) de \(year)"
        }
        
        dateLabel.text = dateString
    }

    func getMonth(monthNumber: Int) -> String {
        switch monthNumber {
        case 1:
            return "Janeiro"
        case 2:
            return "Fevereiro"
        case 3:
            return "Março"
        case 4:
            return "Abril"
        case 5:
            return "Maio"
        case 6:
            return "Junho"
        case 7:
            return "Julho"
        case 8:
            return "Agosto"
        case 9:
            return "Setembro"
        case 10:
            return "Outubro"
        case 11:
            return "Novembro"
        case 12:
            return "Dezembro"
        default:
            return ""
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
