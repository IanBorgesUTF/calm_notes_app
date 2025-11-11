import 'package:calm_notes_app/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  TermsPageState createState() => TermsPageState();
}

class TermsPageState extends State<TermsPage> {
  final ScrollController _scrollCtrl = ScrollController();
  double _progress = 0.0;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final max = _scrollCtrl.position.hasContentDimensions ? _scrollCtrl.position.maxScrollExtent : 0.0;
    if (max <= 0) {
      setState(() => _progress = 0.0);
      return;
    }
    final p = (_scrollCtrl.position.pixels / max).clamp(0.0, 1.0);
    setState(() => _progress = p);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('seen_welcome_v1', true);
    if (widget.onNext != null) {
      widget.onNext!();
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(Routes.createAccountPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    const termsText = '''
Termos e Condições

1. Uso do Aplicativo
Este aplicativo é fornecido "como está", sem garantias de qualquer tipo. Você é responsável pelo conteúdo que criar e armazenar no aplicativo. Utilize-o de forma responsável e mantenha cópias de segurança de suas notas, se necessário.

2. Privacidade
Suas notas são armazenadas localmente no dispositivo por padrão. Caso opte por sincronização (se disponível), os dados deverão ser transmitidos de forma segura. A implementação de sincronização, quando existir, será clara sobre qual dado é sincronizado.

3. Conteúdo
Você concorda em não usar o aplicativo para armazenar conteúdo ilegal, difamatório, violento ou que viole direitos autorais ou direitos de terceiros. O desenvolvedor não se responsabiliza por conteúdo inserido pelos usuários.

4. Alterações
Reservamos o direito de modificar estes termos a qualquer momento. Mudanças significativas serão informadas aos usuários. É responsabilidade do usuário revisar os termos periodicamente.

5. Limitação de responsabilidade
Em nenhuma circunstância o desenvolvedor será responsável por danos diretos, indiretos, especiais ou consequenciais decorrentes do uso do aplicativo.

6. Remoção de Conteúdo
O desenvolvedor reserva-se o direito de remover conteúdo que viole estes termos ou leis aplicáveis, quando houver mecanismos para tal.

7. Backup e Exportação
Recomenda-se que o usuário faça backups regulares das notas. Funcionalidades de exportação/backup podem ser adicionadas em versões futuras.

8. Contato
Para dúvidas ou solicitações, entre em contato com o responsável pelo app (adicione email/contato aqui).

Obrigado por usar o CalmNotes. Ao marcar "Li e concordo" você confirma que leu estes termos e aceita suas condições.
''';

    final canAgree = _progress >= 0.99;

    return Scaffold(
      appBar: AppBar(title: const Text('Termos e Condições')),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              minHeight: 4,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      canAgree
                          ? 'Você leu todo o texto. Agora pode marcar a caixa.'
                          : 'Role até o final para habilitar a confirmação (${(_progress * 100).toInt()}%)',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  controller: _scrollCtrl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Termos e Condições',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        termsText,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _agreed,
                        onChanged: canAgree ? (v) => setState(() => _agreed = v ?? false) : null,
                        activeColor: Colors.greenAccent,
                      ),
                      Expanded(
                        child: Text(
                          'Li e concordo com os Termos e Condições',
                          style: TextStyle(
                            color: canAgree ? Colors.white : Colors.white54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _agreed ? _handleNext : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _agreed ? Colors.greenAccent : Colors.white12,
                        foregroundColor: _agreed ? Colors.black : Colors.white60,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Próximo'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
