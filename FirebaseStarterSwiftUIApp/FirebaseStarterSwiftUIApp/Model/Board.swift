import Foundation
import FirebaseFirestoreSwift
import FirebaseCore
import FirebaseFirestore


var mockPosts: [PostDTO] = [
    PostDTO(id: "1", postedBy: "User1", postedUser: "User1", title: "Title 1", content: "Content 1",
         comments: [Comment(id: "1", commentedBy: "User2", commentedUser: "User1", content: "Comment 1", timestamp: Date())],
         timestamp: Date(),
            likes: [Like(id: "1", likedBy: "User1", likedUser: "User1", timestamp: Date()), Like(id: "2", likedBy: "User2", likedUser: "User2", timestamp: Date())])
]


struct Board: Identifiable, Codable {
    static var collection_name: String = "boards"

    @DocumentID var id: String?
    var name: String
    var description: String
}

struct Post: Codable, Identifiable {
    static var collection_name: String = "posts"

    @DocumentID var id: String? //
    var postedBy: String
    var postedUser: String
    var title: String
    var content: String
    var boardId: String
    var timestamp: Date
    
    
    static func convertPostToPostDTO(post: Post) -> PostDTO {
        return PostDTO(
            id: post.id,
            postedBy: post.postedBy,
            postedUser: post.postedUser,
            title: post.title,
            content: post.content,
            comments: [], // 이 값을 채울 수 없습니다. 실제 데이터를 얻기 위해 Firestore에서 comments를 로드해야 합니다.
            timestamp: post.timestamp,
            likes: [] // 이 값을 채울 수 없습니다. 실제 데이터를 얻기 위해 Firestore에서 likes를 로드해야 합니다.
        )
    }
}


// Post에 comments, likes를 더한 형태이다.
struct PostDTO: Identifiable {
    @DocumentID var id: String?
    var postedBy: String
    var postedUser: String
    var title: String // Title of the post
    var content: String // content of the post
    
    var comments: [Comment]?
    var timestamp: Date
    var likes: [Like]?
}

struct Comment: Codable, Identifiable {
    static var collection_name: String = "comments"

    @DocumentID var id: String?
    var commentedBy: String
    var commentedUser: String
    var content: String
    var timestamp: Date // timestamp for comment creation
}

struct Like: Codable, Identifiable {
    static var collection_name: String = "likes"

    @DocumentID var id: String?
    var likedBy: String
    var likedUser: String
    var timestamp: Date // timestamp for comment creation
}
