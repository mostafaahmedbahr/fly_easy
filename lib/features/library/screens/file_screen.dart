import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({Key? key, required this.filePath, required this.fileName})
      : super(key: key);
  final String filePath;
  final String fileName;

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pdfViewerController.dispose();
  }

  OverlayEntry? _overlayEntry;

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 60,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () {
              Clipboard.setData(
                   ClipboardData(text: details.selectedText??''));
              _pdfViewerController.clearSelection();
            },
            child: const Text(
              'Copy',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
    overlayState.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SfPdfViewer.file(
        File(widget.filePath),
        canShowScrollHead: false,
        canShowScrollStatus: false,
        canShowPaginationDialog: true,
        onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
          if (details.selectedText == null && _overlayEntry != null) {
            _overlayEntry?.remove();
            _overlayEntry = null;
          } else if (details.selectedText != null && _overlayEntry == null) {
            _showContextMenu(context, details);
          }
        },
        controller: _pdfViewerController,
        interactionMode: PdfInteractionMode.selection,

      ),
    ));
  }
}
