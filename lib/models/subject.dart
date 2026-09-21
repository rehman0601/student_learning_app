import 'dart:ui';

class Subject {
  final String name;
  final String description;
  final String icon;
  final Color color;
  final List<Chapter> chapters;

  Subject({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.chapters,
  });
}

class Chapter {
  final String title;
  final String content;
  final String? image;
  final List<QuizQuestion> quizQuestions;

  Chapter({
    required this.title,
    required this.content,
    required this.quizQuestions,
    this.image,
  });
}

class QuizQuestion {
  final String question;
  final String questionType;
  final List<String> options;
  final int correctAnswerIndex;
  final List<int>? correctAnswerIndices; // For checkbox (multi-answer) questions
  final String? explanation;

  QuizQuestion({
    required this.question,
    required this.questionType,
    required this.options,
    required this.correctAnswerIndex,
    this.correctAnswerIndices,
    this.explanation,
  });

  /// Returns true if the given index is a correct answer,
  /// checking correctAnswerIndices for checkbox questions.
  bool isCorrectAnswer(int index) {
    if (questionType == 'checkbox' && correctAnswerIndices != null) {
      return correctAnswerIndices!.contains(index);
    }
    return index == correctAnswerIndex;
  }
}
