# CalmNotes

Um aplicativo minimalista de notas com autenticação, gerenciamento de perfil e armazenamento em nuvem via Supabase. Desenvolvido em Flutter/Dart com foco em privacidade, usabilidade e experiência limpa de escrita.

---

## 📋 Visão Geral

CalmNotes oferece uma experiência intuitiva para criar, editar, organizar e sincronizar notas na nuvem. O app combina autenticação segura, gerenciamento de perfil do usuário e armazenamento persistente via Supabase.

---

## ✨ Funcionalidades Principais

### Autenticação
- **Login** — Autenticação segura via email e senha
  - Validação de email (presença de @, domínio válido)
  - Validação de senha robusta (8+ caracteres, maiúscula, minúscula, número, caractere especial)
- **Criar conta** — Registro de novos usuários
  - Validação de email, senha com regras rigorosas
  - Confirmação de senha
  - Campo de telefone obrigatório
  - Feedback visual de requisitos de senha

### Gerenciamento de Notas
- **Listagem (Home)** — Visualizar todas as notas ordenadas por data de atualização
- **Criar nota** — Nova nota com ID único gerado automaticamente
- **Editar nota** — Atualizar título e conteúdo com salvamento automático
- **Deletar nota** — Remover notas permanentemente (swipe ou botão)
- **Sincronização** — Dados sincronizados em tempo real com Supabase

### Perfil do Usuário
- **Foto de perfil** — Upload de foto (câmera ou galeria)
  - Armazenamento como Base64
  - Avatar circular visualizado na navegação
  - Opção para atualizar/remover foto
- **Drawer do perfil** — Acesso rápido a informações do usuário
- **Logout** — Sair da conta com segurança

### Onboarding
- **Splash Screen** — Tela inicial com logo do app
- **Welcome** — Boas-vindas para primeira execução
- **Termos e Condições** — Página de termos acessível

---

## 🏗️ Arquitetura do Projeto

### Estrutura de Pastas
```
lib/
├── main.dart                          # Ponto de entrada do app
├── theme.dart                         # Definições de cores e tema
├── config/
│   └── routes.dart                    # Mapeamento centralizado de rotas
├── models/
│   └── note.dart                      # Modelo de dados Note
├── dto/
│   └── note/
│       └── note_dto.dart              # DTO para transferência de dados
├── pages/
│   ├── splash/
│   │   └── splash_screen.dart         # Tela de splash inicial
│   ├── welcome/
│   │   └── welcome.dart               # Tela de boas-vindas
│   ├── onboarding/                    # Fluxo de onboarding
│   ├── login/
│   │   └── login_page.dart            # Tela de login
│   ├── create_account/
│   │   └── create_account_page.dart   # Tela de criar conta
│   ├── home/
│   │   └── home.dart                  # Tela principal (lista de notas)
│   ├── editor/
│   │   └── editor_page.dart           # Editor de notas
│   ├── terms/
│   │   └── terms.dart                 # Termos e condições
│   └── profile_drawer/
│       └── profile_drawer.dart        # Drawer com informações do perfil
├── services/
│   ├── login/
│   │   └── login_service.dart         # Lógica de autenticação
│   ├── create_account/
│   │   └── create_account_service.dart # Lógica de registro
│   └── profile_photo/
│       └── profile_photo_service.dart # Gerenciamento de foto de perfil
├── repositories/
│   └── notes/
│       └── notes_repository.dart      # Acesso a dados de notas (Supabase)
└── providers/
    └── notes/
        └── notes_provider.dart        # State management com ChangeNotifier
```

---

## 🔧 Tecnologias e Dependências

### Stack Principal
- **Flutter** — Framework UI multiplataforma
- **Dart** — Linguagem de programação
- **Provider** — Gerenciamento de estado
- **Supabase** — Backend e autenticação na nuvem

### Dependências Principais
```yaml
flutter:
  sdk: flutter
provider: ^6.0.0+
supabase_flutter: ^2.0.0+
shared_preferences: ^2.0.0+
```

Verifique versões exatas em `pubspec.yaml`.

---

## 🎨 Design e Tema

### Paleta de Cores
- **Slate** (`#1F2937`) — Fundo e elementos primários
- **Mint** (`#10B981`) — Ações e destaques principais
- **Amber** (`#F59E0B`) — Ações secundárias e alertas

