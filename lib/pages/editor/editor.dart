import 'package:calm_notes_app/services/editor/editor_service.dart';
import 'package:flutter/material.dart';
import '../../models/note.dart';

class EditorPage extends StatefulWidget {
  final String? noteId;
  const EditorPage({super.key, this.noteId});

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {

    final EditorService editorService = EditorService();

  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  bool privacyLocal = true;
  Note? notes;

  

  @override
  void initState() {
    super.initState();

    notes = Note(
      id: widget.noteId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      content: '',
      tags: [],
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await editorService.init(widget.noteId, notes!, titleCtrl, contentCtrl);
      setState(() {}); 
    });
  }

  @override
  Widget build(BuildContext context) {
    if (notes == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save), 
            onPressed:() {
             editorService.save(context, notes!, titleCtrl, contentCtrl);
            }
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(controller: titleCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(border: InputBorder.none, hintText: 'Título', hintStyle: TextStyle(color: Colors.white54))),
            const Divider(color: Colors.white24),
            Expanded(
              child: TextField(
                controller: contentCtrl,
                style: const TextStyle(color: Colors.white),
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'Escreva seus lembretes...', hintStyle: TextStyle(color: Colors.white54)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
