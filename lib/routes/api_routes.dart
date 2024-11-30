class ApiRoutes {
  static const String baseUrl = 'https://lms.educode.id';
  static const String baseFunctionUrl = '$baseUrl/webservice/rest/server.php?';
  static const String service = 'educodeAPI';
  static const String wstoken = 'eb60c3bda800422e20df49087f462e81';

  //endpoints
  static const String loginApp = '$baseUrl/login/token.php?';
  static const String userId = 'core_webservice_get_site_info';
  static const String getUserCourse = 'core_enrol_get_users_courses';
  static const String getDetailCourse = 'core_course_get_contents';
  static const String gredeReport = 'gradereport_user_get_grade_items';
  static const String profileUser = 'core_user_get_users_by_field';
  static const String getRoleCourse = 'core_enrol_get_enrolled_users';
  static const String getActivityCourse =
      'mod_resource_get_resources_by_courses';
  static const String getCalenderEvent =
      'core_calendar_get_action_events_by_courses';
}
