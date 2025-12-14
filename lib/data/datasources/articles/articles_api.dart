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


  @GET('/works/{id}')
  Future<Response<Map<String, dynamic>>> getArticleByIdRaw(
    @Path('id') String id,
  );

  // 2. Поиск статей по автору
  @GET('/works')
  Future<Response<Map<String, dynamic>>> searchArticlesByAuthorRaw(
    @Query('filter') String filter,
    @Query('per_page') int perPage,
    @Query('sort') String sort,
    @Query('search') String? search,
  );

  // 3. Поиск статей по DOI
  @GET('/works')
  Future<Response<Map<String, dynamic>>> searchArticlesByDoiRaw(
    @Query('filter') String filter,
    @Query('per_page') int perPage,
  );

  // 4. Получение самых цитируемых статей
  @GET('/works')
  Future<Response<Map<String, dynamic>>> getMostCitedArticlesRaw(
    @Query('filter') String? filter,
    @Query('per_page') int perPage,
    @Query('sort') String sort,
    @Query('search') String? search,
  );

  // 5. Поиск статей по году публикации
  @GET('/works')
  Future<Response<Map<String, dynamic>>> searchArticlesByYearRaw(
    @Query('filter') String filter,
    @Query('per_page') int perPage,
    @Query('sort') String sort,
    @Query('search') String? search,
  );
}

