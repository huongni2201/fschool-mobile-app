part of '../pages/create_request_page.dart';

class _AttachmentChip extends StatelessWidget {
  final PlatformFile file;
  final VoidCallback? onRemove;

  const _AttachmentChip({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: RequestsColors.canvas,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RequestsColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            color: RequestsColors.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${file.name} · ${_fileSizeLabel(file.size)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: RequestsColors.textStrong,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            tooltip: RequestsStrings.removeAttachment,
            icon: const Icon(Icons.close_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}
