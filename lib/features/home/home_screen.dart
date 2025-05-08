import 'package:flutter/material.dart';
import '../../widgets/stock_card.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final int maxDays = 7;
  late List<DateTime> loadedDates;
  late Map<DateTime, List<Map<String, dynamic>>> stockDataByDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadedDates = [getBaseDate(DateTime.now())];
    stockDataByDate = {};
    _loadDataForDate(loadedDates.first);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  DateTime getBaseDate(DateTime date) {
    // 07:00 기준 날짜
    final base = DateTime(date.year, date.month, date.day, 7);
    if (date.hour < 7) {
      return base.subtract(const Duration(days: 1));
    }
    return base;
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !isLoading) {
      if (loadedDates.length < maxDays) {
        final nextDate = loadedDates.last.subtract(const Duration(days: 1));
        setState(() => isLoading = true);
        Future.delayed(const Duration(milliseconds: 500), () {
          _loadDataForDate(nextDate);
          setState(() => isLoading = false);
        });
      }
    }
  }

  void _loadDataForDate(DateTime date) {
    // 더미 데이터 10개 생성
    final random = Random(date.millisecondsSinceEpoch);
    final tickers = ['TSLA', 'GME', 'NVDA', 'PLTR', 'AAPL', 'AMZN', 'MSFT', 'META', 'COIN', 'AMD'];
    final logos = [
      'https://logo.clearbit.com/tesla.com',
      'https://logo.clearbit.com/gamestop.com',
      'https://logo.clearbit.com/nvidia.com',
      'https://logo.clearbit.com/palantir.com',
      'https://logo.clearbit.com/apple.com',
      'https://logo.clearbit.com/amazon.com',
      'https://logo.clearbit.com/microsoft.com',
      'https://logo.clearbit.com/meta.com',
      'https://logo.clearbit.com/coinbase.com',
      'https://logo.clearbit.com/amd.com',
    ];
    final summaries = [
      'Elon is cooking again',
      'Holding all my shares',
      'This stock is going parabolic',
      'What a strong earnings beat!',
      'iPhone sales surprise',
      'Prime Day record!',
      'AI everywhere',
      'Threads is back?',
      'Crypto winter is over?',
      'Chip war winner',
    ];
    final List<Map<String, dynamic>> stocks = List.generate(10, (i) {
      final up = random.nextBool();
      final change = (random.nextDouble() * 10 * (up ? 1 : -1));
      return {
        'ticker': tickers[i],
        'logoUrl': logos[i],
        'sentiment': 50 + random.nextInt(50),
        'sentimentEmoji': '😀',
        'summary': summaries[i],
        'price': 10 + random.nextDouble() * 1000,
        'change': change,
      };
    });
    stockDataByDate[date] = stocks;
    setState(() {
      loadedDates.add(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1B2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          '오늘의 밈뉴스',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      drawer: const _HomeDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 마지막 업데이트/다음 업데이트/새로고침
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2634),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 왼쪽: 마지막 업데이트
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '마지막 업데이트',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('yyyy년 MM월 dd일 07:00').format(getBaseDate(DateTime.now())),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                  // 오른쪽: 다음 업데이트
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '다음 업데이트',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '내일 07:00',
                        style: const TextStyle(
                          color: Color(0xFF00C4FF),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 카드 리스트
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: loadedDates.length + (isLoading ? 1 : 0),
                itemBuilder: (context, idx) {
                  if (idx >= loadedDates.length) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ));
                  }
                  final date = loadedDates[idx];
                  final stocks = stockDataByDate[date] ?? [];
                  final dateStr = DateFormat('yyyy년 MM월 dd일 07:00').format(date);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8, top: 16),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A2634),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          dateStr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.95,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: stocks.map((stock) => StockCard(
                          ticker: stock['ticker'],
                          logoUrl: stock['logoUrl'],
                          sentiment: stock['sentiment'],
                          sentimentEmoji: stock['sentimentEmoji'],
                          summary: stock['summary'],
                          price: stock['price'],
                          change: stock['change'],
                        )).toList(),
                      ),
                      if (idx < loadedDates.length - 1)
                        const Divider(color: Color(0xFF374151), thickness: 1, height: 32),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF10151E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0B1B2B)),
            child: Text('🔥 오늘의 밈뉴스', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ListTile(leading: Icon(Icons.person, color: Colors.white), title: Text('내 프로필', style: TextStyle(color: Colors.white))),
          ListTile(leading: Icon(Icons.star, color: Colors.white), title: Text('관심 티커', style: TextStyle(color: Colors.white))),
          ListTile(leading: Icon(Icons.search, color: Colors.white), title: Text('종목 검색', style: TextStyle(color: Colors.white))),
          const Divider(color: Color(0xFF374151)),
          ListTile(leading: Icon(Icons.notifications, color: Colors.white), title: Text('알림 설정', style: TextStyle(color: Colors.white))),
          ListTile(leading: Icon(Icons.palette, color: Colors.white), title: Text('화면 설정', style: TextStyle(color: Colors.white))),
          ListTile(leading: Icon(Icons.menu_book, color: Colors.white), title: Text('밈뉴스 안내', style: TextStyle(color: Colors.white))),
          ListTile(leading: Icon(Icons.feedback, color: Colors.white), title: Text('피드백 및 정보', style: TextStyle(color: Colors.white))),
          const Divider(color: Color(0xFF374151)),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('버전: v0.1', style: TextStyle(color: Color(0xFF9CA3AF))),
          ),
        ],
      ),
    );
  }
} 