# PRD — CalmNotes (atualizado)

Versão: 1.3 — atualizações 27/11/2025  
Resumo curto: app mobile-first para criar/editar notas com sincronização em Supabase, autenticação e gerenciamento de perfil.

Objetivos do produto
- Escrita focada; sincronização confiável com Supabase; UX simples com onboarding.

Público-alvo
- Usuários móveis e PWA que precisam de um app de notas leve e privado.

MVP (status de implementação)
- Autenticação: Login e Criar conta (validadores robustos) — Implementado
- Notas: criar, editar, deletar, listar, sincronizar — Implementado
- Perfil: foto de perfil (upload/preview/remover) — Implementado
- Onboarding: Splash, Welcome, Terms — Implementado
- Suporte multiplataforma: Mobile + Web (imagens tratadas por plataforma) — Implementado (ajustes no helper de imagem)

Arquitetura técnica
- Feature‑first + Clean Architecture (presentation / domain / data)
- State management: Provider; injecção manual em main.dart
- Supabase: Auth + Postgres; RLS deve ser configurado no backend
- Image handling: File on mobile, Data URL / MemoryImage / NetworkImage on Web
- Persistência local: SharedPreferences (flags, data URLs)

Fluxos principais
- Login / Criar Conta → usecases (domain) → repository impl (data) → datasource (Supabase)
- Notas → provider chama usecases (get/upsert/delete)
- Foto de Perfil → UI faz pick/preview → provider chama usecases (save / remove)

Requisitos não funcionais
- Flutter 3.x / Dart 3.x
- Testes unitários para usecases e repos
- Performance: listagem < 500ms; sync < 2s

Roadmap curto prazo
- Filtros e busca por notas
- Backup/export (JSON)
- Testes e cobertura unitária
- Melhor tratamento de imagens (compressão/resizing)

Riscos & mitigação
- RLS/Policies podem quebrar writes → logs e mensagens claras no app
- Web: File APIs limitadas → salvar como data URL ou enviar ao backend

Critérios de aceitação
- Fluxos auth e notas estáveis sem crashes; imagem de perfil funcionando em mobile + web; Onboarding persistente.

Autor: Ian Fernandes Borges — última atualização 27/11/2025
