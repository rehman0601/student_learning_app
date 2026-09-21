import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/subject.dart';
import '../main.dart';

class ResultsScreen extends StatefulWidget {
  final Subject subject;
  final String chapterTitle;
  final int score;
  final int totalQuestions;

  const ResultsScreen({
    super.key,
    required this.subject,
    required this.chapterTitle,
    required this.score,
    required this.totalQuestions,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimController;
  late AnimationController _cardsAnimController;
  late Animation<double> _scoreAnimation;

  double get _percentage => (widget.score / widget.totalQuestions) * 100;

  String get _grade {
    if (_percentage >= 80) return 'A';
    if (_percentage >= 60) return 'B';
    if (_percentage >= 40) return 'C';
    return 'F';
  }

  String get _message {
    if (_percentage >= 80) return 'Excellent! You nailed it! 🎉';
    if (_percentage >= 60) return 'Great job! Keep it up! 💪';
    if (_percentage >= 40) return 'Good effort! Study a bit more! 📚';
    return 'Keep trying! Practice makes perfect! 🌟';
  }

  String get _emoji {
    if (_percentage >= 80) return '🏆';
    if (_percentage >= 60) return '⭐';
    if (_percentage >= 40) return '📖';
    return '💡';
  }

  Color get _gradeColor {
    if (_percentage >= 80) return const Color(0xFF2ECC71);
    if (_percentage >= 60) return const Color(0xFF3498DB);
    if (_percentage >= 40) return const Color(0xFFF39C12);
    return const Color(0xFFE74C3C);
  }

  @override
  void initState() {
    super.initState();
    _scoreAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _cardsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scoreAnimation = Tween<double>(begin: 0, end: _percentage / 100)
        .animate(CurvedAnimation(
      parent: _scoreAnimController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _scoreAnimController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _cardsAnimController.forward();
    });
  }

  @override
  void dispose() {
    _scoreAnimController.dispose();
    _cardsAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: CustomScrollView(
        slivers: [
          // ── Gradient Header ──
          SliverAppBar(
            expandedHeight: 0,
            pinned: true,
            backgroundColor: _gradeColor,
            automaticallyImplyLeading: false,
            title: Text(
              'Quiz Results',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Score Hero Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _gradeColor,
                        _gradeColor.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -20,
                        right: -10,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            _emoji,
                            style: const TextStyle(fontSize: 48),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.chapterTitle,
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Animated circular progress
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: AnimatedBuilder(
                              animation: _scoreAnimation,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: _ScoreRingPainter(
                                    progress: _scoreAnimation.value,
                                    color: Colors.white,
                                    bgColor:
                                        Colors.white.withValues(alpha: 0.2),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${(_scoreAnimation.value * 100).toInt()}%',
                                          style: GoogleFonts.inter(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '${widget.score}/${widget.totalQuestions}',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Grade badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              'Grade $_grade',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Results Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Message card
                      FadeTransition(
                        opacity: _cardsAnimController,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _cardsAnimController,
                            curve: Curves.easeOutCubic,
                          )),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.cardDark,
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.white.withValues(alpha: 0.06)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _message,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    color: AppColors.textPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color:
                                        _gradeColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _percentage >= 60
                                            ? Icons.emoji_events_rounded
                                            : Icons.trending_up_rounded,
                                        color: _gradeColor,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _percentage >= 60
                                            ? 'Well Done!'
                                            : 'Keep Learning!',
                                        style: GoogleFonts.inter(
                                          color: _gradeColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Detail cards
                      ..._buildDetailCards(),
                      const SizedBox(height: 28),
                      // Action buttons
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          icon: const Icon(Icons.home_rounded, size: 22),
                          label: Text(
                            'Back to Home',
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon:
                              const Icon(Icons.replay_rounded, size: 20),
                          label: Text(
                            'Retake Quiz',
                            style: GoogleFonts.inter(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(
                                color:
                                    AppColors.primary.withValues(alpha: 0.4)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '📤 Results shared!',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500),
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                                backgroundColor: AppColors.dark,
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          },
                          icon: const Icon(Icons.share_rounded, size: 20),
                          label: Text(
                            'Share Result',
                            style: GoogleFonts.inter(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2ECC71),
                            side: const BorderSide(
                                color: Color(0xFFB5EAC9)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDetailCards() {
    final details = [
      {
        'icon': Icons.school_rounded,
        'color': const Color(0xFF4A90D9),
        'title': 'Subject',
        'value': widget.subject.name,
      },
      {
        'icon': Icons.quiz_rounded,
        'color': AppColors.primary,
        'title': 'Questions',
        'value': '${widget.score} / ${widget.totalQuestions} correct',
      },
      {
        'icon': Icons.trending_up_rounded,
        'color': _gradeColor,
        'title': 'Percentage',
        'value': '${_percentage.toStringAsFixed(0)}%',
      },
    ];

    return details.asMap().entries.map((entry) {
      final index = entry.key;
      final detail = entry.value;
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: _cardsAnimController,
          curve: Interval(
            (index * 0.15 + 0.2).clamp(0.0, 0.7),
            ((index * 0.15) + 0.6).clamp(0.0, 1.0),
          ),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _cardsAnimController,
            curve: Interval(
              (index * 0.15 + 0.2).clamp(0.0, 0.7),
              ((index * 0.15) + 0.6).clamp(0.0, 1.0),
              curve: Curves.easeOutCubic,
            ),
          )),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (detail['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(detail['icon'] as IconData,
                      color: detail['color'] as Color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail['title'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        detail['value'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}

// ─── Score Ring Painter ────────────────────────────────────────
class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;

  _ScoreRingPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 10.0;

    // Background ring
    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
