part of '../pages/teacher_home_page.dart';

class _TeacherTasksCard extends StatelessWidget {
  final List<TeacherTask> tasks;
  final ValueChanged<String> onTap;

  const _TeacherTasksCard({required this.tasks, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final visibleTasks = tasks
        .where((task) => !_isBlockedTeacherTask(task))
        .take(4)
        .toList(growable: false);

    return _TeacherInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TeacherSectionHeader(title: TeacherHomeStrings.tasksTitle),
          const SizedBox(height: 10),
          if (visibleTasks.isEmpty)
            const _TeacherEmptyContent(
              icon: Icons.task_alt_rounded,
              title: TeacherHomeStrings.noTasksTitle,
              message: TeacherHomeStrings.noTasksMessage,
            )
          else
            for (var index = 0; index < visibleTasks.length; index++) ...[
              _TaskTile(
                item: visibleTasks[index],
                onTap: () => onTap(visibleTasks[index].title),
              ),
              if (index != visibleTasks.length - 1)
                const Divider(height: 18, color: TeacherHomeColors.border),
            ],
        ],
      ),
    );
  }
}

bool _isBlockedTeacherTask(TeacherTask task) {
  final value = '${task.type} ${task.title}'.toLowerCase().trim();

  return value.contains('application') ||
      value.contains('request') ||
      value.contains('pending_application') ||
      value.contains('pending_request') ||
      value.contains('đơn') ||
      value.contains('duyệt') ||
      value.contains('duyet') ||
      value.contains('send_notification') ||
      value.contains('sendnotification') ||
      value.contains('send notification') ||
      value.contains('notification_send') ||
      value.contains('gửi thông báo') ||
      value.contains('gui thong bao');
}

class _TaskTile extends StatelessWidget {
  final TeacherTask item;
  final VoidCallback onTap;

  const _TaskTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _teacherWorkColor(item.type);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(_teacherWorkIcon(item.type), color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: TeacherHomeColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (item.message.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: TeacherHomeColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (item.count > 0) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                item.count.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TeacherExamsCard extends StatelessWidget {
  final List<TeacherExam> items;

  const _TeacherExamsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return _TeacherInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TeacherSectionHeader(title: TeacherHomeStrings.examsTitle),
          const SizedBox(height: 10),
          if (items.isEmpty)
            const _TeacherEmptyContent(
              icon: Icons.event_note_outlined,
              title: TeacherHomeStrings.noExamsTitle,
              message: TeacherHomeStrings.noExamsMessage,
            )
          else
            for (var index = 0; index < items.take(3).length; index++) ...[
              _ExamTile(item: items[index]),
              if (index != items.take(3).length - 1)
                const Divider(height: 18, color: TeacherHomeColors.border),
            ],
        ],
      ),
    );
  }
}

class _ExamTile extends StatelessWidget {
  final TeacherExam item;

  const _ExamTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.event_note_outlined,
          color: TeacherHomeColors.purple,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '${item.title} · ${item.className} · ${item.dateLabel}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: TeacherHomeColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _TeacherNotificationsCard extends StatelessWidget {
  final List<TeacherNotification> items;

  const _TeacherNotificationsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return _TeacherInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TeacherSectionHeader(
            title: TeacherHomeStrings.notificationsTitle,
          ),
          const SizedBox(height: 10),
          if (items.isEmpty)
            const _TeacherEmptyContent(
              icon: Icons.campaign_outlined,
              title: TeacherHomeStrings.noNotificationsTitle,
              message: TeacherHomeStrings.noNotificationsMessage,
            )
          else
            for (var index = 0; index < items.take(3).length; index++) ...[
              _NotificationTile(item: items[index]),
              if (index != items.take(3).length - 1)
                const Divider(height: 18, color: TeacherHomeColors.border),
            ],
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final TeacherNotification item;

  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: TeacherHomeColors.purple.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.campaign_outlined,
            color: TeacherHomeColors.purple,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  color: TeacherHomeColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (item.message.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: TeacherHomeColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