### Componentes UI
- AppBar personalizada com tema escuro
- Buttons com bordas arredondadas e feedback visual
- TextFields com validação em tempo real
- Avatar circular para foto de perfil
- Drawer para acesso rápido ao perfil
- FAB para criar notas

---

## 🔐 Autenticação e Segurança

### Fluxo de Autenticação
1. Usuário acessa Login ou Criar Conta
2. Credenciais validadas localmente e enviadas ao Supabase
3. Supabase autentica e retorna token de sessão
4. Usuário autenticado é redirecionado para Home
5. SharedPreferences armazena flag de onboarding visualizado

### Validações de Segurança

**Email:**
- Presença de @
- Domínio válido (contém .)
- Formato padrão de email

**Senha (requisitos rigorosos):**
- Mínimo 8 caracteres
- Pelo menos 1 letra maiúscula
- Pelo menos 1 letra minúscula
- Pelo menos 1 número
- Pelo menos 1 caractere especial

**Telefone:**
- 8–15 dígitos
- Suporta formatos: +55 11 99988-7777 ou variações

---

## 💾 Armazenamento e Sincronização

### Dados na Nuvem (Supabase)
- **Notas** — Sincronizadas em tempo real
- **Usuários** — Perfil com email e telefone
- **Fotos de perfil** — Armazenadas como Base64 ou URL

### Armazenamento Local (SharedPreferences)
- `seen_welcome_v1` — Flag de onboarding exibido
- Cache temporário de notas (sincronizadas com Supabase)

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos
- Flutter SDK 3.0+ instalado
- Dart 3.0+ configurado
- Emulador ou dispositivo físico conectado

### Passos
1. Clone o repositório:
   ```bash
   git clone <repositorio>
   cd calm_notes_app
   ```

2. Instale dependências:
   ```bash
   flutter pub get
   ```

3. Execute o app:
   ```bash
   flutter run
   ```

4. Ou use VS Code: Pressione **F5** (Debug) com um dispositivo/emulador conectado

### Build para Produção
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 📱 Fluxos de Usuário

### Primeira Execução
1. Splash Screen aparece
2. Welcome Screen (onboarding)
3. Termos e Condições (opcional)
4. Redirecionado para Login

### Login/Criar Conta
1. Usuário insere email, senha, telefone (criar conta)
2. Validações ocorrem em tempo real
3. Ao enviar, credenciais são verificadas no Supabase
4. Se válido, usuário autenticado → Home

### Criar Nota
1. Usuário toca FAB na Home
2. Nova nota é criada com ID único
3. Editor abre com campos vazios
4. Usuário escreve título e conteúdo
5. Salva → nota sincroniza com Supabase

### Editar Nota
1. Usuário seleciona nota existente na Home
2. Editor carrega título e conteúdo
3. Usuário faz alterações
4. Salva → nota atualizada na nuvem

### Gerenciar Perfil
1. Usuário abre Drawer (menu lateral)
2. Visualiza foto de perfil e informações
3. Pode atualizar foto (câmera ou galeria)
4. Pode fazer logout

---

## 🧪 Testes

### Testes Recomendados
- Validação de email (casos válidos e inválidos)
- Validação de senha (todos os requisitos)
- Sincronização de notas com Supabase
- Persistência de dados após reinício
- Upload de foto de perfil

Execute testes:
```bash
flutter test
```

---

## 🐛 Solução de Problemas

| Problema | Solução |
|----------|---------|
| App não conecta ao Supabase | Verifique URL e chave de API em `main.dart` |
| Notas não sincronizam | Confirme conexão de internet e permissões do app |
| Foto de perfil não carrega | Verifique permissões de câmera/galeria no dispositivo |
| Validação de email falha | Certifique-se de incluir @ e domínio válido |

---

## 📈 Roadmap Futuro

- [ ] Busca e filtros por tags
- [ ] Backup e exportação de notas (JSON, PDF)
- [ ] Tema claro/escuro automático
- [ ] Compartilhamento de notas
- [ ] Notas com imagens
- [ ] Sincronização offline com fila de pendências
- [ ] Autosave com debounce

---

## 📄 Licença

Este projeto é privado. Todos os direitos reservados.

---

## 👤 Autor

**Ian Fernandes Borges**

---

## 📞 Suporte

Para dúvidas ou sugestões, abra uma issue no repositório.

---

**Última atualização:** 11 de novembro de 2025