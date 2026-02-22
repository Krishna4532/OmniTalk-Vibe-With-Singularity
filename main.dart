import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MaterialApp(
    home: OmniTalkWeb(),
    debugShowCheckedModeBanner: false,
  ));
}

class OmniTalkWeb extends StatefulWidget {
  const OmniTalkWeb({super.key});

  @override
  State<OmniTalkWeb> createState() => _OmniTalkWebState();
}

class _OmniTalkWebState extends State<OmniTalkWeb> {
  // --- STATE VARIABLES ---
  String _inputLang = "English";
  String _outputLang = "Hindi";
  String _statusText = "Tap mic to speak (Offline Mode)";
  String _resultText = "Waiting for input...";
  bool _isProcessing = false;

  final List<String> _langs = [
    "English",
    "Hindi",
    "Spanish",
    "French",
    "Arabic",
    "Japanese"
  ];

  // --- TRANSLATION LOGIC ---
  void _runTranslation() async {
    if (_isProcessing) return; // Prevent double-clicks

    setState(() {
      _isProcessing = true;
      _statusText = "Listening (No Internet Required)...";
      _resultText = "..."; // Visual cue that AI is "thinking"
    });

    // 1. Realistic 1.5s delay to simulate On-Device NPU Inference
    await Future.delayed(const Duration(milliseconds: 1500));

    String mockInput = "Data privacy is our top priority.";
    String translatedResult = "";

    // 2. Logic to handle "Any to Any" via the output language selection
    switch (_outputLang) {
      case "Hindi":
        translatedResult = "डेटा गोपनीयता हमारी सर्वोच्च प्राथमिकता है।";
        break;
      case "Spanish":
        translatedResult = "La privacidad de los datos es nuestra prioridad.";
        break;
      case "French":
        translatedResult = "La confidentialité des données est notre priorité.";
        break;
      case "Arabic":
        translatedResult = "خصوصية البيانات هي أولويتنا القصوى.";
        break;
      case "Japanese":
        translatedResult = "データのプライバシーは当社の最優先事項です。";
        break;
      default:
        translatedResult = "Processing complete: $mockInput";
    }

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
      _statusText = mockInput;
      _resultText = translatedResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // --- TOP HALF: RECIPIENT VIEW (180° FLIPPED) ---
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF151515),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Transform.rotate(
                angle: math.pi,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _langPicker(_outputLang, (v) => setState(() => _outputLang = v!)),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        _resultText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- MIDDLE: PRIVACY STATUS BAR ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shield_outlined, color: Colors.greenAccent, size: 16),
                const SizedBox(width: 8),
                Text(
                  "100% OFFLINE • NO DATA LEAVES DEVICE",
                  style: TextStyle(
                    color: Colors.greenAccent.withOpacity(0.7),
                    letterSpacing: 1.2,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // --- BOTTOM HALF: YOUR VIEW ---
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _langPicker(_inputLang, (v) => setState(() => _inputLang = v!)),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    _statusText,
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 50),
                // MIC BUTTON
                GestureDetector(
                  onTap: _runTranslation,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isProcessing ? Colors.redAccent : Colors.greenAccent,
                      boxShadow: [
                        if (_isProcessing)
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 5,
                          )
                      ],
                    ),
                    child: Icon(
                      _isProcessing ? Icons.graphic_eq : Icons.mic,
                      color: Colors.black,
                      size: 38,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CUSTOM REUSABLE DROPDOWN ---
  Widget _langPicker(String current, Function(String?) onChg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white10),
          color: Colors.white.withOpacity(0.04)),
      child: DropdownButton<String>(
        value: current,
        items: _langs
            .map((l) => DropdownMenuItem(
                value: l,
                child: Text(l, style: const TextStyle(fontSize: 14))))
            .toList(),
        onChanged: onChg,
        dropdownColor: Colors.grey[900],
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.greenAccent, size: 18),
      ),
    );
  }
}