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
  final String? explanation;

  QuizQuestion({
    required this.question,
    required this.questionType,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });
}
