import google.generativeai as genai
from typing import List, Dict, Any
from .config import GEMINI_API_KEY

class GeminiClient:
    def __init__(self):
        genai.configure(api_key=GEMINI_API_KEY)
        self.model = genai.GenerativeModel('gemini-pro')
    
    def _create_summary_prompt(self, ticker: str, mentions: List[str]) -> str:
        """요약을 위한 프롬프트를 생성합니다."""
        return f"""다음은 주식 티커 {ticker}에 대한 Reddit 커뮤니티 멘션들입니다. 
이 멘션들을 바탕으로 한국어로 2줄 요약을 작성해주세요. 
첫 줄은 핵심 내용, 둘째 줄은 커뮤니티 분위기(긍정/부정/중립)를 포함해주세요.

멘션들:
{chr(10).join(mentions)}

요약 형식:
[핵심 내용]
[커뮤니티 분위기]"""

    def _create_sentiment_prompt(self, ticker: str, mentions: List[str]) -> str:
        """감정 분석을 위한 프롬프트를 생성합니다."""
        return f"""다음은 주식 티커 {ticker}에 대한 Reddit 커뮤니티 멘션들입니다. 
이 멘션들을 바탕으로 커뮤니티의 감정을 분석해주세요.
긍정(1), 중립(0), 부정(-1) 중 하나의 숫자로 응답해주세요.

멘션들:
{chr(10).join(mentions)}

응답 형식:
숫자만 입력 (예: 1 또는 0 또는 -1)"""

    def summarize_ticker(self, ticker: str, mentions: List[str]) -> Dict[str, Any]:
        """특정 티커에 대한 멘션들을 요약하고 감정을 분석합니다."""
        try:
            # 요약 생성
            summary_prompt = self._create_summary_prompt(ticker, mentions)
            summary_response = self.model.generate_content(summary_prompt)
            summary_lines = summary_response.text.strip().split('\n')
            
            # 감정 분석
            sentiment_prompt = self._create_sentiment_prompt(ticker, mentions)
            sentiment_response = self.model.generate_content(sentiment_prompt)
            sentiment_score = int(sentiment_response.text.strip())
            
            return {
                'ticker': ticker,
                'summary': {
                    'content': summary_lines[0] if len(summary_lines) > 0 else '',
                    'mood': summary_lines[1] if len(summary_lines) > 1 else ''
                },
                'sentiment_score': sentiment_score
            }
        except Exception as e:
            print(f"Error analyzing {ticker}: {str(e)}")
            return {
                'ticker': ticker,
                'error': str(e)
            }
    
    def analyze_tickers(self, ticker_mentions: Dict[str, List[str]]) -> List[Dict[str, Any]]:
        """여러 티커에 대한 분석을 수행합니다."""
        results = []
        for ticker, mentions in ticker_mentions.items():
            analysis = self.summarize_ticker(ticker, mentions)
            results.append(analysis)
        return results 