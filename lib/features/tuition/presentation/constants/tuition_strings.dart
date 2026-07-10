abstract final class TuitionStrings {
  static const String pageTitle = 'Học phí';
  static const String pageSubtitle = 'Theo dõi khoản phí và lịch sử thanh toán';
  static const String remainingAmountTitle = 'Số dư cần thanh toán';
  static const String paidPrefix = 'Đã thanh toán';
  static const String classPrefix = 'Lớp';
  static const String nearestDueDate = 'Hạn gần nhất';
  static const String payNow = 'Thanh toán ngay';
  static const String totalFee = 'Tổng phí';
  static const String paidFee = 'Đã đóng';
  static const String feeListTitle = 'Các khoản học phí';
  static const String paymentInfoTitle = 'Thông tin chuyển khoản';
  static const String paymentInfoDescription =
      'Dùng đúng nội dung để hệ thống đối soát nhanh hơn.';
  static const String transactionHistoryTitle = 'Lịch sử giao dịch';
  static const String amount = 'Số tiền';
  static const String paid = 'Đã đóng';
  static const String dueDate = 'Hạn đóng';
  static const String bank = 'Ngân hàng';
  static const String accountNumber = 'Số tài khoản';
  static const String accountName = 'Chủ tài khoản';
  static const String transferContent = 'Nội dung';
  static const String copy = 'Sao chép';
  static const String qrCode = 'Mã QR';
  static const String copiedPaymentInfo = 'Đã sao chép thông tin chuyển khoản.';
  static const String paymentComingSoon =
      'Chức năng thanh toán trực tuyến sẽ được kết nối trong phiên bản sau.';
  static const String retry = 'Thử lại';
  static const String reload = 'Tải lại';
  static const String loadFailedTitle = 'Chưa tải được học phí';
  static const String defaultLoadFailed =
      'Không thể tải dữ liệu học phí. Vui lòng thử lại.';
  static const String sessionExpired =
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
  static const String serverError = 'Máy chủ đang lỗi, vui lòng thử lại sau.';
  static const String connectionError =
      'Không thể kết nối đến máy chủ. Kiểm tra mạng hoặc địa chỉ API.';
  static const String emptyFeesTitle = 'Chưa có khoản phí';
  static const String emptyFeesMessage =
      'Các khoản học phí sẽ hiển thị khi nhà trường cập nhật.';
  static const String emptyTransactionsTitle = 'Chưa có giao dịch';
  static const String emptyTransactionsMessage =
      'Lịch sử thanh toán sẽ hiển thị sau khi giao dịch được ghi nhận.';
  static const String emptyPaymentInfoTitle = 'Chưa có thông tin chuyển khoản';
  static const String emptyPaymentInfoMessage =
      'Nhà trường chưa cấu hình thông tin thanh toán cho học sinh này.';
  static const String updating = 'Đang cập nhật';
  static const String noData = '--';

  static const String statusPaid = 'Đã đóng';
  static const String statusDue = 'Cần đóng';
  static const String statusOverdue = 'Quá hạn';
  static const String statusUpcoming = 'Sắp tới';
  static const String statusUnknown = 'Đang cập nhật';
  static const String statusPaymentDue = 'Cần thanh toán';
  static const String statusComplete = 'Đã hoàn tất';

  static String paidAmount(String amount) {
    return '$paidPrefix $amount';
  }

  static String className(String value) {
    return '$classPrefix $value';
  }
}
