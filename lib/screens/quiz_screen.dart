import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/subject.dart';
import '../screens/results_screen.dart';
import '../main.dart';

class QuizScreen extends StatefulWidget {
  final Subject subject;
  final int chapterIndex;

  const QuizScreen({
    super.key,
    required this.subject,
    required this.chapterIndex,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with TickerProviderStateMixin {
  late List<QuizQuestion> _questions;
  late List<int> _userAnswers;
  late List<Set<int>> _checkboxAnswers; // For checkbox multi-select
  late List<bool> _answered;
  int _currentQuestion = 0;
  int _score = 0;
  bool _showCorrectAnswer = false;
  bool _hintsEnabled = false;
  bool _quizCompleted = false;

  late AnimationController _questionAnimController;
  late AnimationController _optionAnimController;

  @override
  void initState() {
    super.initState();
    _questions = widget.subject.chapters[widget.chapterIndex].quizQuestions;
    _userAnswers = List.filled(_questions.length, -1);
    _checkboxAnswers = List.generate(_questions.length, (_) => <int>{});
    _answered = List.filled(_questions.length, false);

    _questionAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _optionAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _questionAnimController.forward();
    _optionAnimController.forward();
  }

  @override
  void dispose() {
    _questionAnimController.dispose();
    _optionAnimController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    final question = _questions[_currentQuestion];

    if (question.questionType == 'checkbox') {
      // Toggle checkbox selection
      setState(() {
        if (_checkboxAnswers[_currentQuestion].contains(index)) {
          _checkboxAnswers[_currentQuestion].remove(index);
        } else {
          _checkboxAnswers[_currentQuestion].add(index);
        }
      });
      return;
    }

    // Radio / text — single selection
    if (_answered[_currentQuestion]) return;
    setState(() {
      _userAnswers[_currentQuestion] = index;
      _answered[_currentQuestion] = true;
      if (index == question.correctAnswerIndex) {
        _score++;
      }
      _showCorrectAnswer = true;
    });
    _showFeedbackSnackBar(index == question.correctAnswerIndex);
  }

  void _submitCheckboxAnswer() {
    final question = _questions[_currentQuestion];
    if (_answered[_currentQuestion]) return;

    final selectedSet = _checkboxAnswers[_currentQuestion];
    final correctSet = (question.correctAnswerIndices ?? [question.correctAnswerIndex]).toSet();
    final isCorrect = selectedSet.length == correctSet.length &&
        selectedSet.containsAll(correctSet);

    setState(() {
      _answered[_currentQuestion] = true;
      if (isCorrect) _score++;
      _showCorrectAnswer = true;
    });
    _showFeedbackSnackBar(isCorrect);
  }

  void _showFeedbackSnackBar(bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect ? '✅ Correct!' : '❌ Wrong!',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isCorrect ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _nextQuestion() {
    setState(() {
      _showCorrectAnswer = false;
    });
    if (_currentQuestion < _questions.length - 1) {
      _questionAnimController.reset();
      _optionAnimController.reset();
      setState(() {
        _currentQuestion++;
      });
      _questionAnimController.forward();
      _optionAnimController.forward();
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    setState(() {
      _quizCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return ResultsScreen(
        subject: widget.subject,
        chapterTitle: widget.subject.chapters[widget.chapterIndex].title,
        score: _score,
        totalQuestions: _questions.length,
      );
    }

    final question = _questions[_currentQuestion];
    final isCheckbox = question.questionType == 'checkbox';
    final progress = (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.dark,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: widget.subject.color,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
              ),
              onPressed: () => _showExitConfirmation(),
            ),
            title: Text(
              '${widget.subject.name} Quiz',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentQuestion + 1} / ${_questions.length}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Progress bar
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.subject.color,
                            widget.subject.color.withValues(alpha: 0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: widget.subject.color.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Question badge
                FadeTransition(
                  opacity: _questionAnimController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _questionAnimController,
                      curve: Curves.easeOutCubic,
                    )),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: widget.subject.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Question ${_currentQuestion + 1}',
                            style: GoogleFonts.inter(
                              color: widget.subject.color,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        if (isCheckbox) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_box_rounded,
                                    size: 14, color: Colors.amber.shade700),
                                const SizedBox(width: 4),
                                Text(
                                  'Multi-select',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.amber.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Question card
                FadeTransition(
                  opacity: _questionAnimController,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Text(
                      question.question,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Hint section
                if (_hintsEnabled &&
                    question.explanation != null &&
                    _answered[_currentQuestion])
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade900.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.shade700.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_rounded,
                            size: 20, color: Colors.amber.shade700),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            question.explanation!,
                            style: GoogleFonts.inter(
                              color: Colors.amber.shade300,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Options
                ...question.options.asMap().entries.map((entry) {
                  final optionIndex = entry.key;
                  final optionText = entry.value;

                  bool isSelected;
                  if (isCheckbox) {
                    isSelected =
                        _checkboxAnswers[_currentQuestion].contains(optionIndex);
                  } else {
                    isSelected = _userAnswers[_currentQuestion] == optionIndex;
                  }

                  final isShowCorrect =
                      _showCorrectAnswer && _answered[_currentQuestion];
                  final isCorrect = question.isCorrectAnswer(optionIndex);

                  Color bgColor = AppColors.cardDark;
                  Color borderColor = Colors.white.withValues(alpha: 0.1);
                  Color textColor = AppColors.textPrimary;

                  if (isShowCorrect && isCorrect) {
                    bgColor = const Color(0xFF1A3D2A);
                    borderColor = const Color(0xFF2ECC71);
                    textColor = const Color(0xFF6FCF97);
                  } else if (isShowCorrect && isSelected && !isCorrect) {
                    bgColor = const Color(0xFF3D1A1A);
                    borderColor = const Color(0xFFE74C3C);
                    textColor = const Color(0xFFEB5757);
                  } else if (isSelected) {
                    bgColor = widget.subject.color.withValues(alpha: 0.12);
                    borderColor = widget.subject.color;
                  }

                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.2, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _optionAnimController,
                      curve: Interval(
                        (optionIndex * 0.15).clamp(0.0, 0.6),
                        ((optionIndex * 0.15) + 0.4).clamp(0.0, 1.0),
                        curve: Curves.easeOutCubic,
                      ),
                    )),
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _optionAnimController,
                        curve: Interval(
                          (optionIndex * 0.15).clamp(0.0, 0.6),
                          ((optionIndex * 0.15) + 0.4).clamp(0.0, 1.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => _selectAnswer(optionIndex),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 16),
                            decoration: BoxDecoration(
                              color: bgColor,
                              border: Border.all(
                                color: borderColor,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                // Option letter badge
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: isCheckbox
                                        ? BoxShape.rectangle
                                        : BoxShape.circle,
                                    borderRadius: isCheckbox
                                        ? BorderRadius.circular(8)
                                        : null,
                                    color: isSelected
                                        ? widget.subject.color
                                        : Colors.white.withValues(alpha: 0.08),
                                  ),
                                  child: Center(
                                    child: isCheckbox
                                        ? Icon(
                                            isSelected
                                                ? Icons.check_rounded
                                                : Icons.crop_square_rounded,
                                            size: 18,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.white.withValues(alpha: 0.4),
                                          )
                                        : Text(
                                            String.fromCharCode(
                                                65 + optionIndex),
                                            style: GoogleFonts.inter(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.white.withValues(alpha: 0.5),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      color: textColor,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                                if (isShowCorrect && isCorrect)
                                  const Icon(Icons.check_circle_rounded,
                                      color: Color(0xFF2ECC71), size: 22),
                                if (isShowCorrect && isSelected && !isCorrect)
                                  const Icon(Icons.cancel_rounded,
                                      color: Color(0xFFE74C3C), size: 22),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                // Submit checkbox / Next button
                if (isCheckbox && !_answered[_currentQuestion])
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _checkboxAnswers[_currentQuestion].isNotEmpty
                          ? _submitCheckboxAnswer
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.subject.color,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.white.withValues(alpha: 0.08),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Submit Answer',
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                if (_answered[_currentQuestion])
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.subject.color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentQuestion == _questions.length - 1
                                ? 'Submit Quiz'
                                : 'Next Question',
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentQuestion == _questions.length - 1
                                ? Icons.check_rounded
                                : Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // Hints toggle
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_rounded,
                        color: _hintsEnabled ? Colors.amber : Colors.white.withValues(alpha: 0.3),
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hints',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Show explanations after answering',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: _hintsEnabled,
                        onChanged: (val) {
                          setState(() => _hintsEnabled = val);
                        },
                        activeTrackColor: Colors.amber,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Exit Quiz?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Your progress will be lost.',
          style: GoogleFonts.inter(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Exit', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
