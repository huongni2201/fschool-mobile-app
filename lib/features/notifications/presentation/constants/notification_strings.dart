abstract final class NotificationStrings {
  static const String pageTitle = 'Thông báo';
  static const String pageSubtitle = 'Cập nhật mới nhất từ nhà trường';
  static const String heroTitle = 'Trung tâm thông báo';
  static const String heroSubtitle =
      'Theo dõi lịch học, điểm số, học phí và các cập nhật quan trọng.';
  static const String totalLabel = 'Tổng';
  static const String unreadLabel = 'Chưa đọc';
  static const String readLabel = 'Đã đọc';
  static const String allFilter = 'Tất cả';
  static const String unreadFilter = 'Chưa đọc';
  static const String notificationListTitle = 'Danh sách thông báo';
  static const String loadFailedTitle = 'Chưa tải được thông báo';
  static const String defaultLoadFailed =
      'Không thể tải thông báo. Vui lòng thử lại.';
  static const String sessionExpired =
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
  static const String serverError = 'Máy chủ đang lỗi, vui lòng thử lại sau.';
  static const String connectionError =
      'Không thể kết nối đến máy chủ. Kiểm tra mạng hoặc địa chỉ API.';
  static const String retry = 'Thử lại';
  static const String reload = 'Tải lại';
  static const String emptyAllTitle = 'Chưa có thông báo';
  static const String emptyAllMessage =
      'Thông báo từ nhà trường sẽ hiển thị tại đây.';
  static const String emptyUnreadTitle = 'Không có thông báo chưa đọc';
  static const String emptyUnreadMessage =
      'Các thông báo mới chưa đọc sẽ xuất hiện ở mục này.';
  static const String unknownTime = 'Chưa cập nhật thời gian';
  static const String justNow = 'Vừa xong';
  static const String minutesAgo = 'phút trước';
  static const String hoursAgo = 'giờ trước';
  static const String daysAgo = 'ngày trước';
  static const String academicCategory = 'Học tập';
  static const String tuitionCategory = 'Học phí';
  static const String requestCategory = 'Đơn từ';
  static const String systemCategory = 'Hệ thống';
  static const String eventCategory = 'Sự kiện';
  static const String generalCategory = 'Thông báo';

  static String countLabel(int count, String label) {
    return '$count $label';
  }

  static String minuteAgo(int value) {
    return '$value $minutesAgo';
  }

  static String hourAgo(int value) {
    return '$value $hoursAgo';
  }

  static String dayAgo(int value) {
    return '$value $daysAgo';
  }
}
