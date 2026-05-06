import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/loading_widget.dart';

class ScanPageScreen extends StatefulWidget {
  const ScanPageScreen({super.key});

  @override
  State<ScanPageScreen> createState() => _ScanPageScreenState();
}

class _ScanPageScreenState extends State<ScanPageScreen> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = '\u0644\u0627 \u062A\u0648\u062C\u062F \u0643\u0627\u0645\u064A\u0631\u0627 \u0645\u062A\u0627\u062D\u0629');
        return;
      }

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Camera init error: $e');
      if (mounted) {
        setState(() => _errorMessage =
            '\u0644\u0627 \u064A\u0645\u0643\u0646 \u0627\u0644\u0648\u0635\u0648\u0644 \u0644\u0644\u0643\u0627\u0645\u064A\u0631\u0627. \u062A\u0623\u0643\u062F \u0645\u0646 \u0645\u0646\u062D \u0627\u0644\u062A\u0637\u0628\u064A\u0642 \u0635\u0644\u0627\u062D\u064A\u0629 \u0627\u0633\u062A\u062E\u062F\u0627\u0645 \u0627\u0644\u0643\u0627\u0645\u064A\u0631\u0627 \u0645\u0646 \u0625\u0639\u062F\u0627\u062F\u0627\u062A \u0627\u0644\u062C\u0647\u0627\u0632');
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _captureAndScan() async {
    if (_isProcessing || _cameraController == null) return;

    setState(() => _isProcessing = true);

    try {
      final image = await _cameraController!.takePicture();
      if (!mounted) return;

      await context.read<LessonProvider>().processImage(File(image.path));

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
      } else {
        Navigator.pushNamed(context, AppRoutes.textDisplay);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '\u0644\u0645 \u0646\u062A\u0645\u0643\u0646 \u0645\u0646 \u0627\u0633\u062A\u062E\u0631\u0627\u062C \u0627\u0644\u0646\u0635\u060C \u062D\u0627\u0648\u0644 \u0645\u0631\u0629 \u0623\u062E\u0631\u0649',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      body: SafeArea(
        child: Column(
          children: [
            // Dark nav
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '\u0627\u0642\u0631\u0623 \u0644\u064A',
                    style: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Viewfinder
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0x808B5FBF),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      // Camera preview or placeholder
                      if (_errorMessage != null)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera_alt,
                                    size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  _errorMessage!,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (!_isInitialized)
                        const Center(
                          child: LoadingWidget(
                              message:
                                  '\u062C\u0627\u0631\u064A \u062A\u0634\u063A\u064A\u0644 \u0627\u0644\u0643\u0627\u0645\u064A\u0631\u0627...'),
                        )
                      else
                        Positioned.fill(
                          child: CameraPreview(_cameraController!),
                        ),

                      // Center placeholder (shown when no camera)
                      if (!_isInitialized && _errorMessage == null)
                        const SizedBox.shrink()
                      else if (_errorMessage == null && _isInitialized)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: 0.4,
                                child: Text(
                                  '\uD83D\uDCF7',
                                  style: GoogleFonts.tajawal(fontSize: 40),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '\u0648\u062C\u0651\u0647 \u0627\u0644\u0643\u0627\u0645\u064A\u0631\u0627 \u0646\u062D\u0648 \u0627\u0644\u0635\u0641\u062D\u0629',
                                style: GoogleFonts.tajawal(
                                  color: Colors.white.withValues(alpha: 0.40),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Corner markers
                      _buildCornerMarkers(),

                      // Full-screen loading overlay during processing
                      if (_isProcessing)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.6),
                            child: const Center(
                              child: LoadingWidget(
                                  message:
                                      '\u062C\u0627\u0631\u064A \u0627\u0633\u062A\u062E\u0631\u0627\u062C \u0627\u0644\u0646\u0635...'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Capture button
            GestureDetector(
              onTap: _isProcessing ? null : _captureAndScan,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary200,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary200.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '\uD83D\uDCF7 \u0627\u0644\u062A\u0642\u0627\u0637 \u0627\u0644\u0635\u0648\u0631\u0629',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // History link
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 12),
              child: Center(
                child: Text(
                  '\uD83D\uDD52 \u0633\u062C\u0644 \u0627\u0644\u0642\u0631\u0627\u0621\u0627\u062A',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.accent200,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerMarkers() {
    const markerSize = 20.0;
    const markerThickness = 3.0;
    const markerColor = AppTheme.primary100;

    return Stack(
      children: [
        // Top-left
        Positioned(
          top: 8,
          left: 8,
          child: SizedBox(
            width: markerSize,
            height: markerSize,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: markerColor, width: markerThickness),
                  left: BorderSide(color: markerColor, width: markerThickness),
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        // Top-right
        Positioned(
          top: 8,
          right: 8,
          child: SizedBox(
            width: markerSize,
            height: markerSize,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: markerColor, width: markerThickness),
                  right: BorderSide(color: markerColor, width: markerThickness),
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        // Bottom-left
        Positioned(
          bottom: 8,
          left: 8,
          child: SizedBox(
            width: markerSize,
            height: markerSize,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: markerColor, width: markerThickness),
                  left: BorderSide(color: markerColor, width: markerThickness),
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        // Bottom-right
        Positioned(
          bottom: 8,
          right: 8,
          child: SizedBox(
            width: markerSize,
            height: markerSize,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: markerColor, width: markerThickness),
                  right: BorderSide(color: markerColor, width: markerThickness),
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ],
    );
  }
}
