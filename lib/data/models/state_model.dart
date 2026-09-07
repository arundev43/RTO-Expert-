class StateModel {
  final String code; // "TN"
  final String name; // "Tamil Nadu"
  final List<LanguageOption> languages;

  const StateModel({required this.code, required this.name, required this.languages});
}

class LanguageOption {
  final String code; // "en", "ta"
  final String label; // "English", "Tamil"

  const LanguageOption({required this.code, required this.label});
}

/// Static list for now — swap for a remote-config fetch later so new
/// states/languages can ship without an app update.
const List<StateModel> kIndianStates = [
  StateModel(code: 'TN', name: 'Tamil Nadu', languages: [
    LanguageOption(code: 'en', label: 'English'),
    LanguageOption(code: 'ta', label: 'Tamil'),
  ]),
  StateModel(code: 'KA', name: 'Karnataka', languages: [
    LanguageOption(code: 'en', label: 'English'),
    LanguageOption(code: 'kn', label: 'Kannada'),
  ]),
  StateModel(code: 'MH', name: 'Maharashtra', languages: [
    LanguageOption(code: 'en', label: 'English'),
    LanguageOption(code: 'mr', label: 'Marathi'),
  ]),
  StateModel(code: 'DL', name: 'Delhi', languages: [
    LanguageOption(code: 'en', label: 'English'),
    LanguageOption(code: 'hi', label: 'Hindi'),
  ]),
  // Add remaining states/UTs following the same pattern.
];
