import 'package:flutter/material.dart';

class StockCard extends StatelessWidget {
  final String ticker;
  final String logoUrl;
  final int sentiment;
  final String sentimentEmoji;
  final String summary;
  final double price;
  final double change;

  const StockCard({
    super.key,
    required this.ticker,
    required this.logoUrl,
    required this.sentiment,
    required this.sentimentEmoji,
    required this.summary,
    required this.price,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = change >= 0;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF10151E),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 상단: 티커/로고
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  backgroundImage: logoUrl.isNotEmpty ? NetworkImage(logoUrl) : null,
                  child: logoUrl.isEmpty
                      ? Icon(Icons.business, color: Color(0xFF10151E))
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  ticker,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // 등락률 + 감정 (한 줄)
            Row(
              children: [
                Text(
                  '${isUp ? '▲' : '▼'}${change.abs().toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isUp ? const Color(0xFF4CAF50) : const Color(0xFFF64E60),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text('$sentimentEmoji $sentiment%', style: const TextStyle(color: Color(0xFF00C4FF), fontWeight: FontWeight.w600, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 4),
            // 전일 종가 (한 줄)
            Text(
              '전일 종가: \$${price.toStringAsFixed(2)}',
              style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
            ),
            const SizedBox(height: 8),
            // 대표 멘트
            Text(
              summary,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // 감정 게이지 바 (예시)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: sentiment / 100,
                minHeight: 8,
                backgroundColor: const Color(0xFF374151),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00C4FF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 