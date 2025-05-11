from google.cloud import firestore
from datetime import datetime, timezone
from typing import Dict, Any, List
from .config import FIREBASE_CONFIG

class FirebaseClient:
    def __init__(self):
        self.db = firestore.Client(
            project=FIREBASE_CONFIG['project_id'],
            database=FIREBASE_CONFIG['database_url']
        )
    
    def _get_collection_ref(self, collection_name: str):
        """컬렉션 레퍼런스를 가져옵니다."""
        return self.db.collection(collection_name)
    
    def _get_doc_ref(self, collection_name: str, doc_id: str):
        """문서 레퍼런스를 가져옵니다."""
        return self._get_collection_ref(collection_name).document(doc_id)
    
    def save_ticker_analysis(self, ticker: str, analysis: Dict[str, Any]) -> None:
        """티커 분석 결과를 저장합니다."""
        doc_ref = self._get_doc_ref('ticker_analyses', ticker)
        doc_ref.set(analysis, merge=True)
    
    def save_ticker_quotes(self, quotes: List[Dict[str, Any]]) -> None:
        """여러 티커의 시세 정보를 저장합니다."""
        batch = self.db.batch()
        for quote in quotes:
            doc_ref = self._get_doc_ref('ticker_quotes', quote['symbol'])
            batch.set(doc_ref, quote, merge=True)
        batch.commit()
    
    def save_reddit_data(self, subreddit: str, data: Dict[str, List[Dict[str, Any]]]) -> None:
        """Reddit 데이터를 저장합니다."""
        # 게시물 저장
        posts_ref = self._get_collection_ref(f'reddit_posts_{subreddit}')
        for post in data['posts']:
            post['updated_at'] = firestore.SERVER_TIMESTAMP
            posts_ref.document(post['id']).set(post, merge=True)
        
        # 댓글 저장
        comments_ref = self._get_collection_ref(f'reddit_comments_{subreddit}')
        for comment in data['comments']:
            comment['updated_at'] = firestore.SERVER_TIMESTAMP
            comments_ref.document(comment['id']).set(comment, merge=True)
    
    def get_latest_ticker_analysis(self, ticker: str) -> Dict[str, Any]:
        """특정 티커의 최신 분석 결과를 가져옵니다."""
        doc_ref = self._get_doc_ref('ticker_analyses', ticker)
        doc = doc_ref.get()
        return doc.to_dict() if doc.exists else {}
    
    def get_latest_ticker_quotes(self, symbols: List[str]) -> List[Dict[str, Any]]:
        """여러 티커의 최신 시세 정보를 가져옵니다."""
        quotes = []
        for symbol in symbols:
            doc_ref = self._get_doc_ref('ticker_quotes', symbol)
            doc = doc_ref.get()
            if doc.exists:
                quotes.append(doc.to_dict())
        return quotes 