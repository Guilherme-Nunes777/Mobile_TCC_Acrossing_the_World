import 'package:web/web.dart' as web;

/// Inicia o download de um PDF empacotado como asset do Flutter Web.
void baixarPdfWeb(String caminho, String nomeArquivo) {
  final url = Uri.base.resolve('assets/$caminho').toString();
  final link = web.HTMLAnchorElement()
    ..href = url
    ..download = nomeArquivo;
  web.document.body?.append(link);
  link.click();
  link.remove();
}
