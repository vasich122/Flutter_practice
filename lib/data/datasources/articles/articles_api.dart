import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'articles_api.g.dart';

@RestApi(baseUrl: 'https://api.openalex.org')
abstract class ArticlesApi {
  factory ArticlesApi(Dio dio, {String baseUrl}) = _ArticlesApi;

  @GET('/works')
  Future<Response<Map<String, dynamic>>> searchArticlesRaw(
    @Query('search') String? search,
    @Query('filter') String? filter,
    @Query('per_page') int perPage,
    @Query('sort') String sort,
  );

  @GET('/works')
  Future<Response<Map<String, dynamic>>> getRecentArticlesRaw(
    @Query('filter') String? filter,
    @Query('per_page') int perPage,
    @Query('sort') String sort,
  );
}

