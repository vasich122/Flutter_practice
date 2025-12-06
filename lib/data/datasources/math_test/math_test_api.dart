import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'math_test_api.g.dart';

@RestApi(baseUrl: 'https://opentdb.com')
abstract class MathTestApi {
  factory MathTestApi(Dio dio, {String baseUrl}) = _MathTestApi;

  @GET('/api.php')
  Future<Response<Map<String, dynamic>>> getQuestionsRaw(
    @Query('amount') int amount,
    @Query('category') int category,
    @Query('difficulty') String difficulty,
    @Query('type') String type,
  );
}

