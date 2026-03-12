import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
 
class ScanService {
  Future<Map<String, dynamic>> scanQR(String lessonId) async {
    return {
      'id':           lessonId,
      'title':        'درس مستخرج',
      'originalText': 'النص المستخرج من الدرس',
      'audioUrl':     null,
    };
  }
}
 
class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});
 
  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}
 
class _ScanQrScreenState extends State<ScanQrScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;
 
  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }
 
  Future<void> _onQRDetected(BarcodeCapture capture) async {
    if (_isProcessing) { return; }
 
    final rawValue = capture.barcodes.firstOrNull?.rawValue;
    if (rawValue == null || rawValue.isEmpty) { return; }
 
    setState(() { _isProcessing = true; });
 
    try {
      final result = await ScanService().scanQR(rawValue);
 
      if (!mounted) { return; }
 
      context.read<LessonProvider>().setExtractedText(
          result['originalText'] as String? ?? '');
 
      Navigator.pushReplacementNamed(context, '/text-display');
 
    } catch (_) {
      if (!mounted) { return; }
      _showErrorSnackBar('هذا الكود غير مرتبط بدرس، حاول مرة أخرى.');
      setState(() { _isProcessing = false; });
    }
  }
 
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title:       const Text('مسح كود QR'),
          centerTitle: true,
          leading: IconButton(
            icon:      const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _scannerController,
              onDetect:   _onQRDetected,
            ),
 
            _buildOverlay(),
 
            if (_isProcessing)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        'جاري جلب الدرس...',
                        style: TextStyle(
                          color:      Colors.white,
                          fontSize:   20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:        Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'وجّه الكاميرا نحو كود QR',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
 
        const SizedBox(height: 32),
 
        Container(
          width:  220,
          height: 220,
          decoration: BoxDecoration(
            border:       Border.all(color: AppTheme.primaryBlue, width: 3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              _buildCorner(top: 0,    left:  0, isTop: true,  isLeft: true),
              _buildCorner(top: 0,    right: 0, isTop: true,  isLeft: false),
              _buildCorner(bottom: 0, left:  0, isTop: false, isLeft: true),
              _buildCorner(bottom: 0, right: 0, isTop: false, isLeft: false),
            ],
          ),
        ),
 
        const SizedBox(height: 32),
 
        Text(
          'سيتم المسح تلقائياً عند اكتشاف الكود',
          style: TextStyle(
            color:    Colors.white.withValues(alpha: 0.70),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
 
  Widget _buildCorner({
    double? top, double? bottom, double? left, double? right,
    required bool isTop, required bool isLeft,
  }) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          border: Border(
            top:    isTop   ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            bottom: !isTop  ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            left:   isLeft  ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
            right:  !isLeft ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
