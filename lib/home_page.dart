import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/featureBox.dart';
import 'package:voice_assistant/openAI_Services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FlutterTts flutterTts = FlutterTts();
  final openAIService openAIserv = openAIService();
  String convertedText = "";
  final speechtotext = SpeechToText();
  String? generetedText;
  String? generatedImageUrl;
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech()async{
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText () async {
    await speechtotext.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechtotext.listen(onResult: onSpeechResult);
    setState(() {});
  }


  Future<void> stopListening() async {
    await speechtotext.stop();
    setState(() {});
  }


  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      convertedText = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechtotext.stop();
    flutterTts.stop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Voice Assistant",
            style: TextStyle(fontFamily: "Cera-Pro"),
          ),
          backgroundColor: Colors.white,
          leading: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          centerTitle: true,
          shadowColor: Colors.black,
          elevation: 4,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                      child: Image.asset(
                    "assets/images/virtualAssistant.png",
                    width: 100,
                  ))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                margin: const EdgeInsets.only(top: 25,left: 30,right: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black,width: 1),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                ),
                child: Text(
                  generetedText == null ?
                  "Good Morning, What task I can do for you?"
                  : generetedText!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: generetedText == null ? 25 : 18,
                    fontFamily: "Cera-Pro"
                  ),
                ),
              ),
              Visibility(
                visible: generetedText == null,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 10,left: 30,right: 30),
                      child: const Text("Useful Suggestions.",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cera-Pro"
                        ),
                      ),
                    ),
                    Featurebox(
                      color: Colors.lightBlue.shade300,
                      textHeading: "ChatGPT",
                      textBody: "A smarter way to get organized and get informed with ChatGPT",
                    ),
                    Featurebox(
                      color: Colors.lightGreen.shade400,
                      textHeading: "Dall-E",
                      textBody: "Get inspired and stay creative with your personal assistant Dall-E",
                    ),
                    Featurebox(
                      color: Colors.orange.shade400,
                      textHeading: "Smart Voice Assistant",
                      textBody: "Get the best of both worlds with a voice assistant powered by ChatGPT and Dall-E",
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if(await speechtotext.hasPermission && speechtotext.isNotListening){
            await startListening();
          }else if(await speechtotext.isListening){
            final speech = await openAIserv.whichAPIRequest(convertedText);
            if(speech.contains('https')){
              generatedImageUrl = speech;
              generetedText = null;
              setState(() {});
            }else{
              generatedImageUrl = speech;
              generetedText = null;
              setState(() {});
              await systemSpeak(speech);
            }
            await stopListening();
          }else{
            initSpeechToText();
          }
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.mic_none,color: Colors.white,),
        elevation: 20,
      ),
    );
  }
}
