import 'package:flutter/material.dart';
import 'package:sql_notes/sql-helper/sql_helper.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = true;

  void refreshNotes() async {
    final data = await SQLHelper.getListOfItems();
    setState(() {
      _notes = data;
      _isLoading = false;
    });
  }

  _addItem() async {
    await SQLHelper.createNewNote(
        titleController.text, descriptionController.text);
    refreshNotes();
  }

  _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, titleController.text, descriptionController.text);
    refreshNotes();
  }

  _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Deleted Successfully'),
      ),
    );
    refreshNotes();
  }

  void _showNote(int? id) {
    if (id != null) {
      final existingNote = _notes.firstWhere(
        (element) => element['id'] == id,
      );
      titleController.text = existingNote['title'];
      descriptionController.text = existingNote['description'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addItem();
                  } else {
                    await _updateItem(id);
                  }
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create' : 'Update'))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.event_note_sharp,
          color: Colors.black,
        ),
        title: const Text(
          'My Notes',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.purple.shade200,
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.purple.shade100,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text('${_notes[index]['title']}'),
              subtitle: Text('${_notes[index]['description']}'),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () => _showNote(_notes[index]['id']),
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () => _deleteItem(_notes[index]['id']),
                        icon: const Icon(Icons.delete)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade200,
        onPressed: () => _showNote(null),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
