import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String ticker;
  final String logoUrl;
  final int sentiment;
  final String sentimentEmoji;
  final double price;
  final double change;
  final List<String> summaryList;

  const DetailScreen({
    super.key,
    required this.ticker,
    required this.logoUrl,
    required this.sentiment,
    required this.sentimentEmoji,
    required this.price,
    required this.change,
    required this.summaryList,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = change >= 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('$ticker 상세'),
        backgroundColor: const Color(0xFF0B1B2B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF0B1B2B),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 28,
                  backgroundImage: logoUrl.isNotEmpty ? NetworkImage(logoUrl) : null,
                  child: logoUrl.isEmpty ? Icon(Icons.business, color: Color(0xFF10151E)) : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticker,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${isUp ? '▲' : '▼'}${change.abs().toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: isUp ? const Color(0xFF4CAF50) : const Color(0xFFF64E60),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('$sentimentEmoji $sentiment%', style: const TextStyle(color: Color(0xFF00C4FF), fontWeight: FontWeight.w600, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('전일 종가: \$${price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('전날 레딧 대표 멘트', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            ...summaryList.map((s) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF10151E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 15)),
            )),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Color(0xFF18202B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '오늘의 소문\n\n테슬라는 전날 Reddit에서 "Elon is cooking again" 등 긍정적 밈이 다수 등장하며 투자자들의 기대감이 높아졌습니다.\n주가도 1.5% 상승 마감하며 커뮤니티 분위기와 동조하는 흐름을 보였습니다.',
                style: TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C4FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.open_in_new),
                label: const Text('Reddit 원문 보기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 