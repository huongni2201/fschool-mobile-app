abstract final class RequestsStrings {
  static const String pageTitle = 'Đơn từ';
  static const String pageSubtitle = 'Tạo và theo dõi yêu cầu gửi nhà trường';
  static const String heroTitle = 'Gửi đơn nhanh';
  static const String heroDescription =
      'Chọn loại đơn, điền thông tin và theo dõi trạng thái xử lý ngay trong app.';
  static const String createRequestTitle = 'Tạo đơn mới';
  static const String recentRequestsTitle = 'Đơn gần đây';
  static const String createRequestComingSoon =
      'Chức năng tạo đơn đang được phát triển';
  static const String parentOnlyTitle = 'Chỉ phụ huynh được gửi đơn';
  static const String parentOnlyMessage =
      'Tài khoản học sinh không có chức năng đơn từ. Vui lòng dùng tài khoản phụ huynh để tạo và theo dõi đơn.';
  static const String loadFailed = 'Không thể tải dữ liệu đơn từ';
  static const String retry = 'Thử lại';
  static const String noRequestTypesTitle = 'Chưa có loại đơn';
  static const String noRequestTypesMessage =
      'Nhà trường chưa cấu hình loại đơn để gửi.';
  static const String noRequestsTitle = 'Chưa có đơn gần đây';
  static const String noRequestsMessage =
      'Các đơn đã gửi sẽ hiển thị tại đây sau khi được tạo.';
  static const String createPageTitle = 'Tạo đơn';
  static const String createPageSubtitle = 'Điền thông tin gửi nhà trường';
  static const String selectedRequestType = 'Loại đơn';
  static const String requestTitleLabel = 'Tiêu đề';
  static const String requestTitleHint = 'Nhập tiêu đề đơn';
  static const String requestContentLabel = 'Nội dung';
  static const String requestContentHint =
      'Mô tả ngắn gọn nội dung cần gửi nhà trường';
  static const String requestDateRangeLabel = 'Thời gian áp dụng';
  static const String requestDateRangeHint = 'Chọn ngày bắt đầu và kết thúc';
  static const String requestAttachmentLabel = 'Tệp đính kèm';
  static const String requestAttachmentHint =
      'Có thể đính kèm PDF, ảnh hoặc tài liệu liên quan';
  static const String pickAttachment = 'Chọn tệp';
  static const String removeAttachment = 'Xóa tệp';
  static const String submitRequest = 'Gửi đơn';
  static const String submittingRequest = 'Đang gửi...';
  static const String submitSuccess = 'Đã gửi đơn';
  static const String submitFailed = 'Không thể gửi đơn. Vui lòng thử lại.';
  static const String requiredField = 'Vui lòng nhập thông tin này';
  static const String requiredDateRange = 'Vui lòng chọn thời gian áp dụng';
  static const String requiredAttachment = 'Vui lòng đính kèm tệp';
  static const String attachmentMissingData =
      'Tệp đã chọn không có dữ liệu để upload';
  static const String attachmentTooLarge =
      'Mỗi tệp đính kèm không được vượt quá 10MB';
  static const String noAttachments = 'Chưa chọn tệp';

  static const String absenceRequestTitle = 'Đơn xin nghỉ học';
  static const String absenceRequestDescription =
      'Gửi đơn nghỉ học có phép cho giáo viên chủ nhiệm.';
  static const String confirmationRequestTitle = 'Đơn xác nhận học sinh';
  static const String confirmationRequestDescription =
      'Yêu cầu xác nhận thông tin học sinh đang theo học.';
  static const String tuitionRequestTitle = 'Đơn đề nghị hỗ trợ học phí';
  static const String tuitionRequestDescription =
      'Tạo đề nghị hỗ trợ hoặc xác minh thông tin học phí.';
  static const String otherRequestTitle = 'Đơn khác';
  static const String otherRequestDescription =
      'Gửi yêu cầu khác đến nhà trường.';

  static const String recentAbsenceRequestDate = '02/07/2026';
  static const String recentConfirmationRequestDate = '26/06/2026';
  static const String statusProcessing = 'Đang xử lý';
  static const String statusApproved = 'Đã duyệt';
}
