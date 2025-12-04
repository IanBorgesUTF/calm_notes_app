import 'package:calm_notes_app/core/image_helper.dart';
import 'package:calm_notes_app/features/notes/presentation/providers/notes_provider.dart';
import 'package:calm_notes_app/features/profile/presentation/providers/profile_photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../config/routes.dart';
import '../../../../core/theme.dart';
import '../../../profile/presentation/widgets/profile_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String? userPhotoPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().loadNotes();
      
      final profileProvider = Provider.of<ProfilePhotoProvider>(context, listen: false);
      profileProvider.loadSaved().then((_) {
        if (mounted) setState(() {});
      });

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) profileProvider.loadProfile(userId); // novo
  
    });

  }

  

  void openEditor([String? id]) {
    Navigator.of(context).pushNamed(Routes.editorPage, arguments: {'id': id});
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.watch<NotesProvider>();
    final profileProvider = Provider.of<ProfilePhotoProvider>(context);

    final notes = notesProvider.notes;
    final displayPath = profileProvider.photoPath;
    final ImageProvider? avatarImage = imageProviderFromPath(displayPath);

    return Scaffold(
      appBar: AppBar(title: const Text('CalmNotes')),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: slate),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) => Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.85,
                            child: ProfileDrawer(
                              userPhotoPath: profileProvider.photoPath,
                              onPhotoUpdated: () => profileProvider.loadSaved(),
                              onPhotoRemoved: () => profileProvider.loadSaved(),
                            ),
                          ),
                        ),
                        transitionsBuilder: (_, anim, __, child) {
                          return SlideTransition(
                            position: Tween(begin: const Offset(-1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                            child: child,
                          );
                        },
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[700],
                      backgroundImage: avatarImage,
                      child: avatarImage == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(profileProvider.userName 
                    ?? Supabase.instance.client.auth.currentUser?.email?.split('@').first
                    ?? 'Usuário',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.note, color: Colors.white),
              title: const Text('Notas', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app_outlined, color: Colors.white),
              title: const Text('Sair', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pushReplacementNamed(context, Routes.loginPage),
            ),
          ],
        ),
      ),
     body: RefreshIndicator(
      onRefresh: () async {
       await context.read<NotesProvider>().loadNotes(forceSync: true);
      },
      child: notesProvider.loading
    ? const Center(child: CircularProgressIndicator())
    : notes.isEmpty
        ? const Center(
            child: Text(
              'Nenhuma nota encontrada.\nToque no + para criar uma nova.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: notes.length,
            itemBuilder: (_, i) {
              final n = notes[i];
              return Dismissible(
                key: Key(n.id!),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  try {
                    await notesProvider.deleteNote(n.id!);
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Nota excluída')),
                    );
                  } catch (e) {
                    
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text('Erro ao excluir nota: $e')),
                    );
                  }
                },
                child: ListTile(
                  title: Text(n.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(n.tags.join(', '), style: const TextStyle(color: Colors.white70)),
                  onTap: () => openEditor(n.id),
                ),
              );
            },
          ),
     ),
           floatingActionButton: FloatingActionButton(
        backgroundColor: mint,
        child: const Icon(Icons.add),
        onPressed: () => openEditor(),
      ),

    );
  }
}
