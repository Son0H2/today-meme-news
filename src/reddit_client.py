import praw
from datetime import datetime, timezone
from typing import List, Dict, Any
from .config import REDDIT_CONFIG, SUBREDDITS, COLLECTION_SETTINGS

class RedditClient:
    def __init__(self):
        self.reddit = praw.Reddit(
            client_id=REDDIT_CONFIG['client_id'],
            client_secret=REDDIT_CONFIG['client_secret'],
            user_agent=REDDIT_CONFIG['user_agent']
        )
    
    def get_hot_posts(self, subreddit_name: str) -> List[Dict[str, Any]]:
        """특정 서브레딧의 인기 게시물을 가져옵니다."""
        subreddit = self.reddit.subreddit(subreddit_name)
        posts = []
        
        for post in subreddit.hot(limit=COLLECTION_SETTINGS['posts_limit']):
            post_data = {
                'id': post.id,
                'title': post.title,
                'text': post.selftext,
                'score': post.score,
                'upvote_ratio': post.upvote_ratio,
                'num_comments': post.num_comments,
                'created_utc': datetime.fromtimestamp(post.created_utc, tz=timezone.utc),
                'url': post.url,
                'permalink': post.permalink,
                'subreddit': subreddit_name
            }
            posts.append(post_data)
        
        return posts
    
    def get_post_comments(self, post_id: str, subreddit_name: str) -> List[Dict[str, Any]]:
        """특정 게시물의 댓글을 가져옵니다."""
        submission = self.reddit.submission(id=post_id)
        submission.comments.replace_more(limit=0)  # MoreComments 객체 제거
        comments = []
        
        for comment in submission.comments.list()[:COLLECTION_SETTINGS['comments_limit']]:
            comment_data = {
                'id': comment.id,
                'body': comment.body,
                'score': comment.score,
                'created_utc': datetime.fromtimestamp(comment.created_utc, tz=timezone.utc),
                'post_id': post_id,
                'subreddit': subreddit_name
            }
            comments.append(comment_data)
        
        return comments
    
    def collect_all_data(self) -> Dict[str, List[Dict[str, Any]]]:
        """모든 서브레딧에서 데이터를 수집합니다."""
        all_data = {}
        
        for subreddit in SUBREDDITS:
            try:
                posts = self.get_hot_posts(subreddit)
                all_data[subreddit] = {
                    'posts': posts,
                    'comments': []
                }
                
                # 각 게시물의 댓글 수집
                for post in posts:
                    comments = self.get_post_comments(post['id'], subreddit)
                    all_data[subreddit]['comments'].extend(comments)
                    
            except Exception as e:
                print(f"Error collecting data from r/{subreddit}: {str(e)}")
                continue
        
        return all_data 