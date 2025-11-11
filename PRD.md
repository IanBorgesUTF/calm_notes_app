# PRD — CalmNotes

Versão: 1.3  
Data: 11 de novembro de 2025  
Autor: Ian Fernandes Borges

---

## 1. Visão geral
CalmNotes é um aplicativo mobile minimalista para criação e organização de notas com foco em escrita sem distrações e respeito à privacidade do usuário. O app integra autenticação segura via Supabase, gerenciamento de perfil com foto, sincronização em tempo real de notas e experiência de onboarding completa.

---

## 2. Objetivos do produto
- Experiência de escrita limpa, rápida e sem distrações.
- Autenticação segura e gerenciamento de usuários.
- Sincronização em tempo real de notas na nuvem (Supabase).
- Privacidade e segurança de dados do usuário.
- Interface minimalista com tema visual consistente.
- Aplicação leve e responsiva em dispositivos móveis.

---

## 3. Público-alvo
- Estudantes e profissionais que tomam notas rápidas.
- Usuários que priorizam segurança e sincronização na nuvem.
- Profissionais criativos que buscam ambiente de escrita focado.

---

## 4. Funcionalidades (MVP) — estado atual

### Autenticação e Conta
- **Login** — Autenticação segura via email e senha via Supabase. — Implementado.
  - Validação de email (presença de @, domínio válido).
  - Validação de senha (8+ caracteres, maiúscula, minúscula, número, caractere especial).
  - Feedback visual de erros.
  
- **Criar conta** — Registro de novos usuários. — Implementado.
  - Validação rigorosa de email e senha.
  - Campo de telefone obrigatório (8–15 dígitos).
  - Confirmação de senha.
  - Feedback de requisitos de senha em tempo real.

### Gerenciamento de Notas
- **Tela Home** — Lista de notas ordenadas por data de atualização. — Implementado.
- **Criar nota** — Nova nota com ID único gerado automaticamente. — Implementado.
- **Editar nota** — Atualizar título e conteúdo com salvamento automático. — Implementado.
- **Deletar nota** — Remover notas permanentemente (Dismissible/swipe). — Implementado.
- **Sincronização** — Dados sincronizados em tempo real com Supabase. — Implementado.

### Perfil do Usuário
- **Foto de perfil** — Upload de foto (câmera ou galeria). — Implementado.
  - Armazenamento como Base64.
  - Avatar circular na interface.
  - Opção para atualizar/remover foto.
  
- **Drawer do perfil** — Acesso rápido a informações do usuário e logout. — Implementado.
- **Logout** — Sair da conta com segurança. — Implementado.

### Onboarding e Integração
- **Splash Screen** — Tela inicial com logo do app. — Implementado.
- **Welcome Screen** — Boas-vindas para primeira execução. — Implementado.
- **Termos e Condições** — Página acessível durante onboarding. — Implementado.
- **Rotas centralizadas** — Mapeamento centralizado em `routes.dart`. — Implementado.

### Extras Planejados (Futuro)
- Busca e filtros por tags.
- Export/import de notas (JSON, PDF).
- Temas claro/escuro automático.
- Compartilhamento de notas.
- Notas com imagens anexadas.
- Sincronização offline com fila de pendências.

---

## 5. Fluxos de usuário (implementação atual)

### Fluxo — Primeira Execução
1. Splash Screen aparece (branding).
2. Welcome Screen exibido (onboarding visual).
3. Usuário aceita termos e condições (opcional).
4. Redirecionado para tela de Login.
5. Flag `seen_welcome_v1` salva em SharedPreferences.

### Fluxo — Login
1. Usuário insere email e senha.
2. Validações ocorrem em tempo real (feedback visual).
3. Ao submeter, credenciais enviadas ao Supabase.
4. Supabase autentica e retorna token de sessão.
5. Se bem-sucedido, usuário redirecionado para Home.
6. Se falhar, erro exibido via SnackBar.

### Fluxo — Criar Conta
1. Usuário insere email, senha, confirmação, telefone.
2. Validações rigorosas em tempo real.
3. Requisitos de senha exibidos visualmente.
4. Ao submeter, dados enviados ao Supabase.
5. Supabase cria usuário e retorna resposta.
6. Se bem-sucedido, usuário redirecionado para Login.
7. Se falhar, erro exibido.

