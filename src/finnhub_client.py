import finnhub
from datetime import datetime, timedelta
from typing import Dict, Any, List
from .config import FINNHUB_API_KEY

class FinnhubClient:
    def __init__(self):
        self.client = finnhub.Client(api_key=FINNHUB_API_KEY)
    
    def get_quote(self, symbol: str) -> Dict[str, Any]:
        """특정 종목의 현재 시세 정보를 가져옵니다."""
        try:
            quote = self.client.quote(symbol)
            return {
                'symbol': symbol,
                'current_price': quote.get('c', 0),  # 현재가
                'change': quote.get('dp', 0),  # 등락률(%)
                'high': quote.get('h', 0),  # 고가
                'low': quote.get('l', 0),  # 저가
                'open': quote.get('o', 0),  # 시가
                'prev_close': quote.get('pc', 0),  # 전일종가
                'timestamp': datetime.fromtimestamp(quote.get('t', 0))
            }
        except Exception as e:
            print(f"Error fetching quote for {symbol}: {str(e)}")
            return {
                'symbol': symbol,
                'error': str(e)
            }
    
    def get_company_profile(self, symbol: str) -> Dict[str, Any]:
        """종목의 기본 정보를 가져옵니다."""
        try:
            profile = self.client.company_profile2(symbol=symbol)
            if profile:
                return {
                    'symbol': symbol,
                    'name': profile.get('name', ''),
                    'ticker': profile.get('ticker', ''),
                    'logo': profile.get('logo', ''),
                    'weburl': profile.get('weburl', ''),
                    'finnhubIndustry': profile.get('finnhubIndustry', '')
                }
            return {'symbol': symbol, 'error': 'No profile found'}
        except Exception as e:
            print(f"Error fetching profile for {symbol}: {str(e)}")
            return {'symbol': symbol, 'error': str(e)}
    
    def get_batch_quotes(self, symbols: List[str]) -> List[Dict[str, Any]]:
        """여러 종목의 시세 정보를 한 번에 가져옵니다."""
        results = []
        for symbol in symbols:
            quote_data = self.get_quote(symbol)
            if 'error' not in quote_data:
                profile_data = self.get_company_profile(symbol)
                quote_data.update(profile_data)
            results.append(quote_data)
        return results 