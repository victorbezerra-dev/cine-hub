abstract class IHttpClient {
  Future get(String endpoint, {dynamic queryParameters});
  Future post(String endpoint, {dynamic data});
  Future put(String endpoint, {dynamic data});
  Future delete(String endpoint, {dynamic data});
}
