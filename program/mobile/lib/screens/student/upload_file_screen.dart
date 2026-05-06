import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:edu_smart_assistant/providers/lesson_provider.dart';
import 'package:edu_smart_assistant/config/routes.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/config/constants.dart';
import 'package:edu_smart_assistant/widgets/custom_button.dart';
import 'package:edu_smart_assistant/widgets/loading_widget.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image == null) return;

    final fileSize = await File(image.path).length();
    if (fileSize > AppConstants.maxImageSizeBytes) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'حجم الصورة كبير جداً (الحد 10 ميغابايت)',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
      return;
    }

    setState(() => _selectedImage = File(image.path));
  }

  Future<void> _uploadAndExtract() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    try {
      await context.read<LessonProvider>().processImage(_selectedImage!);

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
              'لم نتمكن من استخراج النص، حاول مرة أخرى',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Column(
        children: [
          DiyaaInnerNav(
            title: 'رفع ملف',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _isLoading
                  ? const Center(
                      child: LoadingWidget(message: 'جاري استخراج النص...'))
                  : _selectedImage == null
                      ? _buildPickerView()
                      : _buildPreviewView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.accent100.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.upload_file,
              size: 64,
              color: AppTheme.primary100,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'اختر صورة من الجهاز',
            style: GoogleFonts.tajawal(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.text100,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'الحد الأقصى ${AppConstants.maxImageSizeMB} ميغابايت',
            style: GoogleFonts.tajawal(
              fontSize: 16,
              color: AppTheme.text200,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'اختيار صورة',
            icon: Icons.photo_library,
            color: AppTheme.primary200,
            onPressed: _pickImage,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewView() {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'استخراج النص',
          icon: Icons.text_fields,
          onPressed: _uploadAndExtract,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'اختيار صورة أخرى',
          icon: Icons.photo_library,
          color: AppTheme.accent200,
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
