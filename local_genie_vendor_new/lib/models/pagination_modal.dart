import 'dart:convert';

import 'package:flutter/foundation.dart' show immutable;

@immutable
class PaginationModal {
  final List results;
  final int page;
  final int limit;
  final bool isLoading;

  const PaginationModal({
    required this.results,
    required this.isLoading,
    required this.page,
    required this.limit,
  });

  PaginationModal.unknown()
      : results = [],
        isLoading = false,
        limit = 20,
        page = 0;

  PaginationModal copiedWithIsLoading(bool isLoading) => PaginationModal(
        results: results,
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  PaginationModal copiedWithResultsAndLoader(List results, bool isLoading) =>
      PaginationModal(
        results: results,
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  @override
  bool operator ==(covariant PaginationModal other) =>
      identical(this, other) ||
      (results == other.results &&
          isLoading == other.isLoading &&
          limit == other.limit &&
          page == other.page);

  @override
  int get hashCode => Object.hash(
        results,
        isLoading,
        limit,
        page,
      );

  @override
  String toString() {
    return 'PaginationModal(results: ${jsonEncode(results)}, isLoading: $isLoading, page: $page, limit: $limit)';
  }
}
