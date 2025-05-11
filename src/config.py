import os
from dotenv import load_dotenv

# .env 파일 로드
load_dotenv()

# Reddit 설정
REDDIT_CONFIG = {
    'client_id': os.getenv('REDDIT_CLIENT_ID'),
    'client_secret': os.getenv('REDDIT_CLIENT_SECRET'),
    'user_agent': os.getenv('REDDIT_USER_AGENT')
}

# Finnhub 설정
FINNHUB_API_KEY = os.getenv('FINNHUB_API_KEY')

# Firebase 설정
FIREBASE_CONFIG = {
    'project_id': os.getenv('FIREBASE_PROJECT_ID'),
    'database_url': os.getenv('FIREBASE_DATABASE_URL')
}

# Gemini 설정
GEMINI_API_KEY = os.getenv('GEMINI_API_KEY')

# Reddit 서브레딧 목록
SUBREDDITS = [
    'wallstreetbets',
    'stocks',
    'investing',
    'stockmarket',
    'pennystocks'
]

# 데이터 수집 설정
COLLECTION_SETTINGS = {
    'posts_limit': 100,  # 각 서브레딧당 수집할 게시물 수
    'comments_limit': 50,  # 각 게시물당 수집할 댓글 수
    'time_filter': 'day'  # 'hour', 'day', 'week', 'month', 'year', 'all'
}

def validate_config():
    """필수 환경 변수가 설정되어 있는지 확인"""
    required_vars = [
        'REDDIT_CLIENT_ID',
        'REDDIT_CLIENT_SECRET',
        'REDDIT_USER_AGENT',
        'FINNHUB_API_KEY',
        'GEMINI_API_KEY',
        'FIREBASE_PROJECT_ID',
        'FIREBASE_DATABASE_URL'
    ]
    
    missing_vars = [var for var in required_vars if not os.getenv(var)]
    if missing_vars:
        raise EnvironmentError(
            f"Missing required environment variables: {', '.join(missing_vars)}"
        ) 