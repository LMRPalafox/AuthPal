import 'package:flutter/material.dart';

void main() {
  runApp(const AuthPalApp());
}

// ======================================================
// DATA MODELS
// ======================================================

class Story {
  final String title;
  final String tags;
  final String chapterTitle;
  final String notes;
  final String lore;

  Story({
    required this.title,
    required this.tags,
    required this.chapterTitle,
    required this.notes,
    required this.lore,
  });
}

class AuthorNote {
  final String storyTitle;
  final String chapterTitle;
  final String type;
  final String body;

  AuthorNote({
    required this.storyTitle,
    required this.chapterTitle,
    required this.type,
    required this.body,
  });
}

// ======================================================
// MAIN APP
// ======================================================

class AuthPalApp extends StatefulWidget {
  const AuthPalApp({super.key});

  @override
  State<AuthPalApp> createState() => _AuthPalAppState();
}

class _AuthPalAppState extends State<AuthPalApp> {
  final List<Story> stories = [];

  final List<AuthorNote> notes = [];

  void addStory(Story story) {
    setState(() {
      stories.add(story);
    });
  }

  void addNote(AuthorNote note) {
    setState(() {
      notes.add(note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AuthPal',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: HomePage(
        stories: stories,
        notes: notes,
        addStory: addStory,
        addNote: addNote,
      ),
    );
  }
}

// ======================================================
// HOME PAGE
// ======================================================

class HomePage extends StatefulWidget {
  final List<Story> stories;
  final List<AuthorNote> notes;
  final Function(Story) addStory;
  final Function(AuthorNote) addNote;

  const HomePage({
    super.key,
    required this.stories,
    required this.notes,
    required this.addStory,
    required this.addNote,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchType = 'Story';
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/papyrus.jpg'),
        fit: BoxFit.cover,
      ),
    ),

