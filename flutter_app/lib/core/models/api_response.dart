class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final PaginationData? pagination;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.pagination,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? true,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      message: json['message'] as String?,
      pagination: json['pagination'] != null
          ? PaginationData.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T?)? toJsonT) {
    return {
      'success': success,
      'data': data != null && toJsonT != null ? toJsonT(data) : data,
      'message': message,
      'pagination': pagination?.toJson(),
    };
  }
}

class PaginationData {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginationData({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }

  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
}

class ApiError {
  final String message;
  final int? statusCode;
  final String? code;
  final Map<String, dynamic>? errors;

  ApiError({
    required this.message,
    this.statusCode,
    this.code,
    this.errors,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] as String? ?? 'Error desconocido',
      statusCode: json['statusCode'] as int?,
      code: json['code'] as String?,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'code': code,
      'errors': errors,
    };
  }

  @override
  String toString() => message;
}
