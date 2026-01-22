import 'package:campy/api/models/course_model.dart';
import 'package:campy/config.dart';
import 'package:http/http.dart' as http;

// Courses API Route Logic
///All Get Courses
Future<http.Response> getCourses() {
  return http.get(Uri.parse("$baseUrl/courses"));
}

///Get course by ID
Future<http.Response> getCourseByID(String id) {
  return http.get(Uri.parse("$baseUrl/courses/:$id"));
}

///Get all courses enrolled by a specific user.
Future<http.Response> getCourseByUserID(String userID) {
  return http.get(Uri.parse("$baseUrl/courses/user/:$userID"));
}

///Create Course
Future<http.Response> createCourse(String token, Course course) {
  return http.post(
    Uri.parse("$baseUrl/courses"),
    headers: {"Authorization": "Bearer $token"},
    body: {
      "courseId": course.id,
      "title": course.title,
      "description": course.description,
      "duration": course.duration,
      "instructor": course.instructorID,
      "price": course.price,
      "category": course.category,
      "level": course.level,
      "thumbnail": course.thumbnail,
    },
  );
}

///Update course
Future<http.Response> updateCourse(String token, Course course) {
  return http.put(
    Uri.parse("$baseUrl/courses/:${course.id}"),
    headers: {"Authorization": "Bearer $token"},
    body: {"title": course.title, "price": course.price},
  );
}

///Delete course
Future<http.Response> deleteCourse(String token, Course course) {
  return http.delete(
    Uri.parse("$baseUrl/courses/:${course.id}"),
    headers: {"Authorization": "Bearer $token"},
  );
}

///Enroll in course
Future<http.Response> enrollUserInCourse(
  String token,
  Course course,
  String userId,
) {
  return http.post(
    Uri.parse("$baseUrl/courses/:${course.id}/enroll"),
    headers: {"Authorization": "Bearer $token"},
    body: {"userId": userId},
  );
}

///UnEnroll in course
Future<http.Response> unenrollUserInCourse(
  String token,
  Course course,
  String userId,
) {
  return http.post(
    Uri.parse("$baseUrl/courses/:${course.id}/unenroll"),
    headers: {"Authorization": "Bearer $token"},
    body: {"userId": userId},
  );
}

///Mark course as inactive
Future<http.Response> makeCourseInActive(String token, Course course) {
  return http.put(
    Uri.parse("$baseUrl/courses/:${course.id}/cancel"),
    headers: {"Authorization": "Bearer $token"},
  );
}
