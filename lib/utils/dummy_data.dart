import 'package:flutter/material.dart';
import '../models/subject.dart';

List<Subject> getDummySubjects() {
  return [
    Subject(
      name: 'Mathematics',
      description: 'Explore the world of numbers, algebra, geometry, and calculus.',
      icon: '📐',
      color: const Color(0xFF4A90D9),
      chapters: [
        Chapter(
          title: 'Algebra',
          content: 'Algebra is a branch of mathematics dealing with symbols and the rules for manipulating those symbols. It is a unifying thread of almost all of mathematics.',
          quizQuestions: [
            QuizQuestion(
              question: 'What is 2x + 3 = 11? Solve for x.',
              questionType: 'text',
              options: ['x = 4', 'x = 5', 'x = 3', 'x = 7'],
              correctAnswerIndex: 0,
              explanation: '2x = 8, so x = 4.',
            ),
            QuizQuestion(
              question: 'What is the value of x² if x = 3?',
              questionType: 'radio',
              options: ['6', '9', '12', '15'],
              correctAnswerIndex: 1,
              explanation: '3² = 9.',
            ),
            QuizQuestion(
              question: 'Select all prime numbers from the list:',
              questionType: 'checkbox',
              options: ['2', '4', '5', '9'],
              correctAnswerIndex: 0,
              correctAnswerIndices: [0, 2], // 2 and 5
              explanation: '2 and 5 are prime numbers.',
            ),
          ],
        ),
        Chapter(
          title: 'Geometry',
          content: 'Geometry is the branch of mathematics concerned with the shape, size, and relative position of figures.',
          quizQuestions: [
            QuizQuestion(
              question: 'How many sides does a triangle have?',
              questionType: 'radio',
              options: ['2', '3', '4', '5'],
              correctAnswerIndex: 1,
              explanation: 'A triangle has 3 sides.',
            ),
            QuizQuestion(
              question: 'What is the area of a rectangle with length 5 and width 3?',
              questionType: 'text',
              options: ['8', '15', '16', '10'],
              correctAnswerIndex: 1,
              explanation: 'Area = length × width = 5 × 3 = 15.',
            ),
          ],
        ),
      ],
    ),
    Subject(
      name: 'Science',
      description: 'Discover the wonders of physics, chemistry, and biology.',
      icon: '🔬',
      color: const Color(0xFF2ECC71),
      chapters: [
        Chapter(
          title: 'Physics',
          content: 'Physics is the natural science that studies matter, its fundamental constituents, motion, and behavior through space and time.',
          quizQuestions: [
            QuizQuestion(
              question: 'What is the SI unit of force?',
              questionType: 'radio',
              options: ['Joule', 'Newton', 'Watt', 'Pascal'],
              correctAnswerIndex: 1,
              explanation: 'The SI unit of force is Newton.',
            ),
            QuizQuestion(
              question: 'Speed of light in vacuum is approximately:',
              questionType: 'text',
              options: ['3×10⁶ m/s', '3×10⁸ m/s', '3×10⁴ m/s', '3×10¹⁰ m/s'],
              correctAnswerIndex: 1,
              explanation: 'Speed of light = 3×10⁸ m/s.',
            ),
          ],
        ),
        Chapter(
          title: 'Chemistry',
          content: 'Chemistry is the scientific study of the properties and behavior of matter.',
          quizQuestions: [
            QuizQuestion(
              question: 'What is the chemical symbol for water?',
              questionType: 'radio',
              options: ['H₂O', 'CO₂', 'O₂', 'NaCl'],
              correctAnswerIndex: 0,
              explanation: 'Water is H₂O.',
            ),
            QuizQuestion(
              question: 'Which of these are noble gases? Select all.',
              questionType: 'checkbox',
              options: ['Helium', 'Oxygen', 'Neon', 'Argon'],
              correctAnswerIndex: 0,
              correctAnswerIndices: [0, 2, 3], // Helium, Neon, Argon
              explanation: 'Helium, Neon, and Argon are noble gases.',
            ),
          ],
        ),
      ],
    ),
    Subject(
      name: 'History',
      description: 'Journey through the past to understand the present.',
      icon: '📜',
      color: const Color(0xFF8D6E63),
      chapters: [
        Chapter(
          title: 'Ancient Civilizations',
          content: 'Ancient civilizations like Mesopotamia, Egypt, and the Indus Valley laid the foundations of modern society.',
          quizQuestions: [
            QuizQuestion(
              question: 'Which river is known as the "Cradle of Civilization"?',
              questionType: 'radio',
              options: ['Nile', 'Tigris-Euphrates', 'Indus', 'Yangtze'],
              correctAnswerIndex: 1,
              explanation: 'The Tigris-Euphrates river system is known as the cradle of civilization.',
            ),
            QuizQuestion(
              question: 'Which dynasties contributed to building the Great Wall of China? Select all.',
              questionType: 'checkbox',
              options: ['Qin', 'Tang', 'Ming', 'Han'],
              correctAnswerIndex: 0,
              correctAnswerIndices: [0, 2, 3], // Qin, Ming, Han
              explanation: 'The Qin, Ming, and Han dynasties all contributed to the Great Wall.',
            ),
          ],
        ),
        Chapter(
          title: 'Modern World',
          content: 'The modern era witnessed two world wars, the industrial revolution, and the digital age.',
          quizQuestions: [
            QuizQuestion(
              question: 'When did World War II end?',
              questionType: 'radio',
              options: ['1943', '1945', '1947', '1950'],
              correctAnswerIndex: 1,
              explanation: 'World War II ended in 1945.',
            ),
          ],
        ),
      ],
    ),
    Subject(
      name: 'English',
      description: 'Master the language of global communication.',
      icon: '📖',
      color: const Color(0xFF9B59B6),
      chapters: [
        Chapter(
          title: 'Grammar',
          content: 'Grammar is the set of structural rules governing the composition of clauses, phrases, and words in any given language.',
          quizQuestions: [
            QuizQuestion(
              question: 'Which is the correct sentence?',
              questionType: 'radio',
              options: ['He go to school.', 'He goes to school.', 'He going to school.', 'He gone to school.'],
              correctAnswerIndex: 1,
              explanation: 'Subject-verb agreement: He goes.',
            ),
            QuizQuestion(
              question: 'Choose all the adjectives in this sentence: "The tall, intelligent student won."',
              questionType: 'checkbox',
              options: ['tall', 'student', 'intelligent', 'won'],
              correctAnswerIndex: 0,
              correctAnswerIndices: [0, 2], // tall, intelligent
              explanation: 'Tall and intelligent are adjectives.',
            ),
          ],
        ),
      ],
    ),
    Subject(
      name: 'Geography',
      description: 'Understand the world around you - land, people, and places.',
      icon: '🌍',
      color: const Color(0xFF00897B),
      chapters: [
        Chapter(
          title: 'Physical Geography',
          content: 'Physical geography studies the natural features of the Earth, including landforms, climate, and ecosystems.',
          quizQuestions: [
            QuizQuestion(
              question: 'What is the largest ocean on Earth?',
              questionType: 'radio',
              options: ['Atlantic', 'Indian', 'Pacific', 'Arctic'],
              correctAnswerIndex: 2,
              explanation: 'The Pacific Ocean is the largest.',
            ),
            QuizQuestion(
              question: 'Mount Everest is located in which mountain range?',
              questionType: 'text',
              options: ['Andes', 'Alps', 'Himalayas', 'Karakoram'],
              correctAnswerIndex: 2,
              explanation: 'Mount Everest is in the Himalayas.',
            ),
          ],
        ),
      ],
    ),
  ];
}
