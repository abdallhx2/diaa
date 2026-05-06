import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/loading_widget.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _onQRDetected(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final qrData = barcodes.first.rawValue;
    if (qrData == null || qrData.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      await context.read<LessonProvider>().processQr(qrData);

      if (!mounted) return;

      final lessonProvider = context.read<LessonProvider>();
      if (lessonProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              lessonProvider.errorMessage!,
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        setState(() => _isProcessing = false);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.textDisplay);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'هذا الكود غير مرتبط بدرس',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onQRDetected,
          ),
          // Dark top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                bottom: 12,
                left: 16,
                right: 16,
              ),
              color: const Color(0xCC0D0D14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'مسح كود QR',
                    style: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
          ),
          // Scan guide overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.primary100,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Bottom instruction
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xCC0D0D14), Colors.transparent],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'وجّه الكاميرا نحو كود QR',
                    style: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  if (_isProcessing) ...[
                    const SizedBox(height: 16),
                    const LoadingWidget(message: 'جاري تحميل الدرس...'),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
