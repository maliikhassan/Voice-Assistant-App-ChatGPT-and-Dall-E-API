import 'dart:convert';

import 'package:http/http.dart' as http;

import 'openAI.dart';
class openAIService{

  final List<Map<String, String>> messages = [];

  Future<String> whichAPIRequest(String promt) async {
    try{
      final response = await http.post(
          Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers:{
            "Content-Type": "application/json",
            "Authorization": "Bearer $openAIAPIKey"
          },
          body: {
            "model": "gpt-3.5-turbo",
            "messages": [{
              "role": "system",
              "content": "Does this message want to generate AI picture, image, art, or any thing similar? $promt. Simply answer is Yes or No."
            }
            ]
          }
      );
      if(response.statusCode == 200){
        String content = jsonDecode(response.body)["choices"][0]["message"]["content"];
        content = content.trim();
        switch(content){
          case 'yes':
          case 'Yes':
          case 'yes.':
          case 'Yes':
            final response2 = await dallEApi(promt);
            return response2;
          default:
            final response2 = await chatGPTApi(promt);
            return response2;
        }
      }
      return "An Internal Error Occured";
    }catch(e){
      return e.toString();
    }
  }
  Future<String> chatGPTApi(String promt) async {

    messages.add({
      "role": "user",
      "content": promt
    });
    try{
      final response = await http.post(
          Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers:{
            "Content-Type": "application/json",
            "Authorization": "Bearer $openAIAPIKey"
          },
          body: {
            "model": "gpt-3.5-turbo",
            "messages": messages
          }
      );
      if(response.statusCode == 200){
        String content = jsonDecode(response.body)["choices"][0]["message"]["content"];
        content = content.trim();
        messages.add({
          "role": "assistant",
          "content": content
        });
        return content;
      }
      return "An Internal Error Occured";
    }catch(e){
      return e.toString();
    }

  }
  Future<String> dallEApi(String promt) async {
    messages.add({
      "role": "user",
      "content": promt
    });
    try{
      final response = await http.post(
          Uri.parse("https://api.openai.com/v1/images/generations"),
          headers:{
            "Content-Type": "application/json",
            "Authorization": "Bearer $openAIAPIKey"
          },
          body: {
            "model": "dall-e-3",
            "prompt": promt,
            "n": 1,
          }
      );
      if(response.statusCode == 200){
        String imageURL = jsonDecode(response.body)['data'][0]['url'];
        imageURL = imageURL.trim();
        messages.add({
          "role": "assistant",
          "content": imageURL
        });
        return imageURL;
      }
      return "An Internal Error Occured";
    }catch(e){
      return e.toString();
    }
  }
}