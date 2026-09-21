import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../screens/quiz_screen.dart';

class DetailsScreen extends StatefulWidget {
  final Subject subject;

  const DetailsScreen({super.key, required this.subject});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentChapterIndex = 0;
  String _chapterFilter = 'All Chapters';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.subject.chapters.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentChapterIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> get _chapterTitles {
    return ['All Chapters', ...widget.subject.chapters.map((c) => c.title)];
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;
    final chapters = subject.chapters;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          subject.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: subject.color,
        foregroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          onTap: (index) {
            setState(() {
              _currentChapterIndex = index;
            });
          },
          tabs: chapters.map((chapter) => Tab(text: chapter.title)).toList(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
DropdownButtonFormField<String>(
               initialValue: _chapterFilter,
              items: _chapterTitles.map((title) {
                return DropdownMenuItem(
                  value: title,
                  child: Text(title),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _chapterFilter = val!;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Showing: $_chapterFilter'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              icon: const Icon(Icons.filter_list),
              decoration: const InputDecoration(
                labelText: 'Filter Chapters',
                prefixIcon: Icon(Icons.filter_list),
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          subject.color.withValues(alpha: 0.1),
                          subject.color.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: subject.color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                chapters[_currentChapterIndex].title[0],
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: subject.color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chapters[_currentChapterIndex].title,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: subject.color,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${chapters[_currentChapterIndex].quizQuestions.length} Questions',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(
                          chapters[_currentChapterIndex].content,
                          style: const TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: subject.color,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(14),
                      ),
                    ),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Chapter Quiz',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Test your knowledge with ${chapters[_currentChapterIndex].quizQuestions.length} questions',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chapters[_currentChapterIndex].quizQuestions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return ActionChip(
                  label: Text('Q${index + 1}'),
                  backgroundColor: Colors.grey.shade100,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Question ${index + 1}: ${question.questionType}'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showQuizConfirmation(context, subject);
                },
                icon: const Icon(Icons.quiz_rounded),
                label: const Text('Start Quiz', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: subject.color,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reading mode activated for ${chapters[_currentChapterIndex].title}'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                icon: const Icon(Icons.book_rounded),
                label: const Text('Read Aloud', style: TextStyle(fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: subject.color,
                  side: BorderSide(color: subject.color),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showQuizConfirmation(BuildContext context, Subject subject) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.school_rounded, color: subject.color, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Start Quiz?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chapter: ${widget.subject.chapters[_currentChapterIndex].title}'),
              const SizedBox(height: 8),
              Text('You will be asked ${widget.subject.chapters[_currentChapterIndex].quizQuestions.length} questions.'),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timer, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  const Text('No time limit - take your time!'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      subject: subject,
                      chapterIndex: _currentChapterIndex,
                    ),
                  ),
                );
              },
              child: const Text('Start'),
            ),
          ],
        );
      },
    );
  }
}
