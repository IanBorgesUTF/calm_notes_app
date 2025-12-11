import 'package:calm_notes_app/core/image_helper.dart';
import 'package:calm_notes_app/features/notes/presentation/providers/notes_provider.dart';
import 'package:calm_notes_app/features/profile/presentation/providers/profile_photo_provider.dart';
import 'package:calm_notes_app/features/theme/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../config/routes.dart';
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
      if (userId != null) profileProvider.loadProfile(userId);
    });
  }

  void openEditor([String? id]) {
    Navigator.of(context).pushNamed(Routes.editorPage, arguments: {'id': id});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                         
    final colors = theme.colorScheme;                        

    final notesProvider = context.watch<NotesProvider>();
    final profileProvider = Provider.of<ProfilePhotoProvider>(context);

    final notes = notesProvider.notes;
    final displayPath = profileProvider.photoPath;
    final ImageProvider? avatarImage = imageProviderFromPath(displayPath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CalmNotes'),
      ),

      drawer: Drawer(
        backgroundColor: colors.surface,                  
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: colors.primaryContainer,              
              ),
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
                            position: Tween(
                              begin: const Offset(-1, 0), 
                              end: Offset.zero
                            ).animate(CurvedAnimation(
                              parent: anim, curve: Curves.easeOut)),
                            child: child,
                          );
                        },
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[700],  
                      backgroundImage: avatarImage,
                      child: avatarImage == null
                        ? Icon(Icons.person, size: 60, color: colors.onSecondaryContainer)
                        : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profileProvider.userName 
                      ?? Supabase.instance.client.auth.currentUser?.email?.split('@').first
                      ?? 'Usuário',
                    style: TextStyle(color: colors.onPrimaryContainer), 
                  ),
                ],
              ),
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return SwitchListTile(
                  title: Text('Tema escuro', style: TextStyle(color: colors.onSurface)),
                  value: themeProvider.themeMode == ThemeMode.dark,
                  activeThumbColor: colors.primary,
                  inactiveThumbColor: colors.outline,
                  onChanged: (_) => themeProvider.toggleTheme(),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.note, color: colors.onSurface),     
              title: Text('Notas', style: TextStyle(color: colors.onSurface)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_outlined, color: colors.error),  
              title: Text('Sair', style: TextStyle(color: colors.error)),
              onTap: () => Navigator.pushReplacementNamed(context, Routes.loginPage),
            ),
          ],
        ),
      ),

      body: RefreshIndicator(
        color: colors.primary,                                      
        onRefresh: () async {
          await context.read<NotesProvider>().loadNotes(forceSync: true);
        },
        child: notesProvider.loading
          ? Center(child: CircularProgressIndicator(color: colors.primary)) 
          : notes.isEmpty
            ? Center(
                child: Text(
                  'Nenhuma nota encontrada.\nToque no + para criar uma nova.',
                  style: TextStyle(color: colors.onSurface),
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
                      color: colors.error,
                      child: Icon(Icons.delete, color: colors.onError),
                    ),
                    onDismissed: (_) async {
                      final sm = ScaffoldMessenger.of(context);
                      try {
                        await notesProvider.deleteNote(n.id!);
                        sm.showSnackBar(
                          SnackBar(content: Text('Nota excluída')),
                        );
                      } catch (e) {
                        sm.showSnackBar(
                          SnackBar(content: Text('Erro ao excluir nota: $e')),
                        );
                      }
                    },
                    child: ListTile(
                      title: Text(n.title, style: TextStyle(color: colors.onSurface)),
                      subtitle: Text(n.tags.join(', '), style: TextStyle(color: colors.onSurfaceVariant)),
                      onTap: () => openEditor(n.id),
                    ),
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.primary,                      
        foregroundColor: colors.onPrimary,                    
        child: const Icon(Icons.add),
        onPressed: () => openEditor(),
      ),
    );
  }
}
