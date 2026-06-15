class ScenarioPhrase {
  final String expression;
  final String meaning;
  final String example;

  const ScenarioPhrase({
    required this.expression,
    required this.meaning,
    required this.example,
  });
}

class ScenarioPhrases {
  static const Map<String, List<ScenarioPhrase>> phrasesByIcon = {
    'chat_bubble': [
      ScenarioPhrase(
        expression: 'Break the ice',
        meaning: 'To start a conversation in a social situation',
        example: 'He told a joke to break the ice at the party.',
      ),
      ScenarioPhrase(
        expression: 'Small talk',
        meaning: 'Polite conversation about unimportant topics',
        example: 'We made small talk about the weather while waiting.',
      ),
      ScenarioPhrase(
        expression: 'Catch up',
        meaning: 'To talk with someone you have not seen for a while',
        example: 'Let us grab a coffee and catch up sometime.',
      ),
      ScenarioPhrase(
        expression: 'On the same page',
        meaning: 'To have the same understanding as someone else',
        example: 'Before we start, let us make sure we are on the same page.',
      ),
      ScenarioPhrase(
        expression: 'Touch base',
        meaning: 'To make brief contact with someone',
        example: 'I will touch base with you later this week.',
      ),
      ScenarioPhrase(
        expression: 'Keep in touch',
        meaning: 'To stay in contact with someone',
        example: 'It was great seeing you — let us keep in touch!',
      ),
    ],
    'work': [
      ScenarioPhrase(
        expression: 'Hit the ground running',
        meaning: 'To start something quickly and with great energy',
        example: 'She hit the ground running on her first day at the new job.',
      ),
      ScenarioPhrase(
        expression: 'Go the extra mile',
        meaning: 'To make more effort than is expected',
        example: 'He always goes the extra mile for his clients.',
      ),
      ScenarioPhrase(
        expression: 'Think outside the box',
        meaning: 'To think creatively and differently',
        example: 'We need someone who can think outside the box to solve this.',
      ),
      ScenarioPhrase(
        expression: 'Touch base',
        meaning: 'To briefly connect or check in with a colleague',
        example: 'Can we touch base before the meeting tomorrow?',
      ),
      ScenarioPhrase(
        expression: 'Bring to the table',
        meaning: 'To offer something valuable to a group or situation',
        example: 'What skills can you bring to the table for this role?',
      ),
      ScenarioPhrase(
        expression: 'Get the ball rolling',
        meaning: 'To start something or get a process going',
        example: 'Let us get the ball rolling on this project today.',
      ),
    ],
    'flight': [
      ScenarioPhrase(
        expression: 'Off the beaten path',
        meaning: 'A place that is not commonly visited by tourists',
        example: 'We found a beautiful restaurant off the beaten path.',
      ),
      ScenarioPhrase(
        expression: 'When in Rome',
        meaning: 'To follow local customs when visiting a new place',
        example: 'I tried the local food — when in Rome!',
      ),
      ScenarioPhrase(
        expression: 'Get away',
        meaning: 'To go on a holiday or short trip',
        example: 'We decided to get away for the weekend.',
      ),
      ScenarioPhrase(
        expression: 'Live out of a suitcase',
        meaning: 'To travel so much that you rarely stay home',
        example: 'As a flight attendant, she lives out of a suitcase.',
      ),
      ScenarioPhrase(
        expression: 'Around the clock',
        meaning: 'Available or happening 24 hours a day',
        example: 'The hotel offers around the clock room service.',
      ),
      ScenarioPhrase(
        expression: 'In the vicinity',
        meaning: 'In the nearby area',
        example: 'Are there any good restaurants in the vicinity?',
      ),
    ],
    'school': [
      ScenarioPhrase(
        expression: 'Hit the books',
        meaning: 'To study hard',
        example: 'I need to hit the books before the exam tomorrow.',
      ),
      ScenarioPhrase(
        expression: 'Burn the midnight oil',
        meaning: 'To work or study late into the night',
        example: 'She burned the midnight oil to finish her assignment.',
      ),
      ScenarioPhrase(
        expression: 'Pass with flying colours',
        meaning: 'To succeed at something easily and with high marks',
        example: 'He passed the exam with flying colours.',
      ),
      ScenarioPhrase(
        expression: 'Learn the ropes',
        meaning: 'To learn the basics of something new',
        example: 'It took a few weeks to learn the ropes at the new school.',
      ),
      ScenarioPhrase(
        expression: 'A steep learning curve',
        meaning: 'Something that is difficult to learn quickly',
        example: 'Programming was a steep learning curve at first.',
      ),
      ScenarioPhrase(
        expression: 'Put your thinking cap on',
        meaning: 'To think carefully about something',
        example: 'Put your thinking cap on — this question is tricky.',
      ),
    ],
    'restaurant': [
      ScenarioPhrase(
        expression: 'Eat out',
        meaning: 'To have a meal at a restaurant rather than at home',
        example: 'We decided to eat out instead of cooking tonight.',
      ),
      ScenarioPhrase(
        expression: 'A bite to eat',
        meaning: 'A small meal or snack',
        example: 'Do you want to grab a bite to eat before the film?',
      ),
      ScenarioPhrase(
        expression: 'On the house',
        meaning: 'Free of charge, paid for by the restaurant',
        example: 'The dessert is on the house — enjoy!',
      ),
      ScenarioPhrase(
        expression: 'Have a taste for',
        meaning: 'To want or enjoy a particular type of food',
        example: 'I have a taste for something spicy tonight.',
      ),
      ScenarioPhrase(
        expression: 'Wolf down',
        meaning: 'To eat very quickly',
        example: 'He wolfed down his lunch before the meeting.',
      ),
      ScenarioPhrase(
        expression: 'A table for two',
        meaning: 'A common phrase used when booking or requesting a restaurant table',
        example: 'Good evening, I have a reservation — a table for two please.',
      ),
    ],
    'local_hospital': [
      ScenarioPhrase(
        expression: 'Under the weather',
        meaning: 'Feeling ill or unwell',
        example: 'I have been feeling under the weather all week.',
      ),
      ScenarioPhrase(
        expression: 'On the mend',
        meaning: 'Recovering from an illness or injury',
        example: 'She is on the mend after her operation.',
      ),
      ScenarioPhrase(
        expression: 'Fighting fit',
        meaning: 'In very good health',
        example: 'After a week of rest he was fighting fit again.',
      ),
      ScenarioPhrase(
        expression: 'A bitter pill to swallow',
        meaning: 'Something unpleasant that must be accepted',
        example: 'The diagnosis was a bitter pill to swallow.',
      ),
      ScenarioPhrase(
        expression: 'Get a second opinion',
        meaning: 'To ask another expert for their view on something',
        example: 'I decided to get a second opinion from another doctor.',
      ),
      ScenarioPhrase(
        expression: 'Take it easy',
        meaning: 'To rest and not do too much',
        example: 'The doctor told me to take it easy for a few days.',
      ),
    ],
    'sports': [
      ScenarioPhrase(
        expression: 'On the ball',
        meaning: 'Alert, quick to understand and react',
        example: 'The new player is really on the ball during training.',
      ),
      ScenarioPhrase(
        expression: 'Jump the gun',
        meaning: 'To start something too early or act too quickly',
        example: 'He jumped the gun by announcing the result before it was confirmed.',
      ),
      ScenarioPhrase(
        expression: 'Level playing field',
        meaning: 'A situation where everyone has an equal chance',
        example: 'The new rules create a level playing field for all teams.',
      ),
      ScenarioPhrase(
        expression: 'Throw in the towel',
        meaning: 'To give up or admit defeat',
        example: 'After three sets, he threw in the towel.',
      ),
      ScenarioPhrase(
        expression: 'Go the distance',
        meaning: 'To continue until the end despite difficulty',
        example: 'Despite her injury she went the distance and finished the race.',
      ),
      ScenarioPhrase(
        expression: 'Step up your game',
        meaning: 'To improve your performance or effort',
        example: 'If you want to make the team you need to step up your game.',
      ),
    ],
    'shopping_cart': [
      ScenarioPhrase(
        expression: 'Cost an arm and a leg',
        meaning: 'To be very expensive',
        example: 'That designer bag costs an arm and a leg.',
      ),
      ScenarioPhrase(
        expression: 'Snap up a bargain',
        meaning: 'To buy something quickly because it is a good deal',
        example: 'She snapped up a bargain in the sale.',
      ),
      ScenarioPhrase(
        expression: 'Window shopping',
        meaning: 'Looking at items in shop windows without buying anything',
        example: 'We spent the afternoon window shopping in the city centre.',
      ),
      ScenarioPhrase(
        expression: 'Splash out',
        meaning: 'To spend a lot of money on something special',
        example: 'We decided to splash out on a nice dinner for the anniversary.',
      ),
      ScenarioPhrase(
        expression: 'On a budget',
        meaning: 'Having a limited amount of money to spend',
        example: 'We are travelling on a budget so we look for deals.',
      ),
      ScenarioPhrase(
        expression: 'Get your money worth',
        meaning: 'To receive good value for what you have paid',
        example: 'At that price you really get your money worth.',
      ),
    ],
    'music_note': [
      ScenarioPhrase(
        expression: 'Face the music',
        meaning: 'To accept the consequences of your actions',
        example: 'He made a mistake and now he has to face the music.',
      ),
      ScenarioPhrase(
        expression: 'Change your tune',
        meaning: 'To change your opinion or attitude',
        example: 'He was against the plan but he changed his tune after seeing the results.',
      ),
      ScenarioPhrase(
        expression: 'Strike a chord',
        meaning: 'To cause an emotional reaction or remind someone of something',
        example: 'Her speech really struck a chord with the audience.',
      ),
      ScenarioPhrase(
        expression: 'In tune with',
        meaning: 'To understand or be aware of something',
        example: 'A good teacher is always in tune with their students needs.',
      ),
      ScenarioPhrase(
        expression: 'Call the tune',
        meaning: 'To be in control of a situation',
        example: 'In this company the CEO calls the tune.',
      ),
      ScenarioPhrase(
        expression: 'Blow your own trumpet',
        meaning: 'To boast about your own achievements',
        example: 'I do not like to blow my own trumpet but I did well in the exam.',
      ),
    ],
  };

