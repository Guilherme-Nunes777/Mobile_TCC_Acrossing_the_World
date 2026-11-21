import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

/// Exibe PDFs incluídos nos assets do aplicativo.
class DocumentoPdfPage extends StatelessWidget {
  final String caminho;
  final String titulo;

  const DocumentoPdfPage({
    super.key,
    required this.caminho,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5368CE),
        foregroundColor: Colors.white,
        title: Text(
          titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: PdfViewer.asset(caminho),
    );
  }
}
