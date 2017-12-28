//
//  BaseAPI.swift
//  Stax
//
//  Created by icbrahimc on 12/25/17.
//  Copyright © 2017 icbrahimc. All rights reserved.
//

import Firebase
import FirebaseFirestore
import UIKit

class BaseAPI: NSObject {
    static let sharedInstance = BaseAPI()
    var db: Firestore!
    
    override private init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    /* Get the top rated playlists with a certain limit */
    func getTopPlaylists(numPlaylists: Int) -> Query {
        let playlists = db.collection("playlists");
        return playlists.order(by: "rating", descending: true)
    }
    
    /* Create a new user */
    func createNewUser(_ id: String) {
        let data = [
            "id": id,
            "username": "",
            "favoritedPlaylists": [],
        ] as [String : Any]
        db.collection("users").document(id).setData(data)
    }
    
    /* Load the user info */
    func loadUserInfo(_ completion: (_ data: [String:Any]) -> ()) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion([:])
            return
        }
        
        let collection = db.collection("users").document(userID)
        collection.getDocument(completion: { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print(document?.data())
            }
        })
    }
}
