part of '../pages/parent_home_page.dart';

class _TeacherContactCard extends StatelessWidget {
  final ParentStudent student;
  final VoidCallback onMessage;
  final VoidCallback onCall;

  const _TeacherContactCard({
    required this.student,
    required this.onMessage,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final contact = student.teacherContact;

    return _ParentInfoCard(
      title: ParentHomeStrings.contactTitle,
      child: contact.hasAny
          ? Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEFE5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: AppColors.homeOrange,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name.isEmpty ? contact.role : contact.name,
                        style: const TextStyle(
                          color: ParentHomeColors.ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact.name.isEmpty
                            ? '${ParentHomeStrings.classLabel} ${student.className}'
                            : '${contact.role} - ${ParentHomeStrings.classLabel} ${student.className}',
                        style: const TextStyle(
                          color: ParentHomeColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: contact.email == null ? null : onMessage,
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  color: ParentHomeColors.blue,
                ),
                IconButton(
                  onPressed: contact.phone == null ? null : onCall,
                  icon: const Icon(Icons.phone_outlined),
                  color: ParentHomeColors.green,
                ),
              ],
            )
          : const _EmptyInfoContent(
              icon: Icons.person_search_outlined,
              title: ParentHomeStrings.noTeacherTitle,
              message: ParentHomeStrings.noTeacherMessage,
            ),
    );
  }
}
