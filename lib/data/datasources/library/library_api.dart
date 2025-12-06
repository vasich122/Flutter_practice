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
}

