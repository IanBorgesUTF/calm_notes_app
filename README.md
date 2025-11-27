# CalmNotes

Aplicativo minimalista de notas com autenticação e sincronização via Supabase. Estrutura reorganizada para Clean Architecture (feature‑first) e suporte multiplataforma (mobile + web).

Principais pontos
- Flutter + Dart
- Backend: Supabase (Auth, Postgres)
- State management: Provider (injeção manual via main.dart)
- Arquitetura: feature-first (domain / data / presentation)

Árvore simplificada (mais relevante)
```
lib/
├─ main.dart
├─ core/
│  ├─ theme.dart
│  └─ image_helper.dart     
│  └─ image_helper_io.dart     
│  └─ image_helper_web.dart     
├─ config/
│  └─ routes.dart
├─ utils/
│  └─ validators.dart
├─ features/
│  ├─ auth/
│  │  ├─ data/
│  │  │  └─ datasources/supabase_auth_datasource.dart
│  │  ├─ domain/
│  │  │  └─ usecases/{login,create_account}_usecase.dart
│  │  └─ presentation/
│  │     ├─ pages/{login,create_account}.dart
│  │     └─ providers/auth_provider.dart
│  ├─ notes/
│  │  ├─ data/
│  │  │  └─ datasources/supabase_notes_datasource.dart
│  │  ├─ domain/
│  │  │  └─ usecases/{get,upsert,delete}_notes_usecase.dart
│  │  └─ presentation/
│  │     ├─ pages/home.dart
│  │     └─ providers/notes_provider.dart
│  ├─ profile/
│  │  ├─ data/
│  │  │  └─ datasources/local_profile_photo_datasource.dart
│  │  ├─ domain/
│  │  │  └─ usecases/{get_profile,save_profile_photo,remove_profile_photo}.dart
│  │  └─ presentation/
│  │     ├─ widgets/profile_drawer.dart
│  │     └─ providers/profile_photo_provider.dart
│  └─ onboarding/
│     └─ presentation/pages/{splash,welcome,terms}.dart
```

Principais decisões e notas
- Provider é usado para injeção/estado (instância das usecases/repositories criada em main.dart).
- Dados I/O (Supabase, File system, SharedPreferences) ficam em data/datasources.
- Domain contém entidades, contratos (repositories) e usecases (um por ação).
- UI/diálogos ficam em presentation; provider só faz I/O puro (sem BuildContext).
- Image handling: FileImage em mobile/desktop; MemoryImage/NetworkImage/data URLs para web. Helper: lib/core/image_helper.dart.

Como rodar
1. flutter pub get
2. Ajuste credenciais Supabase em main.dart ou .env
3. flutter run (escolha dispositivo / web)

Contribuições / manutenção
- Mova lógica de I/O para data; regras de negócio para domain; UI para presentation.
- Atualize main.dart se alterar injeção/Providers.