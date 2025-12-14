import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'library_api.g.dart';

@RestApi(baseUrl: 'https://openlibrary.org')
abstract class LibraryApi {
  factory LibraryApi(Dio dio, {String baseUrl}) = _LibraryApi;

  @GET('/search.json')
  Future<Response<Map<String, dynamic>>> searchBooksRaw(
    @Query('q') String query,
    @Query('limit') int limit,
  );

  @GET('/search.json')
  Future<Response<Map<String, dynamic>>> getPopularBooksRaw(
    @Query('q') String query,
    @Query('limit') int limit,
  );

  @GET('/works/{key}.json')
  Future<Response<Map<String, dynamic>>> getBookByKeyRaw(
    @Path('key') String key,
  );

  @GET('/search.json')
  Future<Response<Map<String, dynamic>>> searchBooksByAuthorRaw(
    @Query('author') String authorName,
    @Query('limit') int limit,
  );

  @GET('/search.json')
  Future<Response<Map<String, dynamic>>> searchBooksBySubjectRaw(
    @Query('subject') String subject,
    @Query('limit') int limit,
  );

  @GET('/isbn/{isbn}.json')
  Future<Response<Map<String, dynamic>>> getBookByIsbnRaw(
    @Path('isbn') String isbn,
  );

  @GET('/search.json')
  Future<Response<Map<String, dynamic>>> searchBooksByYearRaw(
    @Query('first_publish_year') int year,
    @Query('limit') int limit,
    @Query('q') String? query,
  );
}

