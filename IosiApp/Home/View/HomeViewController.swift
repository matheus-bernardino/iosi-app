//
//  HomeViewController.swift
//  IosiApp
//
//  Created by aluno001 on 09/03/21.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var perfilPhoto: UIImageView!
    @IBOutlet weak var nextVideoImage: UIImageView!
    @IBOutlet weak var nextVideoLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private let homeViewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = homeViewModel
        collectionView.dataSource = homeViewModel

        dateLabel.text = homeViewModel.setCurrentDate()
        perfilPhotoSetup()
        homeViewModel.delegate = self
        homeViewModel.getNextVideo()
        homeViewModel.getAllVideos()
        // Do any additional setup after loading the view.
    }
    
    func perfilPhotoSetup() {
        perfilPhoto.layer.cornerRadius = perfilPhoto.frame.height / 2
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

extension HomeViewController: HomeViewModelDelegate  {
    func updateVideoClasses() {
        collectionView.reloadData()
    }
    
    func updateNextVideoTitle(title: String) {
        nextVideoLabel.text = title
    }
    
    func updateNextVideoImage(image: Data) {
        nextVideoImage.image = UIImage(data: image)
    }
}