  static List<ScenarioPhrase> getPhrasesForIcon(String iconName) {
    return phrasesByIcon[iconName] ?? phrasesByIcon['chat_bubble']!;
  }

  static const List<ScenarioPhrase> generalPhrases = [
    ScenarioPhrase(
      expression: 'Break a leg',
      meaning: 'Good luck',
      example: 'Break a leg in your presentation today!',
    ),
    ScenarioPhrase(
      expression: 'Bite the bullet',
      meaning: 'To endure a painful situation with courage',
      example: 'I did not want to apologize but I bit the bullet and did it.',
    ),
    ScenarioPhrase(
      expression: 'Spill the beans',
      meaning: 'To reveal secret information accidentally',
      example: 'Do not spill the beans about the surprise party.',
    ),
    ScenarioPhrase(
      expression: 'Once in a blue moon',
      meaning: 'Very rarely',
      example: 'I only eat fast food once in a blue moon.',
    ),
    ScenarioPhrase(
      expression: 'Hit the nail on the head',
      meaning: 'To describe exactly what is causing a problem',
      example: 'You hit the nail on the head with that observation.',
    ),
    ScenarioPhrase(
      expression: 'Beat around the bush',
      meaning: 'To avoid talking about something directly',
      example: 'Stop beating around the bush and tell me what happened.',
    ),
  ];
}
