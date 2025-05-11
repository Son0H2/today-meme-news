from datetime import datetime, timezone
from typing import Dict, Any, List
from .config import validate_config, SUBREDDITS
from .reddit_client import RedditClient
from .ticker_extractor import TickerExtractor
from .finnhub_client import FinnhubClient
from .gemini_client import GeminiClient
from .firebase_client import FirebaseClient

class MemeNewsPipeline:
    def __init__(self):
        # 환경 변수 검증
        validate_config()
        
        # 클라이언트 초기화
        self.reddit_client = RedditClient()
        self.ticker_extractor = TickerExtractor()
        self.finnhub_client = FinnhubClient()
        self.gemini_client = GeminiClient()
        self.firebase_client = FirebaseClient()
    
    def _collect_reddit_data(self) -> Dict[str, Dict[str, List[Dict[str, Any]]]]:
        """Reddit 데이터를 수집합니다."""
        print("Collecting Reddit data...")
        return self.reddit_client.collect_all_data()
    
    def _extract_tickers(self, reddit_data: Dict[str, Dict[str, List[Dict[str, Any]]]]) -> Dict[str, List[str]]:
        """수집한 Reddit 데이터에서 티커 심볼을 추출합니다."""
        print("Extracting tickers...")
        ticker_mentions = {}
        
        for subreddit, data in reddit_data.items():
            # 게시물에서 티커 추출
            post_tickers = self.ticker_extractor.extract_tickers_from_posts(data['posts'])
            # 댓글에서 티커 추출
            comment_tickers = self.ticker_extractor.extract_tickers_from_comments(data['comments'])
            
            # 티커별 멘션 수 집계
            for ticker, count in post_tickers.items():
                if ticker not in ticker_mentions:
                    ticker_mentions[ticker] = []
                ticker_mentions[ticker].extend([post['title'] for post in data['posts'] if ticker in post['title'].upper()])
            
            for ticker, count in comment_tickers.items():
                if ticker not in ticker_mentions:
                    ticker_mentions[ticker] = []
                ticker_mentions[ticker].extend([comment['body'] for comment in data['comments'] if ticker in comment['body'].upper()])
        
        return ticker_mentions
    
    def _get_ticker_quotes(self, tickers: List[str]) -> List[Dict[str, Any]]:
        """추출한 티커들의 시세 정보를 가져옵니다."""
        print("Fetching ticker quotes...")
        return self.finnhub_client.get_batch_quotes(tickers)
    
    def _analyze_tickers(self, ticker_mentions: Dict[str, List[str]]) -> List[Dict[str, Any]]:
        """티커별 멘션을 분석합니다."""
        print("Analyzing tickers...")
        return self.gemini_client.analyze_tickers(ticker_mentions)
    
    def _save_data(self, reddit_data: Dict[str, Dict[str, List[Dict[str, Any]]]], ticker_quotes: List[Dict[str, Any]], ticker_analyses: List[Dict[str, Any]]) -> None:
        """수집 및 분석한 데이터를 저장합니다."""
        print("Saving data...")
        
        # Reddit 데이터 저장
        for subreddit, data in reddit_data.items():
            self.firebase_client.save_reddit_data(subreddit, data)
        
        # 티커 시세 정보 저장
        self.firebase_client.save_ticker_quotes(ticker_quotes)
        
        # 티커 분석 결과 저장
        for analysis in ticker_analyses:
            self.firebase_client.save_ticker_analysis(analysis['ticker'], analysis)
    
    def run(self) -> None:
        """전체 파이프라인을 실행합니다."""
        print(f"Starting pipeline at {datetime.now(timezone.utc)}...")
        
        try:
            # 1. Reddit 데이터 수집
            reddit_data = self._collect_reddit_data()
            
            # 2. 티커 심볼 추출
            ticker_mentions = self._extract_tickers(reddit_data)
            
            # 3. 티커 시세 정보 가져오기
            ticker_quotes = self._get_ticker_quotes(list(ticker_mentions.keys()))
            
            # 4. 티커 분석
            ticker_analyses = self._analyze_tickers(ticker_mentions)
            
            # 5. 데이터 저장
            self._save_data(reddit_data, ticker_quotes, ticker_analyses)
            
            print(f"Pipeline completed successfully at {datetime.now(timezone.utc)}.")
        except Exception as e:
            print(f"Pipeline failed: {str(e)}")
            raise

if __name__ == '__main__':
    pipeline = MemeNewsPipeline()
    pipeline.run() 