part of '../pages/profile_page.dart';

class _NotificationSettingsPage extends StatefulWidget {
  const _NotificationSettingsPage();

  @override
  State<_NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<_NotificationSettingsPage> {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  bool _academic = true;
  bool _finance = true;
  bool _request = true;
  bool _event = true;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final values = await Future.wait([
        _storage.read(key: ProfileStorageKeys.notifyAcademic),
        _storage.read(key: ProfileStorageKeys.notifyFinance),
        _storage.read(key: ProfileStorageKeys.notifyRequest),
        _storage.read(key: ProfileStorageKeys.notifyEvent),
      ]);

      if (!mounted) return;

      setState(() {
        _academic = _boolFromStorage(values[0], fallback: true);
        _finance = _boolFromStorage(values[1], fallback: true);
        _request = _boolFromStorage(values[2], fallback: true);
        _event = _boolFromStorage(values[3], fallback: true);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await Future.wait([
        _storage.write(
          key: ProfileStorageKeys.notifyAcademic,
          value: _academic.toString(),
        ),
        _storage.write(
          key: ProfileStorageKeys.notifyFinance,
          value: _finance.toString(),
        ),
        _storage.write(
          key: ProfileStorageKeys.notifyRequest,
          value: _request.toString(),
        ),
        _storage.write(
          key: ProfileStorageKeys.notifyEvent,
          value: _event.toString(),
        ),
      ]);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ProfileStrings.notificationSettingsSaved)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileDetailShell(
      title: ProfileStrings.notificationTitle,
      subtitle: ProfileStrings.notificationSettingsSubtitle,
      icon: Icons.notifications_none_rounded,
      children: [
        _InfoCard(
          children: [
            _NotificationSwitchTile(
              icon: Icons.school_outlined,
              title: ProfileStrings.academicNotification,
              description: ProfileStrings.academicNotificationDescription,
              value: _academic,
              isEnabled: !_isLoading && !_isSaving,
              onChanged: (value) => setState(() => _academic = value),
            ),
            _NotificationSwitchTile(
              icon: Icons.payments_outlined,
              title: ProfileStrings.financeNotification,
              description: ProfileStrings.financeNotificationDescription,
              value: _finance,
              isEnabled: !_isLoading && !_isSaving,
              onChanged: (value) => setState(() => _finance = value),
            ),
            _NotificationSwitchTile(
              icon: Icons.edit_document,
              title: ProfileStrings.requestNotification,
              description: ProfileStrings.requestNotificationDescription,
              value: _request,
              isEnabled: !_isLoading && !_isSaving,
              onChanged: (value) => setState(() => _request = value),
            ),
            _NotificationSwitchTile(
              icon: Icons.campaign_outlined,
              title: ProfileStrings.eventNotification,
              description: ProfileStrings.eventNotificationDescription,
              value: _event,
              isEnabled: !_isLoading && !_isSaving,
              onChanged: (value) => setState(() => _event = value),
              isLast: true,
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isLoading || _isSaving ? null : _saveSettings,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ProfileColors.surface,
                    ),
                  )
                : const Icon(Icons.save_outlined),
            label: const Text(ProfileStrings.save),
            style: FilledButton.styleFrom(
              backgroundColor: ProfileColors.primary,
              foregroundColor: ProfileColors.surface,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _boolFromStorage(String? value, {required bool fallback}) {
    if (value == null) return fallback;

    return value == ProfileStorageKeys.enabledValue;
  }
}

class _NotificationSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool value;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _NotificationSwitchTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.isEnabled,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile.adaptive(
          value: value,
          onChanged: isEnabled ? onChanged : null,
          activeThumbColor: ProfileColors.primary,
          contentPadding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
          secondary: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: ProfileColors.surfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: ProfileColors.primary, size: 21),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: ProfileColors.textStrong,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(
              color: ProfileColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 64, color: ProfileColors.divider),
      ],
    );
  }
}