### Fluxo — Criar Nota
1. Usuário toca FAB na Home.
2. Nova nota criada com ID único (UUID).
3. Editor abre com campos vazios.
4. Usuário escreve título e conteúdo.
5. Ao salvar, nota sincroniza com Supabase em tempo real.
6. Nota aparece no topo da Home com `updatedAt` atualizado.

### Fluxo — Editar Nota
1. Usuário seleciona nota existente na Home.
2. Editor carrega título e conteúdo.
3. Usuário realiza alterações.
4. Ao salvar, nota sincroniza com Supabase.
5. Lista atualiza automaticamente via Provider.

### Fluxo — Deletar Nota
1. Usuário faz swipe na nota (Dismissible).
2. Ou toca botão de delete no Editor.
3. Nota removida localmente e do Supabase.
4. Lista atualiza automaticamente.

### Fluxo — Gerenciar Perfil
1. Usuário abre Drawer (ícone de menu).
2. Visualiza foto de perfil e informações de usuário.
3. Pode selecionar "Atualizar foto":
   - Escolhe entre câmera ou galeria.
   - Foto convertida para Base64.
   - Salva no Supabase.
   - Avatar atualizado na interface.
4. Pode fazer logout (volta para Login).

---

## 6. Telas / UI (status)

| Tela | Componentes | Status |
|------|-------------|--------|
| **SplashScreen** | Logo, animação | Implementado |
| **WelcomeScreen** | Boas-vindas, botões | Implementado |
| **LoginPage** | Email, senha, botão login, link criar conta | Implementado |
| **CreateAccountPage** | Email, senha, confirmação, telefone, validações | Implementado |
| **HomePage** | Lista de notas, FAB, AppBar, Drawer | Implementado |
| **EditorPage** | Título, conteúdo, botão salvar | Implementado |
| **ProfileDrawer** | Avatar, info usuário, logout | Implementado |
| **TermsPage** | Texto de termos, botão fechar | Implementado |

### Estilo Visual
- **Tema:** Dark mode com cores slate, mint e amber
- **AppBar:** Fundo slate, texto branco
- **Botões:** Mint (primário), Amber (secundário)
- **Avatar:** Circular com bordas suaves
- **TextFields:** Borders arredondadas, validação em tempo real

---

## 7. Modelo de dados

### Note
```
id: String (UUID único)
title: String
content: String
tags: List<String> (futuro)
updatedAt: int (timestamp em ms)
userId: String (FK Supabase Auth)
createdAt: int (timestamp em ms)
```

### User (via Supabase Auth)
```
id: String (UUID)
email: String
phone: String
profilePhoto: String (Base64 ou URL)
createdAt: DateTime
```

### Storage Keys (SharedPreferences)
```
seen_welcome_v1 — boolean (onboarding visualizado)
```

### Supabase Tables
```
notes — notas do usuário autenticado
users — perfil do usuário
```

---

## 8. Requisitos não funcionais

### Plataforma
- Flutter 3.0+
- Dart 3.0+
- Android 6.0+ (API 21)
- iOS 11.0+
- Web PWA (suporte básico)

### Performance
- Listagem de notas carrega em < 500ms
- Sincronização de nota em < 2s
- UI responsiva sem travamentos
- Otimização de imagens (Base64 com limite 2MB)

### Segurança
- Autenticação via Supabase (segura, com tokens)
- Senhas validadas rigorosamente (8+ chars, maiúscula, minúscula, número, especial)
- Dados sincronizados com HTTPS
- Sem armazenamento de senhas localmente
- Logout revoga sessão do Supabase

### Resiliência
- Tratamento de erros JSON inválido
- Fallback se sincronização falhar
- Retry automático de requisições
- Mensagens de erro claras ao usuário

### Acessibilidade
- Respeitar escala de fontes do sistema
- Contraste adequado (WCAG AA)
- Labels em TextFields
- Feedback visual claro (SnackBars, ProgressIndicators)

---

## 9. Arquitetura Técnica

### State Management
- **Provider** — ChangeNotifier para gerenciar lista de notas
- **NotesProvider** — Centraliza lógica de notas (criar, editar, deletar, carregar)

