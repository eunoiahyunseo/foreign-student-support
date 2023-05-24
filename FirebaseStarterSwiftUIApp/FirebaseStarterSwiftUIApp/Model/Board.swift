import Foundation
import FirebaseFirestoreSwift
import FirebaseCore
import FirebaseFirestore


let mockPosts: [Post] = [
    Post(id: "1", postedBy: "User1", postedUser: "User1", title: "Title 1", content: "Content 1",
         comments: [Comment(id: "1", commentedBy: "User2", content: "Comment 1", timestamp: Date())],
         timestamp: Date(), likes: ["User3", "User4"]),
    Post(id: "2", postedBy: "User2", postedUser: "User2", title: "Title 2", content: "Content 2",
         comments: [Comment(id: "2", commentedBy: "User1", content: "Comment 2", timestamp: Date())],
         timestamp: Date(), likes: ["User1"]),

]

struct Post: Codable, Identifiable {
    static var collection_name: String = "posts"

    @DocumentID var id: String? //
    var postedBy: String
    var postedUser: String
    var title: String // Title of the post
    var content: String // content of the post
    
    var comments: [Comment]?
    var timestamp: Date
    var likes: [String] = []
    
}


struct Comment: Codable, Identifiable {
    static var collection_name: String = "comments"

    @DocumentID var id: String?
    var commentedBy: String
    var content: String
    var timestamp: Date // timestamp for comment creation
}

struct Like: Codable, Identifiable {
    static var collection_name: String = "likes"

    @DocumentID var id: String?
    var likedBy: String
}
