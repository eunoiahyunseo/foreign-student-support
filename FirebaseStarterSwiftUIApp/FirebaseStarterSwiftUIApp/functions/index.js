/** @format */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.calculateTopPosts = functions
  .region("asia-northeast3")
  .pubsub.schedule("every 1 minutes") // 1분마다 스케줄링 한다.
  .onRun(async (context) => {
    const postsSnapshot = await admin
      .firestore()
      .collection("posts")
      .get();

    let posts = [];
    for (let postDoc of postsSnapshot.docs) {
      let post = postDoc.data();
      post.id = postDoc.id;

      // Fetch likes and comments for the post from the sub-collections
      const likesSnapshot = await admin
        .firestore()
        .collection("posts")
        .doc(post.id)
        .collection("likes")
        .get();

      const commentsSnapshot = await admin
        .firestore()
        .collection("posts")
        .doc(post.id)
        .collection("comments")
        .get();

      const userSnapshot = await admin
        .firestore()
        .collection("users")
        .doc(post.postedBy)
        .get();

      post.user = userSnapshot.data();

      // likes를 가져올 때 user정보도 조회해서 삽입해야 한다.
      let likesDTO = [];
      for (let likeDoc of likesSnapshot.docs) {
        let like = likeDoc.data();

        // Fetch user info for the like
        const userSnapshot = await admin
          .firestore()
          .collection("users")
          .doc(like.likedBy)
          .get();

        let likeDTO = like;
        likeDTO.user = userSnapshot.data();
        likesDTO.push(likeDTO);
      }

      post.likes = likesDTO;

      let commentsDTO = [];
      for (let commentDoc of commentsSnapshot.docs) {
        let comment = commentDoc.data();
        const userSnapshot = await admin
          .firestore()
          .collection("users")
          .doc(comment.commentedBy)
          .get();
        let commentDTO = comment;
        commentDTO.user = userSnapshot.data();
        commentsDTO.push(commentDTO);
      }

      post.comments = commentsDTO;

      let score =
        (post.likes.length || 0) * 1.4 +
        (post.comments.length || 0) * 0.8; // (좋아요 수 + 댓글의 수)로 일단 점수 계산

      const oneDay = 24 * 60 * 60 * 1000;
      let ageInDays = Math.floor(
        (new Date().getTime() -
          post.timestamp.toDate().getTime()) /
          oneDay
      );
      let freshnessBonus = Math.max(0, 14 - ageInDays); // 게시물이 작성된 지 14일 이내일 경우, 하루마다 1점의 보너스 점수를 부여

      post.score = score + freshnessBonus;

      // 좋아요, comment다 담겨있을 것임
      posts.push(post);
    }

    // 점수에 따라 정렬한다.
    posts.sort((a, b) => b.score - a.score);

    // 가장 점수가 높은 2개만 slice해온다.
    let topPosts = posts.slice(0, 2);

    // firebase cloudstore의 topPosts에 계산한 결과를 저장한다.
    for (let i = 0; i < topPosts.length; i++) {
      await admin
        .firestore()
        .collection("topPosts")
        .doc(topPosts[i].id)
        .set(topPosts[i]);
    }

    console.log("Top posts calculated.");
  });

exports.getTopPosts = functions
  .region("asia-northeast3")
  .https.onRequest(async (req, res) => {
    try {
      const topPostsSnapshot = await admin
        .firestore()
        .collection("topPosts")
        .doc("topPosts")
        .get();

      if (!topPostsSnapshot.exists) {
        throw new Error("Top posts not found");
      }

      const topPostsData = topPostsSnapshot.data();
      const topPosts = topPostsData.topPosts;

      res.status(200).json({ topPosts });
    } catch (error) {
      console.error("Error fetching top posts:", error);
      res
        .status(500)
        .json({ error: "Failed to fetch top posts" });
    }
  });
