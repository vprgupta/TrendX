class ApiConfig {
  static const String baseUrl = 'http://localhost:5000/api';
  static const String healthUrl = 'http://localhost:5000/health';
  
  // API Endpoints
  static const String authRegister = '$baseUrl/auth/register';
  static const String authLogin = '$baseUrl/auth/login';
  static const String trends = '$baseUrl/trends';
  static const String users = '$baseUrl/users';
  
  // Request timeout
  static const Duration timeout = Duration(seconds: 30);
  
  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}