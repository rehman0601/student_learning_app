import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../screens/results_screen.dart';

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

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizQuestion> _questions;
  late List<int> _userAnswers;
  late List<bool> _answered;
  int _currentQuestion = 0;
  int _score = 0;
  bool _showCorrectAnswer = false;
  bool _hintsEnabled = false;
  bool _quizCompleted = false;

  @override
  void initState() {
    super.initState();
    _questions = widget.subject.chapters[widget.chapterIndex].quizQuestions;
    _userAnswers = List.filled(_questions.length, -1);
    _answered = List.filled(_questions.length, false);
  }

  void _selectAnswer(int index) {
    if (_answered[_currentQuestion]) return;
    setState(() {
      _userAnswers[_currentQuestion] = index;
      _answered[_currentQuestion] = true;
      if (index == _questions[_currentQuestion].correctAnswerIndex) {
        _score++;
      }
      _showCorrectAnswer = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          index == _questions[_currentQuestion].correctAnswerIndex
              ? '✅ Correct!'
              : '❌ Wrong!',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: index == _questions[_currentQuestion].correctAnswerIndex
            ? Colors.green
            : Colors.red,
      ),
    );
  }

  void _nextQuestion() {
    setState(() {
      _showCorrectAnswer = false;
    });
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    setState(() {
      _quizCompleted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Quiz complete! Score: $_score/${_questions.length}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.subject.name} - Quiz',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: widget.subject.color,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${_currentQuestion + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(_hintsEnabled ? Icons.lightbulb : Icons.lightbulb_outline),
            onPressed: () {
              setState(() {
                _hintsEnabled = !_hintsEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_hintsEnabled ? 'Hints enabled!' : 'Hints disabled!'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestion + 1) / _questions.length,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(widget.subject.color),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.subject.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Question ${_currentQuestion + 1}',
                style: TextStyle(
                  color: widget.subject.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  question.question,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_hintsEnabled && question.explanation != null && _answered[_currentQuestion])
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, size: 20, color: Colors.amber.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '💡 Hint: ${question.explanation}',
                        style: TextStyle(
                          color: Colors.amber.shade800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            ...question.options.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              final optionText = entry.value;
              final isSelected = _userAnswers[_currentQuestion] == optionIndex;
              final isShowCorrect = _showCorrectAnswer && _answered[_currentQuestion];
              final isCorrect = optionIndex == question.correctAnswerIndex;

              Color? optionColor;
              if (isShowCorrect && isCorrect) {
                optionColor = Colors.green.shade100;
              } else if (isShowCorrect && isSelected && !isCorrect) {
                optionColor = Colors.red.shade100;
              } else if (isSelected) {
                optionColor = widget.subject.color.withValues(alpha: 0.1);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => _selectAnswer(optionIndex),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: optionColor ?? Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? widget.subject.color
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? widget.subject.color
                                : Colors.grey.shade300,
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + optionIndex),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            optionText,
                            style: TextStyle(
                              fontSize: 15,
                              color: isShowCorrect && isCorrect
                                  ? Colors.green.shade800
                                  : isShowCorrect && isSelected && !isCorrect
                                      ? Colors.red.shade800
                                      : Colors.black87,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isShowCorrect && isCorrect)
                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        if (isShowCorrect && isSelected && !isCorrect)
                          const Icon(Icons.cancel, color: Colors.red, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (question.questionType == 'checkbox' && _answered[_currentQuestion])
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Colors.orange),
                    const SizedBox(width: 6),
                    Text(
                      'Select all correct answers (Checkbox question)',
                      style: TextStyle(fontSize: 13, color: Colors.orange.shade700),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _answered[_currentQuestion]
                    ? _nextQuestion
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.subject.color,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  _currentQuestion == _questions.length - 1
                      ? 'Submit Quiz'
                      : 'Next Question →',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SwitchListTile(
                  value: _hintsEnabled,
                  onChanged: (val) {
                    setState(() {
                      _hintsEnabled = val;
                    });
                  },
                  title: const Text('Hints'),
                  subtitle: const Text('Show explanations'),
                  secondary: Icon(Icons.lightbulb, color: _hintsEnabled ? Colors.amber : Colors.grey),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
