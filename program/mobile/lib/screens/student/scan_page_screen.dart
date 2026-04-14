import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/services/scan_service.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class ScanPageScreen extends StatefulWidget {
  const ScanPageScreen({super.key});

  @override
  State<ScanPageScreen> createState() => _ScanPageScreenState();
}

class _ScanPageScreenState extends State<ScanPageScreen> {
  CameraController? _cameraController;
  bool    _isCameraInitialized = false;
  bool    _isScanning          = false;
  bool    _permissionDenied    = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'لا توجد كاميرا متاحة على هذا الجهاز.';
        });
        return;
      }

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio:      false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (!mounted) { return; }

      setState(() { _isCameraInitialized = true; });

    } on CameraException catch (e) {
      if (!mounted) { return; }
      if (e.code == 'CameraAccessDenied' ||
          e.code == 'CameraAccessDeniedWithoutPrompt' ||
          e.code == 'CameraAccessRestricted') {
        setState(() { _permissionDenied = true; });
      } else {
        setState(() {
          _errorMessage = 'تعذّر تشغيل الكاميرا: ${e.description}';
        });
      }
    } catch (e) {
      if (!mounted) { return; }
      setState(() {
        _errorMessage = 'حدث خطأ غير متوقع. يرجى المحاولة مجدداً.';
      });
    }
  }

  Future<void> _captureAndScan() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isScanning) {
      return;
    }

    setState(() { _isScanning = true; });

    try {
      final XFile xfile     = await _cameraController!.takePicture();
      final File  imageFile = File(xfile.path);

      if (!mounted) { return; }

      final lesson = await ScanService().scanPage(imageFile);

      if (!mounted) { return; }

      context.read<LessonProvider>().setLesson(lesson);

      Navigator.pushNamed(context, '/text-display');

    } on CameraException catch (_) {
      if (!mounted) { return; }
      _showErrorSnackBar('تعذّر التقاط الصورة. يرجى المحاولة مجدداً.');
    } catch (_) {
      if (!mounted) { return; }
      _showErrorSnackBar('لم نتمكن من استخراج النص، حاول مرة أخرى.');
    } finally {
      if (mounted) { setState(() { _isScanning = false; }); }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
          textDirection: TextDirection.rtl,
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
          title:       const Text('مسح صفحة'),
          centerTitle: true,
          leading: IconButton(
            icon:      const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _buildBody(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _isCameraInitialized && !_permissionDenied
            ? _buildCaptureButton()
            : null,
      ),
    );
  }

  Widget _buildBody() {
    if (_permissionDenied) { return _buildPermissionDeniedView(); }
    if (_errorMessage != null) { return _buildErrorView(_errorMessage!); }

    if (!_isCameraInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'جاري تشغيل الكاميرا...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraController!),
        _buildGuidanceOverlay(),
        if (_isScanning)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'جاري استخراج النص...',
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
    );
  }

  Widget _buildGuidanceOverlay() {
    return Positioned(
      top: 60, left: 24, right: 24,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color:        Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'وجّه الكاميرا نحو الصفحة',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 280,
            decoration: BoxDecoration(
              border:       Border.all(color: Colors.white70, width: 2),
              borderRadius: BorderRadius.circular(12),
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
        ],
      ),
    );
  }

  Widget _buildCorner({
    double? top, double? bottom, double? left, double? right,
    required bool isTop, required bool isLeft,
  }) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: 24, height: 24,
        decoration: BoxDecoration(
          border: Border(
            top:    isTop   ? const BorderSide(color: AppTheme.primaryBlue, width: 3) : BorderSide.none,
            bottom: !isTop  ? const BorderSide(color: AppTheme.primaryBlue, width: 3) : BorderSide.none,
            left:   isLeft  ? const BorderSide(color: AppTheme.primaryBlue, width: 3) : BorderSide.none,
            right:  !isLeft ? const BorderSide(color: AppTheme.primaryBlue, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: _isScanning ? null : _captureAndScan,
      child: Container(
        width: 80, height: 80,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isScanning ? Colors.grey : Colors.white,
          border: Border.all(color: AppTheme.primaryBlue, width: 4),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset:     const Offset(0, 4),
            ),
          ],
        ),
        child: _isScanning
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                    strokeWidth: 3, color: AppTheme.primaryBlue),
              )
            : const Icon(
                Icons.camera_alt_rounded,
                size:  40,
                color: AppTheme.primaryBlue,
              ),
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_photography_rounded,
                size: 80, color: Colors.white54),
            const SizedBox(height: 24),
            const Text(
              'يجب السماح بالوصول للكاميرا',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:      Colors.white,
                fontSize:   22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'التطبيق يحتاج إذن الكاميرا لمسح الصفحات واستخراج النص.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => openAppSettings(),
              icon:  const Icon(Icons.settings_rounded),
              label: const Text('فتح الإعدادات'),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 52)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 72, color: AppTheme.errorColor),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage        = null;
                  _isCameraInitialized = false;
                });
                _initCamera();
              },
              child: const Text('حاول مجدداً'),
            ),
          ],
        ),
      ),
    );
  }
}
