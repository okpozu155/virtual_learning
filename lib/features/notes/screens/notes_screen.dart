import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/notes_service.dart';
import '../../../data/models/note_model.dart';
import '../../../data/models/slide_model.dart';
import '../../../data/repositories/slide_repository.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  static const String _customTopicValue = '__custom_topic__';

  final NotesService _notesService = NotesService();
  final SlideRepository _slideRepository = SlideRepository();

  List<NoteModel> notes = [];
  List<SlideModel> slides = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final loadedNotes = await _notesService.getNotes();
    final loadedSlides = await _slideRepository.getSlides();

    if (!mounted) return;

    setState(() {
      notes = loadedNotes;
      slides = loadedSlides;
      loading = false;
    });
  }

  Future<void> _openNoteEditor({NoteModel? note}) async {
    final matchingSlide = note == null
        ? null
        : slides.cast<SlideModel?>().firstWhere(
            (slide) => slide?.title == note.title,
            orElse: () => null,
          );

    String? selectedTopic = matchingSlide?.id;

    if (note != null && matchingSlide == null) {
      selectedTopic = _customTopicValue;
    }

    final customTopicController = TextEditingController(
      text: matchingSlide == null ? note?.title ?? '' : '',
    );
    final bodyController = TextEditingController(text: note?.body ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(note == null ? 'New Note' : 'Edit Note'),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: selectedTopic,
                      decoration: const InputDecoration(labelText: 'Topic'),
                      hint: const Text('Choose a slide topic'),
                      items: [
                        ...slides.map(
                          (slide) => DropdownMenuItem(
                            value: slide.id,
                            child: Text(
                              slide.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const DropdownMenuItem(
                          value: _customTopicValue,
                          child: Text('Other topic'),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedTopic = value;
                        });
                      },
                    ),
                    if (selectedTopic == _customTopicValue) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: customTopicController,
                        decoration: const InputDecoration(
                          labelText: 'Custom topic',
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyController,
                      decoration: const InputDecoration(
                        labelText: 'Note',
                        alignLabelWithHint: true,
                      ),
                      minLines: 5,
                      maxLines: 10,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );

    final topic = selectedTopic == _customTopicValue
        ? customTopicController.text.trim()
        : slides
                  .cast<SlideModel?>()
                  .firstWhere(
                    (slide) => slide?.id == selectedTopic,
                    orElse: () => null,
                  )
                  ?.title
                  .trim() ??
              '';
    final body = bodyController.text.trim();

    customTopicController.dispose();
    bodyController.dispose();

    if (saved != true || (topic.isEmpty && body.isEmpty)) {
      return;
    }

    final now = DateTime.now();

    await _notesService.saveNote(
      note == null
          ? NoteModel(
              id: const Uuid().v4(),
              title: topic.isEmpty ? 'Untitled Note' : topic,
              body: body,
              updatedAt: now,
            )
          : note.copyWith(
              title: topic.isEmpty ? 'Untitled Note' : topic,
              body: body,
              updatedAt: now,
            ),
    );

    await _loadNotes();
  }

  Widget _buildDatePanel() {
    final now = DateTime.now();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.today),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_formatDate(now)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNote(NoteModel note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text("Delete '${note.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await _notesService.deleteNote(note.id);
    await _loadNotes();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNoteEditor(),
        icon: const Icon(Icons.note_add),
        label: const Text('New Note'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildDatePanel();
                }

                final noteIndex = index - 1;
                if (notes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: Text('No notes yet.')),
                  );
                }

                final note = notes[noteIndex];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.sticky_note_2),
                    title: Text(note.title),
                    subtitle: Text(
                      note.body.isEmpty
                          ? 'Updated ${_formatDate(note.updatedAt)}'
                          : note.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _openNoteEditor(note: note),
                    trailing: IconButton(
                      tooltip: 'Delete Note',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteNote(note),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
