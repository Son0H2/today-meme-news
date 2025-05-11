import re
from typing import List, Dict, Set
from collections import Counter

class TickerExtractor:
    def __init__(self):
        # 일반적인 단어들을 제외하기 위한 필터
        self.common_words = {
            'A', 'I', 'THE', 'IN', 'ON', 'AT', 'TO', 'FOR', 'OF', 'AND', 'OR',
            'IS', 'ARE', 'WAS', 'WERE', 'BE', 'BEEN', 'BEING', 'HAVE', 'HAS',
            'HAD', 'DO', 'DOES', 'DID', 'WILL', 'WOULD', 'SHALL', 'SHOULD',
            'CAN', 'COULD', 'MAY', 'MIGHT', 'MUST', 'AM'
        }
        
        # 티커 심볼 패턴 (대문자 1-5자)
        self.ticker_pattern = re.compile(r'\$?[A-Z]{1,5}\b')
    
    def extract_tickers(self, text: str) -> Set[str]:
        """텍스트에서 티커 심볼을 추출합니다."""
        # 텍스트를 대문자로 변환
        text = text.upper()
        
        # 티커 심볼 찾기
        matches = self.ticker_pattern.findall(text)
        
        # $ 기호 제거 및 필터링
        tickers = {
            ticker.strip('$') for ticker in matches
            if ticker.strip('$') not in self.common_words
            and len(ticker.strip('$')) > 1  # 1글자 티커 제외
        }
        
        return tickers
    
    def count_tickers(self, texts: List[str]) -> Dict[str, int]:
        """여러 텍스트에서 티커 심볼의 출현 빈도를 계산합니다."""
        all_tickers = []
        
        for text in texts:
            tickers = self.extract_tickers(text)
            all_tickers.extend(tickers)
        
        return dict(Counter(all_tickers))
    
    def get_top_tickers(self, texts: List[str], top_n: int = 10) -> List[Dict[str, any]]:
        """가장 많이 언급된 티커 심볼을 반환합니다."""
        ticker_counts = self.count_tickers(texts)
        
        # 빈도수로 정렬하고 상위 N개 선택
        top_tickers = sorted(
            ticker_counts.items(),
            key=lambda x: x[1],
            reverse=True
        )[:top_n]
        
        return [
            {'symbol': ticker, 'count': count}
            for ticker, count in top_tickers
        ]
    
    def extract_tickers_from_posts(self, posts: List[Dict[str, any]]) -> Dict[str, int]:
        """게시물 목록에서 티커 심볼을 추출하고 집계합니다."""
        texts = []
        
        for post in posts:
            # 제목과 본문 모두에서 티커 추출
            texts.append(post['title'])
            if post['text']:
                texts.append(post['text'])
        
        return self.count_tickers(texts)
    
    def extract_tickers_from_comments(self, comments: List[Dict[str, any]]) -> Dict[str, int]:
        """댓글 목록에서 티커 심볼을 추출하고 집계합니다."""
        texts = [comment['body'] for comment in comments]
        return self.count_tickers(texts) 