import 'package:campy/config.dart';
import 'package:http/http.dart' as http;

// Progress API Route Logic
///Get Course Progress for specific user
///Those require bearer token
Future<http.Response> getCourseProgressForUser(String userID, String courseID) {
  return http.get(Uri.parse("$baseUrl/progress/$userID/$courseID"));
}

///Get All Courses Progress for User
Future<http.Response> getCoursesProgressForUser(String userID) {
  return http.get(Uri.parse("$baseUrl/progress/user/$userID"));
}

///Complete lesson
Future<http.Response> completeLesson(
  String userID,
  String courseID,
  String lessonID,
) {
  return http.post(
    Uri.parse("$baseUrl/progress/complete-lesson"),
    body: {"userId": userID, "courseId": courseID, "lessonId": lessonID},
  );
}

///Reset Course
Future<http.Response> resetCourse(String userID, String courseID) {
  return http.post(
    Uri.parse("$baseUrl/progress/reset"),
    body: {"userId": userID, "courseId": courseID},
  );
}

///Get Course Statistics
Future<http.Response> getCourseStatistics(String courseID) {
  return http.get(Uri.parse("$baseUrl/progress/course/$courseID/stats"));
}
