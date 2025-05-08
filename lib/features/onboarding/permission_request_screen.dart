import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';

class PermissionRequestScreen extends StatelessWidget {
  const PermissionRequestScreen({super.key});

  Future<void> _showCustomDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF3F4F6),
        title: Column(
          children: [
            Icon(Icons.notifications_active_rounded, size: 48, color: Color(0xFF00C4FF)),
            const SizedBox(height: 16),
            const Text(
              '알림을 받아보시겠어요?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: const Text(
          'today_meme_news에서 푸시 알림을 보내드릴 수 있도록 허용해 주세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C4FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('허용', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF6B7280),
                side: const BorderSide(color: Color(0xFF6B7280)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('허용 안 함', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
    if (result == true) {
      await Permission.notification.request();
    }
    // 권한 허용/거부와 관계없이 다음 화면으로 이동
    // (여기서는 관심 티커 선택 화면으로 이동한다고 가정)
    // context.go('/pick-favorites');
    context.go('/home'); // 임시로 홈으로 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1B2B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_active_rounded, size: 72, color: Color(0xFF00C4FF)),
              const SizedBox(height: 32),
              const Text(
                '푸시 알림 권한을 허용해 주세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '매일 아침 트렌드 알림, 이슈 속보 등\n중요한 소식을 빠르게 받아볼 수 있어요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 32),
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
                  onPressed: () => _showCustomDialog(context),
                  child: const Text(
                    '알림 허용 안내',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/home'); // 임시로 홈으로 이동
                },
                child: const Text(
                  '건너뛰기',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'iOS는 알림 권한 요청 전, 사전 안내가 필요합니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 