abstract final class ParentHomeStrings {
  static const String greetingFallback = 'Xin chào phụ huynh';
  static const String subtitle = 'Đồng hành cùng con mỗi ngày';
  static const String quickSectionTitle = 'Theo dõi nhanh';
  static const String allActions = 'Tất cả';
  static const String attentionTitle = 'Cần phụ huynh lưu ý';
  static const String contactTitle = 'Liên hệ nhà trường';
  static const String noTeacherTitle = 'Chưa có thông tin giáo viên';
  static const String noTeacherMessage =
      'Nhà trường chưa cập nhật giáo viên chủ nhiệm cho học sinh này.';
  static const String emptyAlertsTitle = 'Chưa có lưu ý mới';
  static const String emptyAlertsMessage =
      'Các cảnh báo học tập và học phí sẽ hiển thị tại đây.';
  static const String emptyStudentsTitle = 'Chưa có học sinh liên kết';
  static const String emptyStudentsMessage =
      'Tài khoản phụ huynh chưa được liên kết với hồ sơ học sinh nào.';
  static const String loadFailedTitle = 'Chưa tải được trang phụ huynh';
  static const String loadFailedMessage =
      'Không thể tải dữ liệu phụ huynh. Vui lòng thử lại.';
  static const String reload = 'Tải lại';
  static const String logoutAndLoginAgain = 'Đăng xuất và đăng nhập lại';
  static const String refreshFailed = 'Không thể làm mới dữ liệu';
  static const String sessionExpired =
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
  static const String connectionError =
      'Không thể kết nối đến máy chủ. Kiểm tra mạng hoặc địa chỉ API.';
  static const String featureInProgress = 'đang được phát triển';
  static const String classLabel = 'Lớp';
  static const String nextLessonLabel = 'Tiết tiếp theo';
  static const String gradeAverage = 'Điểm TB';
  static const String tuition = 'Học phí';
  static const String grades = 'Điểm số';
  static const String gradesSubtitle = 'Kết quả học tập';
  static const String tuitionSubtitle = 'Khoản thu cần đóng';
  static const String requests = 'Đơn từ';
  static const String requestsSubtitle = 'Xin nghỉ, xác nhận';
  static const String timetable = 'Thời khóa biểu';
  static const String timetableSubtitle = 'Lịch học trong tuần';
  static const String notifications = 'Thông báo';
  static const String notificationsSubtitle = 'Tin từ nhà trường';

  static String greeting(String? parentName) {
    final trimmedName = parentName?.trim();

    if (trimmedName == null || trimmedName.isEmpty) {
      return greetingFallback;
    }

    return 'Xin chào $trimmedName';
  }

  static String comingSoon(String featureName) {
    return '$featureName $featureInProgress';
  }
}
