# CalmNotes

CalmNotes é um aplicativo minimalista de notas focado em escrita sem distrações e privacidade — por padrão as notas ficam somente no dispositivo. Desenvolvido em Flutter/Dart com armazenamento local via SharedPreferences.

---

## Objetivo
Prover uma experiência limpa e rápida para criar, editar e organizar notas locais com ênfase em privacidade e usabilidade simples.

---

## Estado atual (resumo)
- App funcional com fluxo: Splash → Welcome/Onboarding → Home (lista) → Editor.
- Termos e Condições implementados.
- Armazenamento local completo via SharedPreferences (serialização JSON).
- Tema com cores definidas (slate, mint, amber).
- Web PWA básico presente (web/index.html, web/manifest.json).

---

## Funcionalidades principais
- Listagem de notas (Home) com ordenação por update.
- Criar, editar e salvar notas (Editor).
- Deletar notas (swipe/Dismissible).
- Flag de privacidade (Settings) que determina comportamento de armazenamento local vs. possível sync futura.
- Onboarding/Welcome + Termos e Condições.
- Rotas centralizadas (onGenerateRoute).

---

## Arquivos e responsabilidades (principais)
- lib/main.dart — ponto de entrada; escolhe tela inicial com base em SharedPreferences.
- lib/config/routes.dart — Routes.generateRoute (mapeamento de rotas e argumentos).
- lib/theme.dart — definições de cores e ThemeData.
- lib/models/note.dart — modelo Note (id, title, content, tags, updatedAt) e (de)serialização JSON.
- lib/services/storage/storage_service.dart — StorageService:
  - Chaves: `calm_notes_v1` (lista de notas), `calm_notes_privacy_v1` (flag de privacidade).
  - Métodos: loadNotes, saveNote, deleteNote, getPrivacyFlag, setPrivacyFlag.
  - Cria nota inicial quando não há notas.
- lib/services/editor/editor_service.dart — EditorService: init, save (coordena carregamento/salvamento).
- lib/pages/splash/splash_screen.dart — Splash inicial.
- lib/pages/welcome/welcome.dart — Welcome / primeira execução.
- lib/pages/onboarding/onboarding_page.dart — Onboarding sequencial (inclui Termos).
- lib/pages/terms/terms.dart — Termos e Condições (rolável).
- lib/pages/home/home.dart — Home: lista, criar nota, deletar.
- lib/pages/editor/editor.dart — Editor: TextEditingController para título/conteúdo, indicador de privacidade.
- web/index.html, web/manifest.json — PWA básico.

---

## Armazenamento e comportamento
- Notas salvas como JSON na chave `calm_notes_v1`.
- Flag de privacidade em `calm_notes_privacy_v1` (valor booleano). Padrão: true (local).
- Não existe sincronização remota por padrão — qualquer sync deve checar a flag de privacidade.
- Ao abrir sem notas, StorageService cria uma nota exemplo para primeiro uso.

---

## Rotas (nomes usados)
- '/' ou 'home' — HomePage
- '/editor' — EditorPage (recebe arguments: {'id': noteId})
- '/settings' — SettingsPage
- '/terms' — TermsPage

Observação: ao criar nova nota, gere um id e persista antes de navegar para o editor (fluxo já implementado).

---

## Como rodar (Windows / VS Code)
1. Certifique-se de ter Flutter SDK instalado e configurado.
2. Abra um terminal no diretório do projeto:
   - flutter pub get
   - flutter run
3. Ou use o VS Code: Execute/Run > Start Debugging (F5) com um dispositivo/emulador conectado.

---

## Dependências principais
- Flutter SDK
- shared_preferences
- flutter_native_splash (configurada)
- flutter_launcher_icons (configurada)

Verifique as versões em pubspec.yaml.

---

## Observações técnicas rápidas
- Verifique a existência do componente/arquivo referido como `PopScope` em lib/pages/home/home.dart — pode ser um wrapper customizado; se não existir, substitua por WillPopScope.
- Centralize futuras lógicas de sincronização em um novo serviço (ex.: sync_service.dart) que respeite `calm_notes_privacy_v1`.
- Tests unitários não estão incluídos — sugerido gerar testes para StorageService e EditorService.

---

## Sugestões de melhorias
- Implementar tela de Settings (acesso rápido para mudar flag de privacidade).
- Adicionar busca e tags filtráveis.
- Export / backup (JSON, TXT).
- Sincronização opcional segura com autenticação (respeitar privacidade por padrão).
- Suporte a temas Light/Dark.

---

## Autor
- Ian Fernandes Borges

---

