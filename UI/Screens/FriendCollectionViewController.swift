//
//  AvatarCollectionViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import RealmSwift

class FriendCollectionViewController: UICollectionViewController {
    
    var friend: User?

    private var photos: Results<Photo>? {
        get {
            guard let friend = self.friend else { return nil }

            let photos: Results<Photo>? = realmManager?.getObjects()
            return photos?.filter("ownerID = %@", friend.id)
        }
        
        set { }
    }
    
    private let networkManager = NetworkManager.instance
    private let realmManager = RealmManager.instance
    private var notificationToken: NotificationToken?
    
    private func loadData() {
        guard let friend = self.friend else { return }

        networkManager.loadPhotos(userId: friend.id) { [weak self] items in
            DispatchQueue.main.async {
                try? self?.realmManager?.add(objects: items)
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func signToPhotosChanges() {
        notificationToken = self.photos?.observe { [weak self] (change) in
            switch change {
            case .initial(let photos):
                #if DEBUG
                print("Initialized \(photos.count)")
                #endif
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):

                let deletionsIndexPaths = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPaths = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPaths = modifications.map { IndexPath(row: $0, section: 0) }
                
                #if DEBUG
                print(deletions, insertions, modifications)
                #endif
                
                self?.collectionView.performBatchUpdates {
                    self?.collectionView.deleteItems(at: deletionsIndexPaths)
                    self?.collectionView.insertItems(at: insertionsIndexPaths)
                    self?.collectionView.reloadItems(at: modificationsIndexPaths)
                }
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "FriendCollectionViewCell", bundle: .none), forCellWithReuseIdentifier: "AvatarCell")
        
        // Do any additional setup after loading the view.
        guard let friend = self.friend else { return }
        self.title = friend.getFullName()
        
        signToPhotosChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userPhoto = self.photos, userPhoto.isEmpty {
                loadData()
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! FriendCollectionViewCell
        
        // Configure the cell
        guard let photo = self.photos?[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.configure(withPhoto: photo)
 
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendPhotosCollectionView")
        (vc as? FriendsPhotosCollectionViewController)?.photos = self.photos
        self.navigationController?.pushViewController(vc, animated: true)
    }
}