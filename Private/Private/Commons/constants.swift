//
//  constants.swift
//  Private
//
//  Created by 박범수 on 10/17/23.
//

import Firebase

let userCollection = Firestore.firestore().collection("User")
let followerCollection = Firestore.firestore().collection("followers")
let followingCollection = Firestore.firestore().collection("following")
let notificationCollection = Firestore.firestore().collection("notifications")
let postCollection = Firestore.firestore().collection("posts")
let dbRef = Firestore.firestore().collection("Feed")
