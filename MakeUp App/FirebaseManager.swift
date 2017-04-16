//
//  FirebaseManager.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/10/17.
//  Copyright © 2017 Benjamin Bernstein. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    var ref = FIRDatabase.database().reference()
    
    var currentUser: FIRUser?
    
    var currentUserNode: FIRDatabaseReference {
        return ref.child("Users")
    }
    
    private init() {}
    
    static private let ref = FIRDatabase.database().reference()
    
    /// User Functions ///
    
    func loadUser(_ userID: String, completion: @escaping () -> ()) {
        _ = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            self.currentUser = user
            completion()
        })
    }
    func createOrUpdate(_ user: FIRUser) {
        let name = user.displayName ?? "No name"
        currentUserNode.child(user.uid).updateChildValues(["name": name])
        currentUser = user
    }
    
//    func createUserWithEmailAndPassword(email: String, password: String) {
//        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
//            currentUserNode.child(user.ui)
//        })
//    }
    
//    func signInUserWithEmailAndPassword(email: String, password: String) {
//            FIRAuth.auth()?.signIn(withEmail: email, password: String, completion: { (user, error) in
//                <#code#>
//            })
//    }
    
//    }
    
    /// App Functions //
    
    func toggleProductFavorite(_ product: Product) {
        guard let user = currentUser else { print("no user"); return }
        let productID = product.upc
        let productRecord = currentUserNode.child(user.uid).child("favorites").child("products")
        
        
            productRecord.observeSingleEvent(of: .value, with: { (snapshot) in
                if let favoriteRecord = snapshot.value as? [String:Any] {
                    if favoriteRecord[productID] as? Bool == false {
                        productRecord.updateChildValues([productID: true])
                        print("User added favorite")
                    } else  {
                        productRecord.updateChildValues([productID: false])
                        print("User removed favorite")
                    }
                } else {
                    productRecord.updateChildValues([productID: true])
                }
           
        })
    }
    
    func toggleMediaFavorite(_ youtube: Youtube) {
        guard let user = currentUser else { print("no user"); return }
        let mediaRecord = currentUserNode.child(user.uid).child("favorites").child("media")
        let videoID = youtube.videoID
        mediaRecord.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let favoriteRecord = snapshot.value as? [String:Any] else { mediaRecord.updateChildValues([videoID: true]); return }
            favoriteRecord.keys.forEach {_ in
                if favoriteRecord[videoID] as? Bool == true {
                    mediaRecord.updateChildValues([videoID: false])
                } else {
                    mediaRecord.updateChildValues([videoID: true])
                }
            }
        })
    }
    
    func fetchUserProducts(completion: @escaping ([Product]) -> Void) {
        guard let user = currentUser else { print("no user"); return }
        let userFavorites = currentUserNode.child(user.uid).child("favorites").child("products")
        userFavorites.observe(.value, with: { (snapshot) in
            guard let favoriteRecord = snapshot.value as? [String:Any] else { print("the user has no favorites"); return }
            var idsToRetrieve = [String]()
            for key in favoriteRecord.keys {
                if favoriteRecord[key] as? Bool == true {
                    idsToRetrieve.append(key)
                }
            }
            var products = [Product]()
            idsToRetrieve.forEach({ (id) in
                self.ref.child("Products").child(id).observe(.value, with: { (snapshot) in
                    guard let dict = snapshot.value as? [String:Any] else { print("no dict snapshot"); return }
                    let newproduct = Product(dict: dict)
                    products.append(newproduct)
                    completion(products)
                })
            })
            // get here if there are no products...
            completion(products)
        })
    }
    
    func fetchUserMedia(completion: @escaping ([Youtube]) -> Void) {
        guard let user = currentUser else { print("no user"); return }
        let userMedia = currentUserNode.child(user.uid).child("favorites").child("media")
        userMedia.observe(.value, with: { (snapshot) in
            guard let favoriteRecord = snapshot.value as? [String:Any] else { print("the user has no media favorites"); return }
            var idsToRetrieve = [String]()
            for key in favoriteRecord.keys {
                if favoriteRecord[key] as? Bool == true {
                    idsToRetrieve.append(key)
                }
            }
            var youtubes = [Youtube]()
            var i = 0
            if idsToRetrieve.count == 0 {
                completion(youtubes)
            }
            idsToRetrieve.forEach({ (id) in
                YoutubeAPIClient.getSingleYoutubeVideo(id: id, completion: { (video) in
                    youtubes.append(video)
                    i += 1
                    if i == idsToRetrieve.count {
                        completion(youtubes)
                    }
                })
            })
            
            
        })
    }
}
