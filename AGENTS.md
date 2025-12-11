# CALM_NOTES_AGENTS.md

## Avisos, deprecações e boas práticas – CalmNotes

### Contexto geral

O CalmNotes é um aplicativo de notas com persistência local (JSON), suporte a inventário, sincronização futura, tema claro/escuro, editor de notas, gerenciamento de usuário e foto de perfil. Durante o desenvolvimento, diversos avisos, deprecações e melhorias de boas práticas foram identificados, especialmente relacionados a Flutter, Dart, temas, persistência e código estruturado.

---

## 1. Tema e interface

**Problema / Aviso:**

* O app precisava suportar tema claro/escuro alternável manualmente (ícone sol/lua) e iniciar conforme tema do sistema.
* Algumas cores eram fixas (ex.: branco), sem respeitar `Theme.of(context)` ou `colorScheme`.

**Solução / Boas práticas:**

* Usar `ThemeMode.system` no `MaterialApp` para respeitar o tema do sistema.
* Alternar manualmente entre `ThemeMode.light` e `ThemeMode.dark` via ícone, armazenando preferência em `SharedPreferences`.
* Todas as cores de texto, ícones, botões e progress indicators devem usar `Theme.of(context).colorScheme`.
* Substituir `color.withOpacity(x)` por `color.withAlpha((x*255).round())` ou `.withValues()` se disponível.

**Checklist:**

* [x] Todas as páginas (`LoginPage`, `EditorPage`, `ProfileDrawer`) usando `Theme.of(context)`.
* [x] Ícone de tema funcionando.
* [x] App inicia conforme tema do sistema.

---

## 2. Salvamento de notas e persistência

**Problema / Aviso:**

* Salvar notas sem título ou conteúdo poderia gerar notas inválidas ou navegação inesperada.
* Persistência JSON precisava atualizar notas existentes corretamente.

**Solução / Boas práticas:**

* Ao salvar, se título e conteúdo estiverem vazios, descartar a nota.
* Sempre atualizar `updatedAt` ao salvar ou editar nota.
* Encapsular persistência em métodos privados e tratar erros com try/catch e `SnackBar`.
* Reutilizar DAOs existentes em vez de criar novos wrappers desnecessários.

---

## 3. Foto de perfil

**Problema / Aviso:**

* Preview de foto precisava confirmar antes de salvar, diferindo entre Web e Mobile.
* Uso de `Image.file` e `MemoryImage` precisava respeitar tema.

**Solução / Boas práticas:**

* Preview deve usar cores do tema.
* Botões de confirmação/cancelar consistentes e visíveis em ambos os temas.
* Encapsular operações de pick/save/remove com `notifyListeners()` e try/catch.
* Diferenciar comportamento entre Web e Mobile corretamente.

---

## 4. Comandos de depuração e Dart/Flutter

**Problema / Aviso:**

* Mensagem: `"Deprecated. Use 'dart run' instead"` em scripts ou CI.

**Solução / Boas práticas:**

* Substituir `flutter pub run <package>` por `dart run <package>`.
* CI: executar `flutter pub get` ou `dart pub get` antes de `dart run`.
* Atualizar scripts, Makefiles e workflows do GitHub Actions.

**Exemplo GitHub Actions:**

```yaml
steps:
  - uses: actions/checkout@v3
  - uses: subosito/flutter-action@v2
    with:
      flutter-version: 'stable'
  - name: Install dependencies
    run: flutter pub get
  - name: Run icon generator
    run: dart run flutter_launcher_icons:main
```

---

## 5. Construtores modernos (`super.key`)

**Aviso:**

* Flutter analisa construtores com `Key? key` e recomenda `super.key`.

**Solução / Boas práticas:**

* Substituir `const Foo({Key? key}) : super(key: key);` por `const Foo({super.key});`.

---

## 6. Material 3 / ColorScheme

**Aviso / Problema:**

* Uso de `colorScheme.onBackground` depreciado, sugerido usar `onSurface`.

**Solução / Boas práticas:**

* Trocar `onBackground` por `onSurface` ou `onSurfaceVariant` conforme contexto.
* Revisar contraste visual em todas as telas.

---

## 7. Código e estilo

**Boas práticas:**

* Sempre usar chaves `{}` em if/else, mesmo para uma linha.
* Constantes privadas: `_lowerCamelCase`.
* Encapsular IO e tratar erros com try/catch.
* Preferir `super.key` em widgets.

---

## 8. Banco de dados (`sqls/`)

**Aviso / Boas práticas:**

* Scripts SQL na pasta `sqls/` são fonte de verdade para tabelas e índices.
* Reutilizar DAOs existentes e garantir filtros de sincronização (`updated_at > :last_sync`).

---

## 9. Testes e `@visibleForTesting`

**Problema:**

* `SharedPreferences.setMockInitialValues` fora de `test/` gera warning.

**Solução:**

```dart
// ignore: invalid_use_of_visible_for_testing_member
SharedPreferences.setMockInitialValues({});
```

---

### Conclusão

Seguindo essas práticas, o CalmNotes mantém:

* Consistência de tema e cores.
* Persistência robusta de notas e perfil.
* Conformidade com Material 3 e lints modernos.
* Scripts de CI atualizados e compatíveis com Dart/Flutter modernos.
* Código limpo, seguro e fácil de manter.

---

Se quiser, é possível **gerar um script de verificação automática** que detecta usos de cores fixas, `.withOpacity()`, `onBackground`, `super.key` e comandos deprecados para aplicar correções automaticamente.