### Camadas
- **Pages** — Telas da aplicação
- **Services** — Lógica de autenticação (LoginService, CreateAccountService) e perfil (ProfilePhotoService)
- **Repositories** — Acesso a dados (NotesRepository, comunicação com Supabase)
- **Providers** — State management e propagação de estado
- **Models** — Estrutura de dados (Note)
- **DTOs** — Transfer objects (NoteDTO)
- **Config** — Rotas centralizadas

### Integração Supabase
- Autenticação: `Supabase.instance.auth`
- Dados: `Supabase.instance.client` (PostgreSQL)
- Realtime: Sincronização de notas em tempo real
- RLS (Row Level Security) — Usuários acessam apenas suas próprias notas

---

## 10. Métricas de sucesso (sugestão)

- Tempo médio para criar e salvar uma nota < 5s.
- Sem perda de notas durante sincronização.
- Taxa de retenção após 7 dias > 40%.
- Login bem-sucedido em 95%+ de tentativas válidas.
- Sincronização bem-sucedida em 99%+ dos casos.
- Taxa de adoção da foto de perfil > 30% dos usuários ativos.
- Validação de email rejeita inválidos em 100% dos casos.
- Validação de senha rejeita fracas em 100% dos casos.

---

## 11. Roadmap / Milestones sugeridos

### Curto prazo (1–2 semanas)
- Confirmar fluxos de autenticação com Supabase.
- Implementar testes unitários para Services.
- Validar sincronização de notas em cenários offline.

### Médio prazo (2–6 semanas)
- Busca e filtros por tags.
- Export/import de notas (JSON).
- Tema claro/escuro automático.
- Testes de integração E2E.

### Longo prazo (6–12+ semanas)
- Compartilhamento de notas entre usuários.
- Anexar imagens em notas.
- Sincronização offline com fila de pendências.
- Analytics de uso.
- Backup automático.

---

## 12. Riscos e mitigação

| Risco | Impacto | Mitigação |
|-------|---------|-----------|
| Falha na sincronização Supabase | Alto | Implementar retry automático, fila local, notificar usuário |
| Perda de dados durante migração | Alto | Export/import antes de migrações, testes abrangentes |
| Foto de perfil muito grande | Médio | Otimizar automaticamente para máx 2MB, avisar usuário |
| Validação de email falha | Médio | Testes unitários rigorosos, regex confiável |
| Autenticação expira | Médio | Refresh automático de token, logout ao expirar |
| Concorrência de edições | Baixo | Timestamp de última edição, resolver no lado servidor |

---

## 13. Critérios de aceitação (MVP)

- ✅ Criar, editar, salvar e deletar notas sem crash.
- ✅ Notas sincronizam em tempo real com Supabase.
- ✅ Login e criação de conta funcionam com validações rigorosas.
- ✅ Foto de perfil faz upload e exibe corretamente.
- ✅ Logout revoga sessão de forma segura.
- ✅ Termos acessíveis durante onboarding.
- ✅ App builda e roda em debug/release (Android/iOS).
- ✅ Nenhuma informação sensível armazenada localmente.
- ✅ Todos os campos validam em tempo real com feedback visual.
- ✅ Mensagens de erro claras e úteis ao usuário.

---

## 14. Dependências Principais

```yaml
flutter:
  sdk: flutter

provider: ^6.0.0+
supabase_flutter: ^2.0.0+
shared_preferences: ^2.0.0+
image_picker: ^1.0.0+
```

Verifique `pubspec.yaml` para versões exatas.

---

## 15. Entregáveis

- Código fonte completo (lib/, pages/, services/, etc.)
- README atualizado com instruções de setup
- PRD documentado (este arquivo)
- Testes unitários (mínimo para Services)
- Documentação de API Supabase
- Checklist de QA para fluxos principais

---

## 16. Observações Importantes

1. **Supabase Credentials:** Presentes em `main.dart`. Em produção, usar variáveis de ambiente.
2. **RLS (Row Level Security):** Implementar policies no Supabase para garantir isolamento de dados.
3. **Foto de Perfil:** Convertida para Base64. Considerar migração para armazenamento de URL em produção.
4. **Teste de Sincronização:** Validar em conexão lenta e offline antes de release.
5. **Segurança de Senha:** Supabase usa bcrypt; senhas nunca armazenadas em texto simples.

---

**Última atualização:** 11 de novembro de 2025
