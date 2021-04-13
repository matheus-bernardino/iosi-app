//
//  HelpViewController.swift
//  IosiApp
//
//  Created by aluno001 on 10/03/21.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chatsCollectionView: UICollectionView!
    var monitorsViewModel = MonitorsViewModel()
    var chatsViewModel = ChatsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = monitorsViewModel
        collectionView.dataSource = monitorsViewModel
        chatsCollectionView.delegate = chatsViewModel
        chatsCollectionView.dataSource = chatsViewModel
        chatsViewModel.delegate = self
        chatsViewModel.getAllChatsFromUser()
        monitorsViewModel.delegate = self
        monitorsViewModel.getAllProfessors()
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

extension HelpViewController: ChatsViewModelDelegate, MonitorsViewModelDelegate {
    func updateMonitors() {
        collectionView.reloadData()
    }
    
    func updateMessages() {
        chatsCollectionView.reloadData()
    }
}
