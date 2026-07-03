abstract final class SemesterGradeStrings {
  static const String pageTitle = 'Bảng điểm';
  static const String separator = ' · ';
  static const String updating = 'Đang cập nhật';
  static const String averageShort = 'TB';
  static const String semesterAverageShort = 'TBHK';
  static const String unavailableScore = '--';

  static const String semester1Label = 'HK I';
  static const String semester2Label = 'HK II';
  static const String yearLabel = 'Cả năm';

  static const String semester1Title = 'Học kỳ I';
  static const String semester2Title = 'Học kỳ II';
  static const String yearTitle = 'Tổng kết cả năm';
  static const String currentSchoolYear = '2025 - 2026';

  static const String overviewCurrent = 'Kết quả hiện tại';
  static const String featuredSubjectPrefix = 'Môn học nổi bật';
  static const String subjectUnit = 'môn học';
  static const String excellentSubjectUnit = 'môn đạt từ 8.0';
  static const String subjectListTitle = 'Điểm trung bình theo môn';
  static const String teacherPrefix = 'GV';

  static const String viewSubjectDetail = 'Xem điểm chi tiết';
  static const String subjectDetailTitle = 'Điểm chi tiết';
  static const String componentScoresTitle = 'Điểm thành phần';
  static const String subjectAverageTitle = 'Điểm trung bình';
  static const String subjectRankTitle = 'Xếp loại';

  static const String rankExcellent = 'Xuất sắc';
  static const String rankGood = 'Giỏi';
  static const String rankFair = 'Khá';
  static const String rankMediumFair = 'Trung bình khá';
  static const String rankMedium = 'Trung bình';
  static const String rankNeedsImprovement = 'Cần cải thiện';

  static const String subjectMath = 'Toán học';
  static const String subjectLiterature = 'Ngữ văn';
  static const String subjectEnglish = 'Tiếng Anh';
  static const String subjectPhysics = 'Vật lý';
  static const String subjectChemistry = 'Hóa học';
  static const String subjectInformatics = 'Tin học';
  static const String subjectBiology = 'Sinh học';

  static const String teacherNguyenMinhAnh = 'Nguyễn Minh Anh';
  static const String teacherTranHoaiThu = 'Trần Hoài Thu';
  static const String teacherLeKhanhLinh = 'Lê Khánh Linh';
  static const String teacherPhamQuocHuy = 'Phạm Quốc Huy';
  static const String teacherVoThanhTung = 'Võ Thanh Tùng';
  static const String teacherDoBaoNam = 'Đỗ Bảo Nam';
  static const String teacherBuiNhatMinh = 'Bùi Nhật Minh';

  static const String groupNatural = 'Tự nhiên';
  static const String groupSocial = 'Xã hội';
  static const String groupLanguage = 'Ngoại ngữ';
  static const String groupTechnology = 'Công nghệ';

  static const String groupLanguageKeyword = 'ngoại';
  static const String groupSocialKeyword = 'xã';
  static const String groupTechnologyKeyword = 'công';

  static const String scoreOral = 'Kiểm tra miệng';
  static const String score15Minutes = 'Kiểm tra 15 phút';
  static const String scorePeriod = 'Kiểm tra 1 tiết';
  static const String scoreExam = 'Bài thi';
  static const String scoreSpeaking = 'Nói';
  static const String scoreListening = 'Nghe';
  static const String scoreWriting = 'Viết';
  static const String scoreFinal = 'Cuối kỳ';
  static const String scorePractical = 'Thực hành';
  static const String scoreProject = 'Dự án';
  static const String scoreQuiz = 'Bài kiểm tra';
  static const String scoreSemester1 = 'HK I';
  static const String scoreSemester2 = 'HK II';
  static const String scoreYearAverage = 'TB cả năm';

  static const String note =
      'Màn hình này chỉ hiển thị điểm trung bình. '
      'Chạm vào từng môn để xem điểm thành phần.';

  static String pageSubtitle(String semesterTitle, String schoolYear) {
    return '$semesterTitle$separator$schoolYear';
  }

  static String featuredSubject(String subject) {
    return '$featuredSubjectPrefix: $subject';
  }

  static String subjectSummary(int subjectCount, String averageLabel) {
    return '$subjectCount $subjectUnit'
        '$separator$averageShort: $averageLabel';
  }

  static String subjectTeacherLine(String group, String teacherName) {
    return '$group$separator$teacherPrefix: $teacherName';
  }
}