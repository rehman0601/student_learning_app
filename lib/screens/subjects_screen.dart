import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../utils/dummy_data.dart';
import '../screens/details_screen.dart';

class SubjectsScreen extends StatefulWidget {
  final Subject? selectedSubject;

  const SubjectsScreen({super.key, this.selectedSubject});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final List<Subject> _subjects = getDummySubjects();
  Subject? _selectedSubject;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedSubject = widget.selectedSubject;
  }

  List<Subject> get _filteredSubjects {
    if (_searchQuery.isEmpty) return _subjects;
    return _subjects.where((s) {
      return s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             s.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedSubject?.name ?? 'All Subjects',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _selectedSubject?.color ?? const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
                ),
              ),
              child: const Text(
                'Menu',
                style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded, color: Color(0xFF6C63FF)),
              title: const Text('Home', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedSubject = null;
                  _searchQuery = '';
                });
              },
            ),
            const Divider(height: 1),
            ..._subjects.map((subject) => ListTile(
                  leading: Text(subject.icon, style: const TextStyle(fontSize: 26)),
                  title: Text(subject.name, style: const TextStyle(fontSize: 15)),
                  selected: _selectedSubject?.name == subject.name,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedSubject = subject;
                      _searchQuery = '';
                    });
                  },
                )),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.settings_rounded, color: Colors.grey),
              title: const Text('Settings', style: TextStyle(fontSize: 15)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_searchQuery.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Searching: "$_searchQuery"',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredSubjects.length,
              itemBuilder: (context, index) {
                final subject = _filteredSubjects[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(subject: subject),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: subject.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(subject.icon, style: const TextStyle(fontSize: 28)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: subject.color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subject.description,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: subject.color.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${subject.chapters.length} Chapters',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: subject.color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    String query = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Subjects'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Search by name...'),
            onChanged: (val) {
              query = val;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _searchQuery = query;
                });
              },
              child: const Text('Search'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
