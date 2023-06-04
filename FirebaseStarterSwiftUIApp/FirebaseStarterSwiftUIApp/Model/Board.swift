import Foundation
import FirebaseFirestoreSwift
import FirebaseCore
import FirebaseFirestore



var mockPosts: [PostDTO] = [
    PostDTO(
        id: "1",
        postedBy: "User1",
        title: "Title 1",
        content: "Content 1",
        board: Board(
            id: "1",
            name: "영어권 게시판",
            description: "영어권 게시판입니다."),
        boardId: "1",
        timestamp: Date(),
        comments: [
            CommentDTO(id: "1",
                    commentedBy: "User2",
                    content: "Comment 1",
                    timestamp: Date())
        ],
        likes: [
            LikeDTO(
                id: "1",
                likedBy: "User1",
                timestamp: Date()),
            LikeDTO(
                id: "2",
                likedBy: "User2",
                timestamp: Date())
        ]
    )
]


struct Board: Identifiable, Codable {
    static var collection_name: String = "boards"
    @DocumentID var id: String?
    var name: String
    var description: String
}

// 기본 Post에 그냥 boardId말고 Board객체를 그냥 집어 넣어버리자
// 불필요한 쿼리들이 너무 많이 생성된다.
struct Post: Codable, Identifiable {
    static var collection_name: String = "posts"

    @DocumentID var id: String?
    var postedBy: String // 이를 통해 User fetch
    var title: String
    var content: String
    var board: Board
    var boardId: String
    var timestamp: Date
    
    static func convertPostToPostDTO(post: Post) -> PostDTO {
        return PostDTO(
            id: post.id,
            postedBy: post.postedBy,
            title: post.title,
            content: post.content,
            board: post.board,
            boardId: post.boardId,
            timestamp: post.timestamp,
            comments: [],
            likes: []
        )
    }
}


// Post에 comments, likes를 더한 형태이다. + board
struct PostDTO: Identifiable, Codable {
    @DocumentID var id: String?
    var postedBy: String
    var title: String // Title of the post
    var content: String // content of the post
    var board: Board
    var boardId: String
    var timestamp: Date
    
    var comments: [CommentDTO]?
    var likes: [LikeDTO]?
    var user: User?
        
    // 실시간 인기글 구현을 위해 PostDTO에 점수 필드를 추가함
    var score: Double = 0.0
}


struct Comment: Codable, Identifiable {
    static var collection_name: String = "comments"

    @DocumentID var id: String?
    var commentedBy: String
    var content: String
    var timestamp: Date
    
    static func convertCommentToCommentDTO(comment: Comment) -> CommentDTO {
        return CommentDTO(
            id: comment.id,
            commentedBy: comment.commentedBy,
            content: comment.content,
            timestamp: comment.timestamp
        )
    }
}

struct CommentDTO: Identifiable, Codable {
    @DocumentID var id: String?
    
    var commentedBy: String
    var content: String
    var timestamp: Date
    
    var user: User?
}


struct Like: Codable, Identifiable {
    static var collection_name: String = "likes"

    @DocumentID var id: String?
    var likedBy: String
    var timestamp: Date
    
    static func convertLikeToLikeDTO(like: Like) -> LikeDTO {
        return LikeDTO(
            id: like.id,
            likedBy: like.likedBy,
            timestamp: like.timestamp
        )
    }
}

struct LikeDTO: Identifiable, Codable {
    @DocumentID var id: String?

    var likedBy: String
    var timestamp: Date
    
    var user: User?
}
