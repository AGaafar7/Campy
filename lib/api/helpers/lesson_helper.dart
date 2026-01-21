import 'package:campy/api/models/course_model.dart';
import 'package:campy/api/models/lesson_model.dart';
import 'package:campy/config.dart';
import 'package:http/http.dart' as http;

// Lesson API Route Logic
///All Get Lessons
Future<http.Response> getLessons() {
  return http.get(Uri.parse("$base_url/lessons"));
}

///Get all lessons for course
Future<http.Response> getLessonsByCourse(Course course) {
  return http.get(Uri.parse("$base_url/lessons/course/:${course.id}"));
}

///Get lesson
Future<http.Response> getLessonByID(Lesson lesson) {
  return http.get(Uri.parse("$base_url/lessons/:${lesson.id}"));
}

//Create Lesson
Future<http.Response> createLesson(Lesson lesson, Course course, String token) {
  return http.post(
    Uri.parse("$base_url/lessons/"),
    headers: {"Authorization": "Bearer $token"},
    body: {
      "lessonId": lesson.id,
      "courseId": course.id,
      "title": lesson.title,
      "content": lesson.content,
      "duration": lesson.duration,
      "videoUrl": lesson.videoURL,
      "order": lesson.order,
    },
  );
}

//Update Lesson
Future<http.Response> updateLesson(Lesson lesson, String token) {
  return http.put(
    Uri.parse("$base_url/lessons/:${lesson.id}"),
    headers: {"Authorization": "Bearer $token"},
    body: {"title": lesson.title, "duration": lesson.duration},
  );
}

//Delete Lesson
Future<http.Response> deleteLesson(Lesson lesson, String token) {
  return http.delete(
    Uri.parse("$base_url/lessons/:${lesson.id}"),
    headers: {"Authorization": "Bearer $token"},
  );
}