      child: SafeArea(
        child: Column(
          children: [

            // ==================================================
            // HEADER
            // ==================================================

            Container(
              height: 62,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                //color: Color(0xFFE6C29F),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black54,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'AuthPal',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Menu coming soon!'),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Allows the rest of the screen to scroll.
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [

                  // ==================================================
                  // STORIES SECTION
                  // ==================================================

                  Container(
                    height: 285,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      18,
                      0,
                      14,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      //color: Color(0xFFE7C29E),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stories',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _demoBook('My First Story'),

                            const SizedBox(width: 25),

                            ...widget.stories.map(
                              (story) => Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: _storyBook(story),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // MAKER'S BENCH
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      14,
                      18,
                      24,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      //color: Color(0xFF86B998),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Maker's Bench",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            Expanded(
                              child: _makerButton(
                                text: 'Make A Story',
                                icon: Icons.auto_stories,
                                onPressed: () async {
                                  final Story? newStory =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateStoryPage(),
                                    ),
                                  );

                                  if (newStory != null) {
                                    widget.addStory(newStory);
                                  }
                                },
                              ),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child: _makerButton(
                                text: 'Add A Place',
                                icon: Icons.location_on_outlined,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Place creation is not implemented yet.',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            Expanded(
                              child: _makerButton(
                                text: 'Make A Character',
                                icon: Icons.person_add_alt_1,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Character creation is not implemented yet.',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child: _makerButton(
                                text: 'Add A Note',
                                icon: Icons.note_add_outlined,
                                onPressed: () async {

                                  if (widget.stories.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Create a story first before adding a note.',
                                        ),
                                      ),
                                    );

                                    return;
                                  }

                                  final AuthorNote? newNote =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateNotePage(
                                        stories: widget.stories,
                                      ),
                                    ),
                                  );

                                  if (newNote != null) {
                                    widget.addNote(newNote);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ==================================================
                  // SEARCH SECTION
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      22,
                      18,
                      22,
                      25,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      //color: Color.fromARGB(255, 234, 198, 162),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 22),

                        Row(
                          children: [
                            const SizedBox(
                              width: 110,
                              child: Text(
                                'Search Type:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                height: 45,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(4),
                                ),

                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: searchType,
                                    isExpanded: true,

                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Story',
                                        child: Text('Story'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Note',
                                        child: Text('Note'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Character',
                                        child: Text('Character'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Place',
                                        child: Text('Place'),
                                      ),
                                    ],

                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          searchType = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            const SizedBox(
                              width: 75,
                              child: Text(
                                'Search:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Expanded(
                              child: TextField(
                                controller: searchController,

                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,

                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(4),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 105,
                            height: 50,

                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF6E8E71),

                                foregroundColor: Colors.black,

                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),
                              ),

                              onPressed: () {
                                final search =
                                    searchController.text.trim();

                                if (search.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Enter something to search.'),
                                    ),
                                  );

                                  return;
                                }

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Searching $searchType for "$search"',
                                    ),
                                  ),
                                );
                              },

                              child: const Text(
                                'Search!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      )
    );
  }

  // ==================================================
  // BOOK WIDGET
  // ==================================================

  Widget _storyBook(Story story) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Opening ${story.title}',
            ),
          ),
        );
      },

      child: SizedBox(
        width: 145,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 145,
              height: 170,

              decoration: BoxDecoration(
                color: const Color(0xFF4E6F57),

                borderRadius: BorderRadius.circular(3),

                border: const Border(
                  left: BorderSide(
                    color: Color(0xFF304839),
                    width: 10,
                  ),
                ),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(3, 3),
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.all(14),

                child: Center(
                  child: Text(
                    story.title,
                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              story.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // PLACEHOLDER BOOKS
  // ==================================================

  Widget _emptyBook(String title) {
    return SizedBox(
      width: 145,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 145,
            height: 170,

            decoration: BoxDecoration(
              color: const Color(0xFF6E8E71),

              borderRadius: BorderRadius.circular(3),

              border: const Border(
                left: BorderSide(
                  color: Color(0xFF415B45),
                  width: 10,
                ),
              ),

              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(3, 3),
                ),
              ],
            ),

            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Text(
                  title,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  Widget _demoBook(String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryOverviewPage(
              notes: widget.notes,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 145,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 145,
              height: 170,
              decoration: BoxDecoration(
                color: const Color(0xFF6E8E71),
                borderRadius: BorderRadius.circular(3),
                border: const Border(
                  left: BorderSide(
                    color: Color(0xFF415B45),
                    width: 10,
                  ),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // MAKER'S BENCH BUTTON
  // ==================================================

  Widget _makerButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 68,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE4BE9C),
          foregroundColor: Colors.black,

          elevation: 3,

          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),

        onPressed: onPressed,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              icon,
              size: 23,
            ),

            const SizedBox(width: 8),

            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// CREATE STORY PAGE
// ======================================================

class CreateStoryPage extends StatefulWidget {
  const CreateStoryPage({super.key});

  @override
  State<CreateStoryPage> createState() =>
      _CreateStoryPageState();
}

class _CreateStoryPageState
    extends State<CreateStoryPage> {
  final titleController = TextEditingController();
  final tagsController = TextEditingController();
  final chapterController = TextEditingController();
  final notesController = TextEditingController();
  final loreController = TextEditingController();

  void createStory() {
    if (titleController.text.trim().isEmpty ||
        chapterController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a story title and chapter title.',
          ),
        ),
      );

      return;
    }

    final story = Story(
      title: titleController.text.trim(),
      tags: tagsController.text.trim(),
      chapterTitle:
          chapterController.text.trim(),
      notes: notesController.text.trim(),
      lore: loreController.text.trim(),
    );

    Navigator.pop(context, story);
  }

  @override
  void dispose() {
    titleController.dispose();
    tagsController.dispose();
    chapterController.dispose();
    notesController.dispose();
    loreController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF77B999),

      appBar: AppBar(
        title: const Text('Make A Story'),
        backgroundColor: const Color(0xFFE5C19D),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              'Make A Story',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Story Title',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags',
                hintText: 'Fantasy, Sci-Fi, Mystery...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Create A Chapter',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: chapterController,
              decoration: const InputDecoration(
                labelText: 'Chapter Title',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: loreController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Lore',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: createStory,
                child: const Text(
                  'Create Story',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// CREATE NOTE PAGE
// ======================================================

class CreateNotePage extends StatefulWidget {
  final List<Story> stories;

  const CreateNotePage({
    super.key,
    required this.stories,
  });

  @override
  State<CreateNotePage> createState() =>
      _CreateNotePageState();
}

class _CreateNotePageState
    extends State<CreateNotePage> {
  String? selectedStory;
  String? selectedChapter;

  String selectedType = 'Notes';

  final bodyController = TextEditingController();

  final List<String> noteTypes = [
    'Notes',
    'To Do',
    'Lore',
    'Idea',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.stories.isNotEmpty) {
      selectedStory = widget.stories.first.title;

      selectedChapter =
          widget.stories.first.chapterTitle;
    }
  }

  void updateStory(String storyTitle) {
    final story = widget.stories.firstWhere(
      (story) => story.title == storyTitle,
    );

    setState(() {
      selectedStory = story.title;
      selectedChapter = story.chapterTitle;
    });
  }

  void createNote() {
    if (bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a note.'),
        ),
      );

      return;
    }

    final note = AuthorNote(
      storyTitle: selectedStory ?? '',
      chapterTitle: selectedChapter ?? '',
      type: selectedType,
      body: bodyController.text.trim(),
    );

    Navigator.pop(context, note);
  }

  @override
  void dispose() {
    bodyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF77B999),

      appBar: AppBar(
        title: const Text('Add A Note'),
        backgroundColor: const Color(0xFFE5C19D),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            const Text('Story:'),

            const SizedBox(height: 5),

            DropdownButtonFormField<String>(
              value: selectedStory,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),

              items: widget.stories.map((story) {
                return DropdownMenuItem(
                  value: story.title,
                  child: Text(story.title),
                );
              }).toList(),

              onChanged: (value) {
                if (value != null) {
                  updateStory(value);
                }
              },
            ),

            const SizedBox(height: 20),

            const Text('Chapter:'),

            const SizedBox(height: 5),

            TextFormField(
              readOnly: true,
              initialValue: selectedChapter,
              key: ValueKey(selectedChapter),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text('Type:'),

            const SizedBox(height: 5),

            DropdownButtonFormField<String>(
              value: selectedType,

              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),

              items: noteTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: bodyController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Body',
                hintText:
                    'Write your note here...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: createNote,
                child: const Text(
                  'Create Note',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// NOTES PAGE
// ======================================================

class NotesPage extends StatelessWidget {
  final List<AuthorNote> notes;

  const NotesPage({
    super.key,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF77B999),

      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: const Color(0xFFE5C19D),
      ),

      body: notes.isEmpty
          ? const Center(
              child: Text(
                'No notes created yet.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: notes.length,

              itemBuilder: (context, index) {
                final note = notes[index];

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 15,
                  ),

                  child: Padding(
                    padding:
                        const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          note.type,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Story: ${note.storyTitle}',
                        ),

                        Text(
                          'Chapter: ${note.chapterTitle}',
                        ),

                        const Divider(),

                        Text(note.body),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class StoryOverviewPage extends StatelessWidget {
  final List<AuthorNote> notes;

  const StoryOverviewPage({
    super.key,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/papyrus.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  border: const Border(
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.menu,
                        size: 36,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(width: 5),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My First Story',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Chapter 3',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ==================================================
              // SCROLLABLE CONTENT
              // ==================================================

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // ==============================================
                    // CHAPTER INFORMATION
                    // ==============================================

                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xAA77B899),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CHAPTER OVERVIEW
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Chapters Overview',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                const Text(
                                  'Chapter 1\n'
                                  'The Fateful Encounter',
                                  style: TextStyle(fontSize: 15),
                                ),

                                const SizedBox(height: 5),

                                const Text(
                                  'Chapter 2\n'
                                  'The Deafening Silence',
                                  style: TextStyle(fontSize: 15),
                                ),

                                const SizedBox(height: 25),

                                Center(
                                  child: _roundButton(
                                    text: 'View\nTimeline',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Timeline is planned for future implementation.',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 15),

                          // CURRENT CHAPTER IDEA
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Current Chapter\nIdea',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        'Meeting of both '
                                        'Characters at school',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                const Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        'They are trapped '
                                        'in a classroom',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 25),

                                Center(
                                  child: _roundButton(
                                    text: 'View\nNotes',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NotesPage(
                                            notes: notes,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ==================================================
                    // CHARACTERS
                    // ==================================================

                    Container(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        10,
                        20,
                        25,
                      ),
                      color: const Color(0x9977B899),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Characters',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          _characterCard(
                            icon: Icons.person,
                            name: 'Character 1',
                            description:
                                'A shy, reserved boy with dad issues.....',
                            tags: const ['MC', 'LM'],
                          ),

                          const SizedBox(height: 12),

                          _characterCard(
                            icon: Icons.person_outline,
                            name: 'Character 2',
                            description:
                                'A spiritedly, loud girl...',
                            tags: const ['MC', 'LL'],
                          ),
                        ],
                      ),
                    ),

                    // ==================================================
                    // PLACES
                    // ==================================================

                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        15,
                        20,
                        30,
                      ),
                      color: const Color(0x9977B899),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Places',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDD1B8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.landscape,
                                    size: 55,
                                    color: Color(0xFF587A65),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Story Location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
  }

  // ==================================================
  // ROUND BUTTON
  // ==================================================

  static Widget _roundButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 90,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE8BD99),
          foregroundColor: Colors.black,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==================================================
  // CHARACTER CARD
  // ==================================================

  static Widget _characterCard({
    required IconData icon,
    required String name,
    required String description,
    required List<String> tags,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFE8D6C5),
            child: Icon(
              icon,
              size: 35,
              color: Colors.black54,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name is $description',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                Wrap(
                  spacing: 8,
                  children: tags.map((tag) {
                    return Container(
                      width: 55,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      color: const Color(0xFF222222),
                      child: Text(
                        tag,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}