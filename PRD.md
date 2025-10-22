# PRD — CalmNotes

Versão: 1.1  
Data: 2025-10-22  
Autor: Ian Fernandes Borges

---

## 1. Visão geral
CalmNotes é um aplicativo mobile minimalista para criação e organização de notas com foco em escrita sem distrações e respeito à privacidade do usuário. Atualmente o app armazena notas localmente em SharedPreferences; sincronização remota não está implementada (planejada para futuras versões).

---

## 2. Objetivos do produto
- Experiência de escrita limpa e rápida.
- Privacidade por padrão (dados locais).
- Edição simples e recuperação rápida de notas.
- Aplicação leve e responsiva em dispositivos móveis.

---

## 3. Público-alvo
- Estudantes e profissionais que tomam notas rápidas.
- Usuários que priorizam privacidade e armazenamento local.

---

## 4. Funcionalidades (MVP) — estado atual
- Tela Home: lista de notas ordenadas por data de atualização. — Implementado.
- Criar nota: criar nova nota com id único e título padrão. — Implementado.
- Editar nota: atualizar título/conteúdo; salvar. — Implementado.
- Deletar nota: remover nota permanentemente (Dismissible). — Implementado.
- Configurações: flag de privacidade persistida em SharedPreferences. — Storage e flag implementados; UI de Settings pode não estar presente em todos os builds.
- Termos e Condições: página implementada e integrada ao onboarding. — Implementado.
- Armazenamento local: SharedPreferences com serialização JSON. — Implementado.
- Rotas centralizadas: onGenerateRoute. — Implementado.

Extras planejados:
- Sincronização remota opcional.
- Export/import (JSON).
- Busca e filtros por tags.

---

## 5. Fluxos de usuário (implementação atual)

Fluxo — Criar nota
1. Usuário toca FAB na Home.
2. Uma nova nota é criada localmente com id único e título padrão.
3. Editor abre; usuário edita e salva.
4. Nota aparece no topo com updatedAt atualizado.

Fluxo — Editar nota
1. Usuário abre nota existente.
2. Editor carrega título e conteúdo.
3. Ao salvar, StorageService persiste e lista é atualizada.

Fluxo — Privacidade
1. Flag de privacidade é armazenada em `calm_notes_privacy_v1` (true = local).
2. A flag é lida/escrita por StorageService/EditorService. Observação: confirmar existência de UI de Settings para toggling; se ausente, implementar SettingsPage.

Fluxo — Termos
1. Termos aparecem durante onboarding e são acessíveis via rota /terms quando disponível.

---

## 6. Telas / UI (status)
- SplashScreen — presente.
- Welcome / Onboarding — presente (inclui Termos).
- Home — lista de notas, FAB, swipe-to-delete — presente.
- Editor — campos de título/conteúdo, indicador de privacidade, salvar — presente.
- Settings — rota definida em routes; implementação da tela pode estar pendente (verificar lib/pages/settings).
- Terms — presente.

Estilo: tema com cores slate, mint e amber conforme lib/theme.dart.

---

## 7. Modelo de dados
Note
- id: String (único)
- title: String
- content: String
- tags: List<String>
- updatedAt: int (timestamp em ms)

Storage keys
- calm_notes_v1 — JSON array de notas
- calm_notes_privacy_v1 — boolean (true = local)

---

## 8. Requisitos não funcionais
- Plataforma: Flutter (iOS e Android, web PWA básico presente).
- Performance: lista deve carregar rapidamente; projetado para volumes pequenos (SharedPreferences).
- Resiliência: tratamento para JSON inválido e fallback (nota inicial criada se necessário).
- Privacidade: dados locais por padrão; nenhuma sincronização remota ativa.
- Acessibilidade: respeitar escala de fontes do sistema.

---

## 9. Métricas de sucesso (sugestão)
- Tempo médio para criar e salvar uma nota < 10s.
- Sem perda de notas em uso normal.
- Flag de privacidade persiste entre reinícios.

---

## 10. Roadmap / Milestones sugeridos
- Curto prazo (1–2 semanas): confirmar/implementar Settings UI; adicionar testes unitários para StorageService e EditorService.
- Médio prazo (2–6 semanas): adicionar busca, tags filtráveis, export/import.
- Longo prazo (6–12+ semanas): sincronização remota opcional com autenticação e backup seguro.

---

## 11. Riscos e mitigação
- Uso de SharedPreferences para muitos itens — Mitigação: migrar para SQLite/Hive se o volume aumentar.
- UI para alterar flag de privacidade ausente — Mitigação: adicionar SettingsPage e testes.
- Perda de dados durante migração — Mitigação: export/import e backup antes de migrações.

---

## 12. Critérios de aceitação (MVP)
- Criar, editar, salvar e deletar notas localmente sem crash.
- Lista atualiza imediatamente após salvar.
- Flag de privacidade lê/escreve corretamente em SharedPreferences.
- Termos acessíveis a partir do fluxo de onboarding ou Settings.
- Projeto builda e roda em debug/release (Android/iOS).

---

## 13. Entregáveis
- Código fonte com telas e serviços implementados.
- README e PRD atualizados.
- Testes unitários recomendados para StorageService/EditorService.
- Checklist de QA para fluxos principais.

---
