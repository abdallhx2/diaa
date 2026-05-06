import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';
import 'package:edu_smart_assistant/widgets/diyaa_inner_nav.dart';
import 'package:edu_smart_assistant/widgets/custom_button.dart';

class LessonDetailScreen extends StatefulWidget {
  final String lessonName;

  const LessonDetailScreen({super.key, required this.lessonName});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedOption = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg100,
      body: Column(
        children: [
          DiyaaInnerNav(title: widget.lessonName),
          // TabBar outside AppBar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primary100,
              indicatorWeight: 3,
              labelColor: AppTheme.primary200,
              unselectedLabelColor: AppTheme.text200,
              labelStyle: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.tajawal(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: '① فيديو'),
                Tab(text: '② الملخص'),
                Tab(text: '③ اختبر'),
                Tab(text: '④ اسأل'),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVideoTab(),
                _buildSummaryTab(),
                _buildQuizTab(),
                _buildAiChatTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab 1: Video ────────────────────────────────────────────────

  Widget _buildVideoTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Video area
          Container(
            height: 200,
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primary100.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x808B5FBF),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '▶',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab 2: Summary ──────────────────────────────────────────────

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title — listen to summary
          Row(
            children: [
              const Text('🔊', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                'استمع للملخص',
                style: GoogleFonts.tajawal(
                  color: AppTheme.primary200,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Audio bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x108B5FBF),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Play button
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary200,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '⏸',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 12),
                // Audio waves placeholder
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(8, (index) {
                      final heights = [14.0, 22.0, 10.0, 28.0, 16.0, 24.0, 12.0, 20.0];
                      return Container(
                        width: 3,
                        height: heights[index],
                        decoration: BoxDecoration(
                          color: AppTheme.accent200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                // Time
                Text(
                  '0:22',
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text200,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Section title — text
          Row(
            children: [
              const Text('📄', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                'النص',
                style: GoogleFonts.tajawal(
                  color: AppTheme.primary200,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Text box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x108B5FBF),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'الطبيعة من حولنا جميلة ومتنوعة. نرى الأشجار الخضراء والأزهار الملونة في كل مكان. '
              'الشمس تشرق كل صباح لتنير لنا الطريق، والقمر يضيء ليلنا بنوره الهادئ. '
              'يجب أن نحافظ على البيئة ونحمي الطبيعة لأنها هدية من الله لنا جميعاً.',
              style: GoogleFonts.tajawal(
                color: AppTheme.text100,
                fontSize: 14,
                height: 1.8,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab 3: Quiz ─────────────────────────────────────────────────

  Widget _buildQuizTab() {
    // Demo quiz data
    const question = 'ما هو لون السماء في النهار؟';
    const options = ['أحمر', 'أزرق', 'أخضر', 'أصفر'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question counter row
          Row(
            children: [
              Text(
                'السؤال ١ من ٣',
                style: GoogleFonts.tajawal(
                  color: AppTheme.text200,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              // Progress dots
              Row(
                children: List.generate(3, (index) {
                  return Container(
                    width: 28,
                    height: 6,
                    margin: EdgeInsets.only(left: index < 2 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: index == 0
                          ? AppTheme.primary100
                          : AppTheme.bg200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quiz card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x108B5FBF),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question
                Text(
                  question,
                  style: GoogleFonts.tajawal(
                    color: AppTheme.text100,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                // Options
                ...List.generate(options.length, (index) {
                  final isSelected = _selectedOption == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedOption = index;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary100.withValues(alpha: 0.08)
                            : AppTheme.bg100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primary100
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        options[index],
                        style: GoogleFonts.tajawal(
                          color: isSelected
                              ? AppTheme.primary200
                              : AppTheme.text100,
                          fontSize: 13.5,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                // Confirm button
                CustomButton(
                  text: 'تأكيد الإجابة',
                  onPressed: _selectedOption >= 0
                      ? () {
                          // TODO: connect to quiz provider
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab 4: AI Chat ──────────────────────────────────────────────

  Widget _buildAiChatTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              const Text('🤖', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                'اسأل بالدرس (AI)',
                style: GoogleFonts.tajawal(
                  color: AppTheme.primary200,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Chat area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x108B5FBF),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI welcome message
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: AppTheme.bg100,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    'اهلاً! اسألني أي سؤال عن درس ${widget.lessonName} 🌿',
                    style: GoogleFonts.tajawal(
                      color: AppTheme.text100,
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 12),
                // Input row
                Row(
                  children: [
                    // Text input
                    Expanded(
                      child: TextFormField(
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.tajawal(
                          fontSize: 13.5,
                          color: AppTheme.text100,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppTheme.bg100,
                          hintText: 'اكتب سؤالك هنا...',
                          hintStyle: GoogleFonts.tajawal(
                            color: AppTheme.text200,
                            fontSize: 13,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppTheme.bg200,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppTheme.bg200,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppTheme.primary100,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Send button
                    GestureDetector(
                      onTap: () {
                        // TODO: connect to chat provider
                      },
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppTheme.primary100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '➤',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
