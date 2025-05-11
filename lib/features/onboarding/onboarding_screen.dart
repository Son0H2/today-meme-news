import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      emoji: '🔥',
      title: '미국 밈 주식 커뮤니티\n트렌드를 한눈에!',
      description: '레딧에서 화제가 되는 밈 주식 소식을\n쉽고 빠르게 받아보세요.',
    ),
    _OnboardingPageData(
      emoji: '📈',
      title: '가장 많이 언급된\n밈 종목을 한눈에!',
      description: '커뮤니티 인기 종목과 감정 분석,\n주요 지표를 한 번에 확인하세요.',
    ),
    _OnboardingPageData(
      emoji: '🔔',
      title: '매일 아침 트렌드 알림',
      description: '놓치기 쉬운 이슈도\n푸시 알림으로 빠르게 받아보세요.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1B2B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (idx) => setState(() => _page = idx),
                  itemBuilder: (context, idx) {
                    final data = _pages[idx];
                    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                        Text(
                          data.emoji,
                          style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 32),
              Text(
                          data.title,
                textAlign: TextAlign.center,
                          style: const TextStyle(
                  fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w800,
                  fontSize: 28,
                            color: Colors.white,
                ),
              ),
                        if (data.description.isNotEmpty) ...[
                          const SizedBox(height: 24),
              Text(
                            data.description,
                textAlign: TextAlign.center,
                            style: const TextStyle(
                  fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                  fontSize: 16,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (idx) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _page == idx ? const Color(0xFF00C4FF) : const Color(0xFF374151),
                ),
                )),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C4FF),
                    foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                  ),
                    elevation: 0,
                ),
                onPressed: () {
                    if (_page < _pages.length - 1) {
                      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                    } else {
                      context.go('/permission');
                    }
                },
                  child: Text(
                    _page == _pages.length - 1 ? '시작하기' : '다음',
                    style: const TextStyle(
                    fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String emoji;
  final String title;
  final String description;
  const _OnboardingPageData({required this.emoji, required this.title, required this.description});
} 