abstract final class TeacherHomeStrings {
  static const String greetingFallback = 'Xin chào giáo viên';
  static const String subtitle = 'Quản lý lớp học, điểm số và đơn từ';
  static const String dashboardTitle = 'Bảng điều phối giáo viên';
  static const String dashboardSubtitle =
      'Tập trung các việc cần xử lý trong ngày';
  static const String todayClasses = 'Tiết dạy hôm nay';
  static const String managedClasses = 'Lớp phụ trách';
  static const String pendingApplications = 'Đơn chờ';
  static const String quickSectionTitle = 'Nghiệp vụ nhanh';
  static const String manageGrades = 'Nhập điểm';
  static const String classList = 'Danh sách lớp';
  static const String reviewApplications = 'Duyệt đơn';
  static const String sendNotification = 'Gửi thông báo';
  static const String homeroomTitle = 'Lớp chủ nhiệm';
  static const String teachingScopeTitle = 'Phạm vi giảng dạy';
  static const String tasksTitle = 'Đầu việc cần xử lý';
  static const String notificationsTitle = 'Thông báo mới';
  static const String examsTitle = 'Lịch thi liên quan';
  static const String noTodayClassTitle = 'Hôm nay chưa có tiết dạy';
  static const String noTodayClassMessage =
      'Lịch dạy sẽ hiển thị tại đây khi nhà trường cập nhật phân công.';
  static const String noManagedClassTitle = 'Chưa có lớp phụ trách';
  static const String noManagedClassMessage =
      'Các lớp theo teaching assignment sẽ hiển thị tại đây.';
  static const String noTasksTitle = 'Không có đầu việc mới';
  static const String noTasksMessage =
      'Các đơn chờ xử lý hoặc việc cần duyệt sẽ xuất hiện ở khu vực này.';
  static const String noNotificationsTitle = 'Chưa có thông báo mới';
  static const String noNotificationsMessage =
      'Thông báo từ nhà trường hoặc lớp phụ trách sẽ hiển thị tại đây.';
  static const String noExamsTitle = 'Chưa có lịch thi liên quan';
  static const String noExamsMessage =
      'Các lịch thi theo lớp hoặc môn được phân công sẽ hiển thị tại đây.';
  static const String loadFailedTitle = 'Chưa tải được trang giáo viên';
  static const String loadFailedMessage =
      'Không thể tải dữ liệu giáo viên. Vui lòng thử lại.';
  static const String reload = 'Tải lại';
  static const String logoutAndLoginAgain = 'Đăng xuất và đăng nhập lại';
  static const String refreshFailed = 'Không thể làm mới dữ liệu';
  static const String sessionExpired =
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
  static const String connectionError =
      'Không thể kết nối đến máy chủ. Kiểm tra mạng hoặc địa chỉ API.';
  static const String featureInProgress = 'đang được phát triển';
  static const String classLabel = 'Lớp';
  static const String subjectLabel = 'Môn';
  static const String roomLabel = 'Phòng';
  static const String studentCountSuffix = 'học sinh';
  static const String unknownValue = '--';

  static String greeting(String? teacherName) {
    final trimmedName = teacherName?.trim();

    if (trimmedName == null || trimmedName.isEmpty) {
      return greetingFallback;
    }

    return 'Xin chào $trimmedName';
  }

  static String comingSoon(String featureName) {
    return '$featureName $featureInProgress';
  }
}
