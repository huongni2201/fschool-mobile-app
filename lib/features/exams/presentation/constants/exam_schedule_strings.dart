abstract final class ExamScheduleStrings {
  static const String pageTitle = 'Lịch thi';
  static const String pageSubtitle = 'Theo dõi môn thi, giờ thi và phòng thi';

  static const String noUpcomingExam = 'Chưa có lịch thi sắp tới';
  static const String nextExamPrefix = 'Môn tiếp theo';
  static const String totalExamsLabel = 'Tổng môn';
  static const String upcomingExamsLabel = 'Sắp thi';
  static const String finishedExamsLabel = 'Đã thi';

  static const String upcomingFilter = 'Sắp thi';
  static const String finishedFilter = 'Đã xong';
  static const String allFilter = 'Tất cả';

  static const String upcomingSectionTitle = 'Môn thi sắp tới';
  static const String finishedSectionTitle = 'Lịch thi đã xong';
  static const String allSectionTitle = 'Tất cả lịch thi';
  static const String examCountSuffix = 'môn';

  static const String emptyUpcomingTitle = 'Chưa có môn thi sắp tới';
  static const String emptyFinishedTitle = 'Chưa có môn thi đã xong';
  static const String emptyAllTitle = 'Chưa có lịch thi';
  static const String emptyUpcomingMessage =
      'Lịch thi mới sẽ hiển thị tại đây sau khi nhà trường cập nhật.';
  static const String emptyFinishedMessage =
      'Các môn đã thi hoặc đã hủy sẽ hiển thị tại đây.';
  static const String emptyAllMessage =
      'Kéo xuống để làm mới khi nhà trường công bố lịch thi.';

  static const String retry = 'Thử lại';
  static const String reload = 'Tải lại';
  static const String loadFailedTitle = 'Chưa tải được lịch thi';
  static const String defaultLoadFailed =
      'Không thể tải lịch thi. Vui lòng thử lại.';
  static const String sessionExpired =
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
  static const String serverError = 'Máy chủ đang lỗi, vui lòng thử lại sau.';
  static const String connectionError =
      'Không thể kết nối đến máy chủ. Kiểm tra mạng hoặc địa chỉ API.';

  static const String dateNotUpdated = 'Chưa cập nhật ngày';
  static const String unknownDateDay = '--';
  static const String unknownDateMonth = '----';
  static const String seatPrefix = 'SBD/Ghế';

  static const String monday = 'Thứ 2';
  static const String tuesday = 'Thứ 3';
  static const String wednesday = 'Thứ 4';
  static const String thursday = 'Thứ 5';
  static const String friday = 'Thứ 6';
  static const String saturday = 'Thứ 7';
  static const String sunday = 'Chủ nhật';

  static const String mondayShort = 'T2';
  static const String tuesdayShort = 'T3';
  static const String wednesdayShort = 'T4';
  static const String thursdayShort = 'T5';
  static const String fridayShort = 'T6';
  static const String saturdayShort = 'T7';
  static const String sundayShort = 'CN';

  static String nextExam(String subject) {
    return '$nextExamPrefix: $subject';
  }

  static String examCount(int count) {
    return '$count $examCountSuffix';
  }

  static String seat(String seatNumber) {
    return '$seatPrefix $seatNumber';
  }
}
