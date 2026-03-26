import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/config/constants.dart';
 
class ScanService {
  Future<Map<String, dynamic>> uploadFile(File image) async {
    return {
      'id':           'lesson_001',
      'title':        'درس مستخرج',
      'originalText': 'النص المستخرج من الصورة',
      'audioUrl':     null,
    };
  }
}
 
class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});
 
  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}
 
class _UploadFileScreenState extends State<UploadFileScreen> {
  File?             _selectedImage;
  bool              _isLoading = false;
  final ImagePicker _picker    = ImagePicker();
 
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source:       ImageSource.gallery,
      maxWidth:     1920,
      maxHeight:    1920,
      imageQuality: 85,
    );
 
    if (image == null) { return; }
 
    final size = await image.length();
    if (size > AppConstants.imageMaxSizeBytes) {
      if (!mounted) { return; }
      _showErrorSnackBar(
          'حجم الصورة كبير جداً — الحد الأقصى ${AppConstants.imageMaxSizeMB} ميغابايت.');
      return;
    }
 
    setState(() { _selectedImage = File(image.path); });
  }
 
  Future<void> _uploadAndExtract() async {
    if (_selectedImage == null) { return; }
 
    setState(() { _isLoading = true; });
 
    try {
      final result = await ScanService().uploadFile(_selectedImage!);
 
      if (!mounted) { return; }
 
      context.read<LessonProvider>().setExtractedText(
          result['originalText'] as String? ?? '');
 
      Navigator.pushNamed(context, '/text-display');
 
    } catch (_) {
      if (!mounted) { return; }
      _showErrorSnackBar('لم نتمكن من استخراج النص، حاول مرة أخرى.');
    } finally {
      if (mounted) { setState(() { _isLoading = false; }); }
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
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('رفع ملف'),
          leading: IconButton(
            icon:      const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _selectedImage == null
                ? _buildEmptyState()
                : _buildImagePreview(),
          ),
        ),
      ),
    );
  }
 
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width:  120,
          height: 120,
          decoration: BoxDecoration(
            color:        AppTheme.primaryBlue15,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.upload_file_rounded,
            size:  64,
            color: AppTheme.primaryBlue,
          ),
        ),
 
        const SizedBox(height: 24),
 
        Text(
          'اختر صورة من الجهاز',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
 
        const SizedBox(height: 8),
 
        Text(
          'الحد الأقصى ${AppConstants.imageMaxSizeMB} ميغابايت',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
 
        const SizedBox(height: 40),
 
        SizedBox(
          width: double.infinity,
          height: AppConstants.minButtonSize,
          child: ElevatedButton.icon(
            onPressed: _pickImage,
            icon:  const Icon(Icons.photo_library_rounded),
            label: const Text('اختيار صورة'),
          ),
        ),
      ],
    );
  }
 
  Widget _buildImagePreview() {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              _selectedImage!,
              fit:   BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),
 
        const SizedBox(height: 24),
 
        SizedBox(
          width:  double.infinity,
          height: AppConstants.minButtonSize,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _uploadAndExtract,
            icon: _isLoading
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.text_snippet_rounded),
            label: Text(_isLoading ? 'جاري الاستخراج...' : 'استخراج النص'),
          ),
        ),
 
        const SizedBox(height: 12),
 
        SizedBox(
          width:  double.infinity,
          height: AppConstants.minButtonSize,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _pickImage,
            icon:  const Icon(Icons.photo_library_rounded),
            label: const Text('اختيار صورة أخرى'),
          ),
        ),
      ],
    );
  }
}