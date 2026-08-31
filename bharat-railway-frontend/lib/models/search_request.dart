/*
 * Project: Bharat Railway Booking System
 * Module: bharat-railway-frontend
 * Branch: feature/frontend-developer-chandrashekhar
 * Developer: Chandra Shekhar Bansal
 * Date: 2026-09-01
 * Version: 1.0.0
 *
 * Description:
 * Train search request model.
 * Maps to backend search query params.
 */

class SearchRequest {
  final String origin;
  final String destination;
  final String date;

  SearchRequest({
    required this.origin,
    required this.destination,
    required this.date,
  });

  Map<String, String> toQueryParams() {
    return {
      'origin': origin,
      'destination': destination,
      'date': date,
    };
  }
}