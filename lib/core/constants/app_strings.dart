abstract final class AppStrings {
  static const String appName = 'FPT Schools';

  static const String loginTitle = 'FPT SCHOOLS';
  static const String loginSubtitle =
      'Đăng nhập để tiếp tục hành trình học tập';

  static const String phoneNumber = 'Số điện thoại';
  static const String password = 'Mật khẩu';

  static const String login = 'Đăng nhập';
  static const String forgotPassword = 'Quên mật khẩu?';
  static const String logout = 'Đăng xuất';

  static const String phoneRequired = 'Vui lòng nhập số điện thoại';
  static const String phoneInvalid = 'Số điện thoại không hợp lệ';
  static const String passwordRequired = 'Vui lòng nhập mật khẩu';
  static const String passwordTooShort = 'Mật khẩu phải có ít nhất 6 ký tự';

  static const String loginInvalidCredentials =
      'Số điện thoại hoặc mật khẩu không đúng';
  static const String serverError = 'Máy chủ đang lỗi, vui lòng thử lại sau';
  static const String connectionError = 'Không thể kết nối đến máy chủ';
  static const String invalidLoginResponse =
      'Dữ liệu đăng nhập trả về không hợp lệ';
  static const String loginFailed = 'Đăng nhập thất bại, vui lòng thử lại';
  static const String loginSuccess = 'Đăng nhập thành công';

  static const String copyright = '© 2026 FPT Education. All rights reserved.';
  static const String version = 'Version 1.0.0';

  static const String resetPasswordTitle = 'Đặt lại mật khẩu của bạn';
  static const String verifyStep = 'Xác minh';
  static const String otpStep = 'Mã OTP';
  static const String newPasswordStep = 'Mật khẩu mới';

  static const String enterPhoneForOtp = 'Nhập số điện thoại để nhận mã OTP';

  static const String sendOtp = 'Gửi mã OTP';
  static const String or = 'hoặc';
  static const String rememberPassword = 'Nhớ mật khẩu?';
  static const String backToLogin = 'Quay lại đăng nhập';

  static String otpWillBeSent(String phoneNumber) {
    return 'Sẽ gửi mã OTP tới số $phoneNumber';
  }
}
