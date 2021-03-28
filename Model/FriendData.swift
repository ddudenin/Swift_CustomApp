//
//  FriendData.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import Foundation
import RealmSwift

class FriendsJSONData: Codable {
    let response: FriendsResponse
}

class FriendsResponse: Codable {
    let count: Int
    let items: [FriendItem]
}

class FriendItem: Object, Codable {
    @objc dynamic var firstName: String
    @objc dynamic var id: Int
    @objc dynamic var lastName: String
    @objc dynamic var canAccessClosed: Bool
    @objc dynamic var isClosed: Bool
    @objc dynamic var photo200_Orig: String
    @objc dynamic var trackCode: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
        case photo200_Orig = "photo_200_orig"
        case trackCode = "track_code"
    }
    
    func getFullName() -> String {
        return firstName + " " + lastName
    }
}

var friendsArray: [FriendItem] = []
