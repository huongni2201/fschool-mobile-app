part of '../pages/semester_grades_page.dart';

const List<_SemesterOption> _semesters = [
  _SemesterOption(
    key: 'semester_1',
    label: SemesterGradeStrings.semester1Label,
    title: SemesterGradeStrings.semester1Title,
    schoolYear: SemesterGradeStrings.currentSchoolYear,
  ),
  _SemesterOption(
    key: 'semester_2',
    label: SemesterGradeStrings.semester2Label,
    title: SemesterGradeStrings.semester2Title,
    schoolYear: SemesterGradeStrings.currentSchoolYear,
  ),
  _SemesterOption(
    key: 'year',
    label: SemesterGradeStrings.yearLabel,
    title: SemesterGradeStrings.yearTitle,
    schoolYear: SemesterGradeStrings.currentSchoolYear,
  ),
];

const Map<String, List<_SubjectGrade>> _gradesBySemester = {
  'semester_1': [
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectMath,
      teacher: SemesterGradeStrings.teacherNguyenMinhAnh,
      group: SemesterGradeStrings.groupNatural,
      average: 8.6,
      accent: SemesterGradeColors.subjectMath,
      scores: [
        _ComponentScore(label: SemesterGradeStrings.scoreOral, value: '8.0'),
        _ComponentScore(
          label: SemesterGradeStrings.score15Minutes,
          value: '8.5',
        ),
        _ComponentScore(label: SemesterGradeStrings.scorePeriod, value: '9.0'),
        _ComponentScore(label: SemesterGradeStrings.scoreExam, value: '8.5'),
      ],
    ),
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectLiterature,
      teacher: SemesterGradeStrings.teacherTranHoaiThu,
      group: SemesterGradeStrings.groupSocial,
      average: 7.8,
      accent: SemesterGradeColors.subjectLiterature,
      scores: [
        _ComponentScore(label: SemesterGradeStrings.scoreOral, value: '8.0'),
        _ComponentScore(
          label: SemesterGradeStrings.score15Minutes,
          value: '7.5',
        ),
        _ComponentScore(label: SemesterGradeStrings.scorePeriod, value: '8.0'),
        _ComponentScore(label: SemesterGradeStrings.scoreExam, value: '7.5'),
      ],
    ),
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectEnglish,
      teacher: SemesterGradeStrings.teacherLeKhanhLinh,
      group: SemesterGradeStrings.groupLanguage,
      average: 9.1,
      accent: SemesterGradeColors.subjectEnglish,
      scores: [
        _ComponentScore(
          label: SemesterGradeStrings.scoreSpeaking,
          value: '9.0',
        ),
        _ComponentScore(
          label: SemesterGradeStrings.scoreListening,
          value: '9.5',
        ),
        _ComponentScore(label: SemesterGradeStrings.scoreWriting, value: '8.8'),
        _ComponentScore(label: SemesterGradeStrings.scoreFinal, value: '9.0'),
      ],
    ),
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectPhysics,
      teacher: SemesterGradeStrings.teacherPhamQuocHuy,
      group: SemesterGradeStrings.groupNatural,
      average: 8.2,
      accent: SemesterGradeColors.subjectPhysics,
      scores: [
        _ComponentScore(label: SemesterGradeStrings.scoreOral, value: '8.0'),
        _ComponentScore(
          label: SemesterGradeStrings.score15Minutes,
          value: '8.0',
        ),
        _ComponentScore(label: SemesterGradeStrings.scorePeriod, value: '8.5'),
        _ComponentScore(label: SemesterGradeStrings.scoreExam, value: '8.0'),
      ],
    ),
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectChemistry,
      teacher: SemesterGradeStrings.teacherVoThanhTung,
      group: SemesterGradeStrings.groupNatural,
      average: 7.2,
      accent: SemesterGradeColors.subjectChemistry,
      scores: [
        _ComponentScore(label: SemesterGradeStrings.scoreOral, value: '7.5'),
        _ComponentScore(
          label: SemesterGradeStrings.score15Minutes,
          value: '7.0',
        ),
        _ComponentScore(label: SemesterGradeStrings.scorePeriod, value: '7.0'),
        _ComponentScore(label: SemesterGradeStrings.scoreExam, value: '7.3'),
      ],
    ),
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectInformatics,
      teacher: SemesterGradeStrings.teacherDoBaoNam,
      group: SemesterGradeStrings.groupTechnology,
      average: 8.9,
      accent: SemesterGradeColors.subjectInformatics,
      scores: [
        _ComponentScore(
          label: SemesterGradeStrings.scorePractical,
          value: '9.0',
        ),
        _ComponentScore(label: SemesterGradeStrings.scoreProject, value: '9.2'),
        _ComponentScore(label: SemesterGradeStrings.scoreQuiz, value: '8.5'),
        _ComponentScore(label: SemesterGradeStrings.scoreExam, value: '8.8'),
      ],
    ),
  ],
  'semester_2': [
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectMath,
      teacher: SemesterGradeStrings.teacherNguyenMinhAnh,
      group: SemesterGradeStrings.groupNatural,
      average: 8.4,
      accent: SemesterGradeColors.subjectMath,
      scores: [
        _ComponentScore(label: SemesterGradeStrings.scoreOral, value: '8.5'),
        _ComponentScore(
          label: SemesterGradeStrings.score15Minutes,
          value: '8.0',
        ),
        _ComponentScore(label: SemesterGradeStrings.scorePeriod, value: '8.5'),
        _ComponentScore(
          label: SemesterGradeStrings.scoreExam,
          value: SemesterGradeStrings.unavailableScore,
        ),
      ],
    ),
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectLiterature,
      teacher: SemesterGradeStrings.teacherTranHoaiThu,
      group: SemesterGradeStrings.groupSocial,
      average: 8.0,
      accent: SemesterGradeColors.subjectLiterature,
      scores: [
        _ComponentScore(label: SemesterGradeStrings.scoreOral, value: '8.0'),
        _ComponentScore(
          label: SemesterGradeStrings.score15Minutes,
          value: '8.0',
        ),
        _ComponentScore(label: SemesterGradeStrings.scorePeriod, value: '8.0'),
        _ComponentScore(
          label: SemesterGradeStrings.scoreExam,
          value: SemesterGradeStrings.unavailableScore,
        ),
      ],
    ),
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectEnglish,
      teacher: SemesterGradeStrings.teacherLeKhanhLinh,
      group: SemesterGradeStrings.groupLanguage,
      average: 8.8,
      accent: SemesterGradeColors.subjectEnglish,
      scores: [
        _ComponentScore(
          label: SemesterGradeStrings.scoreSpeaking,
          value: '8.5',
        ),
        _ComponentScore(
          label: SemesterGradeStrings.scoreListening,
          value: '9.0',
        ),
        _ComponentScore(label: SemesterGradeStrings.scoreWriting, value: '8.7'),
        _ComponentScore(
          label: SemesterGradeStrings.scoreFinal,
          value: SemesterGradeStrings.unavailableScore,
        ),
      ],
    ),
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectBiology,
      teacher: SemesterGradeStrings.teacherBuiNhatMinh,
      group: SemesterGradeStrings.groupNatural,
      average: 7.6,
      accent: SemesterGradeColors.subjectBiology,
      scores: [
        _ComponentScore(label: SemesterGradeStrings.scoreOral, value: '7.5'),
        _ComponentScore(
          label: SemesterGradeStrings.score15Minutes,
          value: '8.0',
        ),
        _ComponentScore(label: SemesterGradeStrings.scorePeriod, value: '7.5'),
        _ComponentScore(
          label: SemesterGradeStrings.scoreExam,
          value: SemesterGradeStrings.unavailableScore,
        ),
      ],
    ),
  ],
  'year': [
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectMath,
      teacher: SemesterGradeStrings.teacherNguyenMinhAnh,
      group: SemesterGradeStrings.groupNatural,
      average: 8.5,
      accent: SemesterGradeColors.subjectMath,
      scores: [
        _ComponentScore(
          label: SemesterGradeStrings.scoreSemester1,
          value: '8.6',
        ),
        _ComponentScore(
          label: SemesterGradeStrings.scoreSemester2,
          value: '8.4',
        ),
        _ComponentScore(
          label: SemesterGradeStrings.scoreYearAverage,
          value: '8.5',
        ),
      ],
    ),
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectLiterature,
      teacher: SemesterGradeStrings.teacherTranHoaiThu,
      group: SemesterGradeStrings.groupSocial,
      average: 7.9,
      accent: SemesterGradeColors.subjectLiterature,
      scores: [
        _ComponentScore(
          label: SemesterGradeStrings.scoreSemester1,
          value: '7.8',
        ),
        _ComponentScore(
          label: SemesterGradeStrings.scoreSemester2,
          value: '8.0',
        ),
        _ComponentScore(
          label: SemesterGradeStrings.scoreYearAverage,
          value: '7.9',
        ),
      ],
    ),
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectEnglish,
      teacher: SemesterGradeStrings.teacherLeKhanhLinh,
      group: SemesterGradeStrings.groupLanguage,
      average: 8.9,
      accent: SemesterGradeColors.subjectEnglish,
      scores: [
        _ComponentScore(
          label: SemesterGradeStrings.scoreSemester1,
          value: '9.1',
        ),
        _ComponentScore(
          label: SemesterGradeStrings.scoreSemester2,
          value: '8.8',
        ),
        _ComponentScore(
          label: SemesterGradeStrings.scoreYearAverage,
          value: '8.9',
        ),
      ],
    ),
    _SubjectGrade(
      subject: SemesterGradeStrings.subjectInformatics,
      teacher: SemesterGradeStrings.teacherDoBaoNam,
      group: SemesterGradeStrings.groupTechnology,
      average: 8.9,
      accent: SemesterGradeColors.subjectInformatics,
      scores: [
        _ComponentScore(
          label: SemesterGradeStrings.scoreSemester1,
          value: '8.9',
        ),
        _ComponentScore(
          label: SemesterGradeStrings.scoreSemester2,
          value: '8.8',
        ),
        _ComponentScore(
          label: SemesterGradeStrings.scoreYearAverage,
          value: '8.9',
        ),
      ],
    ),
  ],
};
