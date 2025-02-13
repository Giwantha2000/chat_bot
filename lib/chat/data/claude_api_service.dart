import 'dart:convert';
import 'package:http/http.dart' as http;

/*


service class to handle all claude API stuff



*/
class ClaudeApiService {
  // API Constants
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _apiVersion = '2023-06-01';
  static const String _model = 'claude-3-opus-20240229';
  static const String _maxTokens = '1024';

  //Store the API key securely
  final String _apiKey;

  //Require API key

  ClaudeApiService({required String apiKey}) : _apiKey = apiKey;

  /*

  send a message to Claude API & returen the response

  */
  Future<String> sendMessage(String content) async {
    try {
      // Make POST request to Cloude API
      final response =await http.post(
        Uri.parse(_baseUrl),
        headers: _getHeaders(),
        body: _getRequestBody(content),

      );
      // Check if request was successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); //parse json response
        return data['content'][0]['text'];      //extract claude's response text

      }

      // Handel unsuccessful respose
      else {
        throw Exception('Faild to response from Claude: ${response.statusCode}');
      }

    }catch (e) {
      // handel any errors during api Call
      throw Exception('API Error $e');
    }
  }

  // create required headers for claude API
  Map<String, String> _getHeaders() => {
    'Content-Type': 'application/json',
    'x-api-key': _apiKey,
    'anthropic-version': _apiVersion,


  };

  // format request body according to claude API specs
  String _getRequestBody(String content) => jsonEncode({
    'model': _model,
    'message':[
      // format message in claude s required strcture
      {'role': 'user', 'content': content}
    ],
    'max_tokens': _maxTokens,
  });

}