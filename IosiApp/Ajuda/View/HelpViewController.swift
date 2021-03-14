//
//  HelpViewController.swift
//  IosiApp
//
//  Created by aluno001 on 10/03/21.
//

import UIKit

struct Monitor {
    var photo: UIImage
    var name: String
}

class HelpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var monitors = [Monitor(photo: #imageLiteral(resourceName: "person"), name: "Monitor"), Monitor(photo: #imageLiteral(resourceName: "person"), name: "Monitor"), Monitor(photo: #imageLiteral(resourceName: "person"), name: "Monitor"), Monitor(photo: #imageLiteral(resourceName: "person"), name: "Monitor")]
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monitors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monitorCell", for: indexPath) as? MonitorCollectionViewCell else { return UICollectionViewCell() }
        cell.photo.image = monitors[indexPath.item].photo
        cell.name.text = monitors[indexPath.item].name
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 170)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
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
