mixin HttpMixin {
  Future<Map<String, dynamic>> requisitarGet(
    String rota, {
    Map<String, String>? headers,
  }) async {
    throw UnimplementedError('Implemente GET para: $rota');
  }

  Future<Map<String, dynamic>> requisitarPost(
    String rota, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    throw UnimplementedError('Implemente POST para: $rota');
  }

  Future<Map<String, dynamic>> requisitarPut(
    String rota, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    throw UnimplementedError('Implemente PUT para: $rota');
  }

  Future<Map<String, dynamic>> requisitarDelete(
    String rota, {
    Map<String, String>? headers,
  }) async {
    throw UnimplementedError('Implemente DELETE para: $rota');
  }
}
