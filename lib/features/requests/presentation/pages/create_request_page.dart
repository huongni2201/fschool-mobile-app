import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/widgets/main_bottom_navigation.dart';
import '../../data/models/request_display_models.dart';
import '../../domain/usecases/submit_student_request_usecase.dart';
import '../constants/requests_colors.dart';
import '../constants/requests_strings.dart';

part '../utils/create_request_helpers.dart';
part '../widgets/create_request_header.dart';
part '../widgets/request_attachment_chip.dart';
part '../widgets/selected_request_type_card.dart';

class CreateRequestPage extends StatefulWidget {
  final RequestTypeItem requestType;

  const CreateRequestPage({super.key, required this.requestType});

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  static const int _maxAttachmentBytes = 10 * 1024 * 1024;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final Map<String, TextEditingController> _fieldControllers = {};

  late final SubmitStudentRequestUseCase _submitStudentRequestUseCase;

  DateTimeRange? _dateRange;
  List<PlatformFile> _attachments = const [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _submitStudentRequestUseCase = getIt<SubmitStudentRequestUseCase>();
    _titleController.text = widget.requestType.name;

    for (final field in widget.requestType.fields) {
      final key = _fieldKey(field);

      if (key.isEmpty) continue;

      _fieldControllers[key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    for (final controller in _fieldControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2, 12, 31),
      initialDateRange: _dateRange,
      helpText: RequestsStrings.requestDateRangeLabel,
      saveText: 'Chọn',
    );

    if (picked == null || !mounted) return;

    setState(() {
      _dateRange = picked;
    });
  }

  Future<void> _pickAttachments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        withData: true,
      );

      if (result == null || !mounted) return;

      final tooLarge = result.files.any(
        (file) => file.size > _maxAttachmentBytes,
      );

      if (tooLarge) {
        _showSnackBar(RequestsStrings.attachmentTooLarge);
        return;
      }

      setState(() {
        _attachments = [..._attachments, ...result.files];
      });
    } catch (error) {
      if (!mounted) return;

      _showSnackBar(_requestErrorMessage(error));
    }
  }

  Future<void> _submitRequest() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (widget.requestType.requiresDateRange && _dateRange == null) {
      _showSnackBar(RequestsStrings.requiredDateRange);
      return;
    }

    if (widget.requestType.requiresAttachment && _attachments.isEmpty) {
      _showSnackBar(RequestsStrings.requiredAttachment);
      return;
    }

    if (_attachments.any((file) => file.path == null && file.bytes == null)) {
      _showSnackBar(RequestsStrings.attachmentMissingData);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _submitStudentRequestUseCase(
        CreateStudentRequestPayload(
          requestTypeCode: widget.requestType.code,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          startDate: _dateRange?.start,
          endDate: _dateRange?.end,
          fieldValues: _fieldValues(),
          attachments: _attachments
              .map(
                (file) => RequestAttachmentPayload(
                  name: file.name,
                  size: file.size,
                  path: file.path,
                  bytes: file.bytes,
                ),
              )
              .toList(growable: false),
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(RequestsStrings.submitSuccess)),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      _showSnackBar(_requestErrorMessage(error));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Map<String, String> _fieldValues() {
    return {
      for (final entry in _fieldControllers.entries)
        if (entry.value.text.trim().isNotEmpty)
          entry.key: entry.value.text.trim(),
    };
  }

  void _removeAttachment(PlatformFile file) {
    setState(() {
      _attachments = _attachments.where((item) => item != file).toList();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RequestsColors.canvas,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            children: [
              _CreateRequestHeader(
                onBack: _isSubmitting
                    ? null
                    : () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: 18),
              _SelectedRequestTypeCard(requestType: widget.requestType),
              const SizedBox(height: 18),
              _buildTextField(
                controller: _titleController,
                label: RequestsStrings.requestTitleLabel,
                hintText: RequestsStrings.requestTitleHint,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _contentController,
                label: RequestsStrings.requestContentLabel,
                hintText: RequestsStrings.requestContentHint,
                maxLines: 5,
              ),
              if (widget.requestType.requiresDateRange) ...[
                const SizedBox(height: 14),
                _buildDateRangeField(),
              ],
              for (final field in widget.requestType.fields) ...[
                const SizedBox(height: 14),
                _buildDynamicField(field),
              ],
              const SizedBox(height: 14),
              _buildAttachmentSection(),
              const SizedBox(height: 22),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLines = 1,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !_isSubmitting,
      maxLines: maxLines,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.trim().isEmpty
          ? RequestsStrings.requiredField
          : null,
      decoration: _fieldDecoration(label: label, hintText: hintText),
    );
  }

  Widget _buildDynamicField(RequestField field) {
    final key = _fieldKey(field);
    final controller = _fieldControllers[key];

    if (key.isEmpty || controller == null) return const SizedBox.shrink();

    return TextFormField(
      controller: controller,
      enabled: !_isSubmitting,
      maxLines: _isLongTextField(field) ? 3 : 1,
      keyboardType: _keyboardType(field),
      validator: (value) {
        if (!field.required) return null;

        return value == null || value.trim().isEmpty
            ? RequestsStrings.requiredField
            : null;
      },
      decoration: _fieldDecoration(
        label: _fieldLabel(field),
        hintText: _fieldHint(field),
      ),
    );
  }

  Widget _buildDateRangeField() {
    return Material(
      color: RequestsColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _isSubmitting ? null : _pickDateRange,
        child: InputDecorator(
          decoration: _fieldDecoration(
            label: RequestsStrings.requestDateRangeLabel,
            hintText: RequestsStrings.requestDateRangeHint,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.date_range_outlined,
                color: RequestsColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _dateRangeLabel(),
                  style: TextStyle(
                    color: _dateRange == null
                        ? RequestsColors.textMuted
                        : RequestsColors.textStrong,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RequestsColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: RequestsColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  RequestsStrings.requestAttachmentLabel,
                  style: TextStyle(
                    color: RequestsColors.textStrong,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _isSubmitting ? null : _pickAttachments,
                icon: const Icon(Icons.attach_file_rounded, size: 18),
                label: const Text(RequestsStrings.pickAttachment),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            RequestsStrings.requestAttachmentHint,
            style: TextStyle(
              color: RequestsColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          if (_attachments.isEmpty)
            const Text(
              RequestsStrings.noAttachments,
              style: TextStyle(
                color: RequestsColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            )
          else
            Column(
              children: [
                for (final file in _attachments)
                  _AttachmentChip(
                    file: file,
                    onRemove: _isSubmitting
                        ? null
                        : () => _removeAttachment(file),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: _isSubmitting ? null : _submitRequest,
        style: FilledButton.styleFrom(
          backgroundColor: RequestsColors.primary,
          foregroundColor: RequestsColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: RequestsColors.surface,
                ),
              )
            : const Text(
                RequestsStrings.submitRequest,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hintText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: RequestsColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: RequestsColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: RequestsColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: RequestsColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: RequestsColors.requestOther),
      ),
      labelStyle: const TextStyle(
        color: RequestsColors.textMuted,
        fontWeight: FontWeight.w800,
      ),
      hintStyle: const TextStyle(
        color: RequestsColors.textMuted,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  String _dateRangeLabel() {
    final range = _dateRange;

    if (range == null) return RequestsStrings.requestDateRangeHint;

    return '${_dateLabel(range.start)} - ${_dateLabel(range.end)}';
  }

  String _dateLabel(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
