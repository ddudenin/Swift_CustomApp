//
//  FriendPhotoCollectionViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import SDWebImage

final class FriendPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var likeControl: LikeControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withPhoto photo: Photo, handler handle: ((Bool, Int) -> Void)? = nil) {
        if let likeInfo = photo.likes {
            self.likeControl.configure(withLikes: likeInfo, handler: handle)
        } else {
            self.likeControl.configure(withLikesCount: 0, state: false)
        }
        
        guard let urlString = photo.sizes.last?.url else { return }
        self.photoImageView.sd_setImage(with: URL(string: urlString))
    }
}
