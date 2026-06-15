// lib/data/learn_content.dart
// Static content for the Learn section.
// To add more content later: just add a new item to the relevant list.
// No screen changes needed when adding content.

enum Difficulty { beginner, intermediate, advanced }

// ─── MODELS ───────────────────────────────────────────────────────────────────

class PassageItem {
  final String id;
  final String title;
  final String topic;
  final Difficulty difficulty;
  final String body;
  const PassageItem({
    required this.id,
    required this.title,
    required this.topic,
    required this.difficulty,
    required this.body,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class StoryItem {
  final String id;
  final String title;
  final String origin;
  final Difficulty difficulty;
  final String body;
  final List<QuizQuestion> questions;
  const StoryItem({
    required this.id,
    required this.title,
    required this.origin,
    required this.difficulty,
    required this.body,
    required this.questions,
  });
}

class IdiomItem {
  final String id;
  final String idiom;
  final String meaning;
  final String example;
  final String? origin;
  final String category;
  const IdiomItem({
    required this.id,
    required this.idiom,
    required this.meaning,
    required this.example,
    this.origin,
    this.category = 'General',
  });
}

class GrammarGuide {
  final String id;
  final String title;
  final String explanation;
  final List<String> examples;
  final String commonMistake;
  const GrammarGuide({
    required this.id,
    required this.title,
    required this.explanation,
    required this.examples,
    required this.commonMistake,
  });
}

class ChildrenStory {
  final String id;
  final String title;
  final String origin;
  final String body;
  final String moral;
  final Difficulty difficulty;
  final List<QuizQuestion> questions;
  const ChildrenStory({
    required this.id,
    required this.title,
    required this.origin,
    required this.body,
    required this.moral,
    required this.difficulty,
    required this.questions,
  });
}

// ─── CONTENT ──────────────────────────────────────────────────────────────────

class LearnContent {

  // ── READING PASSAGES ───────────────────────────────────────────────────────
  // To add more: copy any PassageItem block and add it to the list below.

  static const List<PassageItem> passages = [

    // BEGINNER
    PassageItem(
      id: 'p1',
      title: 'My Daily Routine',
      topic: 'Everyday Life',
      difficulty: Difficulty.beginner,
      body: '''Every morning I wake up at seven o\'clock. First, I brush my teeth and wash my face. Then I go to the kitchen and make breakfast. I usually eat bread with butter and drink a cup of tea.

After breakfast, I get dressed and leave the house. I walk to the bus stop and take the bus to school. Classes start at eight thirty. I study English, Mathematics, and Science.

At noon, I eat lunch with my friends in the school cafeteria. In the afternoon, I have more classes. School finishes at three o\'clock.

When I get home, I do my homework. In the evening, I watch television or read a book. I go to bed at ten o\'clock. I enjoy my daily routine because it keeps me organised.''',
    ),

    PassageItem(
      id: 'p2',
      title: 'The Market',
      topic: 'Shopping',
      difficulty: Difficulty.beginner,
      body: '''Every Saturday morning, my mother and I go to the market. The market is a busy and colourful place. There are many stalls selling fruits, vegetables, meat, and fish.

My mother always buys fresh tomatoes, onions, and potatoes. She also buys apples and oranges for us to eat during the week. The fruit seller is a friendly old man who always gives us an extra apple for free.

At the market, people talk loudly and bargain for lower prices. The smell of fresh bread from the bakery stall fills the air. I love the smell of warm bread in the morning.

After shopping, we carry our bags home. My mother cooks a delicious lunch with everything she bought. Saturday is my favourite day of the week because of the market and the good food.''',
    ),

    // INTERMEDIATE
    PassageItem(
      id: 'p3',
      title: 'The Eiffel Tower',
      topic: 'Culture & Travel',
      difficulty: Difficulty.intermediate,
      body: '''The Eiffel Tower is one of the most recognised structures in the world. It stands in the heart of Paris, France, on the Champ de Mars near the Seine River. Every year, millions of tourists from around the globe visit this iconic landmark.

The tower was designed by the French engineer Gustave Eiffel and was built between 1887 and 1889. It was constructed as the entrance arch for the 1889 World\'s Fair, which celebrated the centennial of the French Revolution. At the time of its completion, it was the tallest man-made structure in the world, standing at 300 metres.

When the tower was first proposed, many Parisians were opposed to it. Artists and intellectuals called it an eyesore and signed a petition against its construction. However, public opinion gradually changed, and today it is one of France\'s most beloved symbols.

The Eiffel Tower is made of wrought iron and weighs approximately 7,300 tonnes. It has three floors open to the public, and visitors can reach the top by lift or by climbing 1,665 steps. From the top, on a clear day, you can see up to 70 kilometres in every direction.

Today the tower serves as a broadcasting tower and is lit up every evening with thousands of sparkling lights, making it a magical sight against the Parisian sky.''',
    ),

    PassageItem(
      id: 'p4',
      title: 'The History of Chocolate',
      topic: 'Food & History',
      difficulty: Difficulty.intermediate,
      body: '''Chocolate is one of the most popular foods in the world today, but its history stretches back thousands of years to the ancient civilisations of Central America.

The cacao tree, from which chocolate is made, was first cultivated by the Maya people around 1500 BC. The Maya used cacao beans to make a bitter drink mixed with water, chilli, and spices. This drink was considered sacred and was used in religious ceremonies and offered to the gods.

When the Spanish explorer Hernán Cortés arrived in Mexico in the 1500s, he encountered this cacao drink at the court of the Aztec emperor Montezuma. The Spanish brought cacao beans back to Europe, where sugar was added to make the drink sweeter and more appealing to European tastes.

For many years, chocolate remained a luxury drink enjoyed only by the wealthy. It was not until the 19th century that solid chocolate was invented. In 1847, a British company called J.S. Fry and Sons created the first chocolate bar by mixing cocoa butter, cocoa powder, and sugar.

Today, the global chocolate industry is worth over 100 billion dollars. Switzerland and Belgium are famous for their high-quality chocolate, and the average person in some European countries eats more than ten kilograms of chocolate per year.''',
    ),

    // ADVANCED
    PassageItem(
      id: 'p5',
      title: 'Artificial Intelligence and the Future of Work',
      topic: 'Technology',
      difficulty: Difficulty.advanced,
      body: '''The rapid advancement of artificial intelligence is fundamentally reshaping the landscape of employment across virtually every sector of the global economy. While technological revolutions have historically displaced certain categories of work only to generate new forms of employment in their wake, the current wave of AI-driven automation raises questions that economists, policymakers, and philosophers are only beginning to grapple with seriously.

Unlike previous automation waves, which primarily affected routine manual tasks, contemporary AI systems are increasingly capable of performing complex cognitive functions — from legal research and medical diagnosis to creative writing and financial analysis. This encroachment into knowledge work territory has unsettled assumptions that had long comforted the professional classes, who had previously viewed automation as a problem that afflicted factory workers rather than themselves.

Proponents of technological optimism argue that AI will augment human capabilities rather than replace them, pointing to historical precedent. The introduction of spreadsheet software in the 1980s, for instance, did not eliminate accountants; rather, it transformed their role and significantly expanded demand for their higher-order analytical skills. Similarly, AI advocates suggest that as machines absorb routine cognitive tasks, humans will be freed to focus on work requiring emotional intelligence, ethical judgment, and creative problem-solving.

Critics, however, contend that this time may genuinely be different. The pace of AI development, they argue, may outstrip the economy\'s capacity to generate new employment categories quickly enough to absorb displaced workers. Furthermore, the transition costs — retraining workers, restructuring educational systems, reforming social safety nets — are likely to fall disproportionately on those least equipped to bear them.

What seems certain is that navigating this transition will require deliberate choices about how societies wish to distribute both the productivity gains and the disruptions that AI will inevitably bring.''',
    ),

    PassageItem(
      id: 'p6',
      title: 'The Psychology of Procrastination',
      topic: 'Psychology',
      difficulty: Difficulty.advanced,
      body: '''Procrastination — the voluntary delay of an intended course of action despite expecting to be worse off for the delay — is one of the most pervasive yet poorly understood phenomena in human behaviour. Affecting an estimated 20 percent of adults chronically and virtually everyone occasionally, it represents a striking failure of self-regulation that has significant consequences for productivity, wellbeing, and mental health.

Popular discourse tends to frame procrastination as a time management problem, a characterisation that has spawned an enormous self-help industry built around productivity systems, scheduling techniques, and motivational strategies. Yet this framing, researchers increasingly argue, fundamentally misdiagnoses the condition. Procrastination is not primarily a failure to manage time; it is a failure to manage emotions.

The temporal motivation theory, developed by psychologists Piers Steel and Cornelius König, proposes that the appeal of a task diminishes in proportion to its distance in time and increases with its immediacy. When a deadline is distant, the emotional costs of beginning an unpleasant task — boredom, anxiety, self-doubt — loom larger in our subjective experience than the abstract future benefits of completion. As the deadline approaches, this calculus inverts, producing the familiar last-minute surge of productivity.

Neurologically, procrastination appears to involve a conflict between the limbic system, which governs immediate emotional responses, and the prefrontal cortex, responsible for long-term planning and rational decision-making. In individuals with a relatively more reactive limbic system, the pull toward immediate emotional comfort consistently overrides longer-term intentions.

Effective interventions, therefore, tend to target emotional regulation rather than time allocation. Techniques such as self-compassion, implementation intentions, and the decomposition of tasks into emotionally manageable steps have demonstrated considerably more efficacy than conventional time management approaches in controlled studies.''',
    ),
  ];

  // ── SHORT STORIES ──────────────────────────────────────────────────────────
  // To add more: copy any StoryItem block and add it to the list below.

  static const List<StoryItem> stories = [

    // BEGINNER (2 stories)
    StoryItem(
      id: 's1',
      title: 'The Kind Boy and the Bird',
      origin: 'Original',
      difficulty: Difficulty.beginner,
      body: '''One day, a boy named Tom was walking in the park. He saw a small bird on the ground. The bird could not fly. Its wing was hurt.

Tom picked up the bird carefully. He took it home. He made a small box with soft cloth for the bird to rest in. Every day, Tom gave the bird water and small pieces of bread.

After two weeks, the bird\'s wing was better. Tom took the bird back to the park. He opened his hands and the bird flew up into the sky. Tom watched it fly and smiled.

He was happy because he helped the little bird. The bird sang a beautiful song before it disappeared into the trees.''',
      questions: const [
        QuizQuestion(
          question: 'What did the boy find in the garden?',
          options: ['A lost cat', 'An injured bird', 'A broken nest', 'A baby rabbit'],
          correctIndex: 1,
          explanation: 'The boy found an injured bird that could not fly.',
        ),
        QuizQuestion(
          question: 'What did the boy do when he found the bird?',
          options: ['Left it alone', 'Called for help', 'Took care of it', 'Put it back in a tree'],
          correctIndex: 2,
          explanation: 'The boy gently took care of the bird until it recovered.',
        ),
        QuizQuestion(
          question: 'What happened at the end of the story?',
          options: ['The bird flew away and never returned', 'The bird stayed as a pet', 'The bird recovered and flew away happily', 'The bird was taken to a vet'],
          correctIndex: 2,
          explanation: 'The bird recovered thanks to the boy kindness and flew away.',
        ),
      ],
    ),

    StoryItem(
      id: 's2',
      title: 'The Lost Dog',
      origin: 'Original',
      difficulty: Difficulty.beginner,
      body: '''Sara had a dog named Biscuit. One afternoon, Biscuit ran out of the garden when the gate was open. Sara looked everywhere but could not find him.

Sara made a sign with a picture of Biscuit. She wrote her phone number on the sign. She put the signs on trees and walls near her house.

The next morning, a woman called Sara. The woman had found Biscuit sitting outside her shop. Sara ran to the shop as fast as she could.

When she saw Biscuit, she hugged him tightly. She thanked the woman very much. On the way home, Sara bought a new lock for the garden gate so Biscuit could never run away again.''',
      questions: const [
        QuizQuestion(
          question: 'Why was the girl worried at the start?',
          options: ['She lost her keys', 'Her dog was missing', 'She was late for school', 'Her friend did not come'],
          correctIndex: 1,
          explanation: 'The girl could not find her dog and was very worried.',
        ),
        QuizQuestion(
          question: 'Where was the dog eventually found?',
          options: ['At a neighbor house', 'In the park', 'Under the bed', 'At the end of the street'],
          correctIndex: 2,
          explanation: 'The dog had been hiding under the bed the whole time.',
        ),
        QuizQuestion(
          question: 'What is the main lesson of this story?',
          options: ['Always keep your dog on a leash', 'Check obvious places before panicking', 'Dogs like to hide', 'Never leave a dog alone'],
          correctIndex: 1,
          explanation: 'The story shows that sometimes the answer is closer than we think.',
        ),
      ],
    ),

    // INTERMEDIATE (4 stories)
    StoryItem(
      id: 's3',
      title: 'The Necklace',
      origin: 'Adapted from Guy de Maupassant',
      difficulty: Difficulty.intermediate,
      body: '''Mathilde was a beautiful young woman who had married a modest government clerk. Though she had little money, she dreamed constantly of a life of luxury — fine dresses, jewellery, and elegant dinner parties.

One evening, her husband brought home an invitation to a grand reception at the Ministry. Instead of feeling joy, Mathilde burst into tears. She had nothing suitable to wear, she said, and no jewellery to adorn herself with.

Her husband gave her the money he had saved to buy a hunting rifle so she could buy a dress. For jewellery, a friend lent her a beautiful diamond necklace. At the reception, Mathilde was the most admired woman in the room. She danced all night, intoxicated by the attention.

When she arrived home, she reached for the necklace — and found her neck bare. It was gone. After a desperate search, they could not find it. Too ashamed to tell the truth, they borrowed money and bought a replacement necklace that cost thirty-six thousand francs.

They spent the next ten years paying off the debt, working themselves to exhaustion. When the debt was finally cleared, Mathilde met her old friend by chance in the street. She told her the whole story.

Her friend stared at her, then took her hands gently. "Oh, my poor Mathilde," she said. "The necklace I lent you was made of paste. It was worth no more than five hundred francs."''',
      questions: const [
        QuizQuestion(
          question: 'Why did Mathilde borrow the necklace?',
          options: ['To sell it', 'To wear to a party', 'To impress her husband', 'To give as a gift'],
          correctIndex: 1,
          explanation: 'Mathilde borrowed the necklace to wear to an elegant party.',
        ),
        QuizQuestion(
          question: 'What happened to the necklace?',
          options: ['It was stolen', 'She sold it', 'She lost it', 'She broke it'],
          correctIndex: 2,
          explanation: 'Mathilde lost the necklace after the party.',
        ),
        QuizQuestion(
          question: 'How long did it take to pay off the debt?',
          options: ['2 years', '5 years', '10 years', '20 years'],
          correctIndex: 2,
          explanation: 'They spent ten years working hard to repay the money to replace the necklace.',
        ),
        QuizQuestion(
          question: 'What was the twist at the end?',
          options: ['The necklace was real gold', 'The necklace was fake', 'Her friend had another necklace', 'The debt was forgiven'],
          correctIndex: 1,
          explanation: 'The original necklace was costume jewelry worth almost nothing.',
        ),
      ],
    ),

    StoryItem(
      id: 's4',
      title: 'The Gift of the Magi',
      origin: 'Adapted from O. Henry',
      difficulty: Difficulty.intermediate,
      body: '''Della counted her money for the third time. One dollar and eighty-seven cents. That was all. Tomorrow was Christmas, and she had only that amount to buy a gift for her husband Jim.

Della had two great treasures: her long, beautiful brown hair that fell below her knees, and Jim\'s gold watch that had belonged to his grandfather. These were the things they were most proud of.

Suddenly, Della had an idea. She went to a shop that bought hair. "Twenty dollars," said the shopkeeper. Della sold her hair and spent the afternoon searching every shop until she found the perfect gift: a platinum chain for Jim\'s gold watch. It cost twenty-one dollars.

That evening Jim came home and stopped at the door, staring at Della with an expression she could not read. Della explained nervously that she had sold her hair to buy him a gift for Christmas.

Jim reached into his pocket and placed a package on the table. Inside were a set of beautiful combs — the tortoiseshell combs with jewelled edges that Della had admired in a shop window for years.

Then Della held out the watch chain. Jim sat down on the sofa and laughed. He had sold his gold watch to buy the combs for her hair.

Of all those who give and receive gifts, such as they are the wisest. They are the magi.''',
      questions: const [
        QuizQuestion(
          question: 'What did Della sell to buy Jim a gift?',
          options: ['Her ring', 'Her hair', 'Her coat', 'Her watch'],
          correctIndex: 1,
          explanation: 'Della sold her beautiful long hair to get money for Jim gift.',
        ),
        QuizQuestion(
          question: 'What did Jim sell to buy Della a gift?',
          options: ['His car', 'His coat', 'His watch', 'His ring'],
          correctIndex: 2,
          explanation: 'Jim sold his prized gold watch to buy combs for Della hair.',
        ),
        QuizQuestion(
          question: 'What is the main theme of this story?',
          options: ['Money is important', 'True love involves sacrifice', 'Gifts should be practical', 'Planning ahead is wise'],
          correctIndex: 1,
          explanation: 'The story celebrates selfless love — each gave up their most precious possession for the other.',
        ),
      ],
    ),

    StoryItem(
      id: 's5',
      title: 'The Old Man and the Sea — An Excerpt',
      origin: 'Adapted from Ernest Hemingway',
      difficulty: Difficulty.intermediate,
      body: '''The old man was thin and gaunt with deep wrinkles in the back of his neck. The brown blotches of the sun on his cheeks were like the marks left by an old wound. Everything about him was old except his eyes, which were the same colour as the sea and were cheerful and undefeated.

Santiago had gone eighty-four days now without taking a fish. For the first forty days a boy had been with him, but after forty days without a fish the boy\'s parents had told him that the old man was now definitely and finally unlucky.

On the eighty-fifth day before it was light the old man took his fishing gear down to his skiff and rowed out into the dark water alone. He was going further out than usual, to the deep water where the great fish lived.

By noon he had a fish on his line — something immense and powerful. The fish pulled his boat further out to sea and would not surface. The old man held the line across his back and waited. His hands were cut by the cord.

He talked to the fish quietly. "Fish," he said, "I love you and respect you very much. But I will kill you before this day ends." He knew it might take a long time. He did not mind. A man can be destroyed but not defeated.''',
      questions: const [
        QuizQuestion(
          question: 'What is the old man trying to catch in the story?',
          options: ['A whale', 'A giant marlin', 'A shark', 'A swordfish'],
          correctIndex: 1,
          explanation: 'The old man Santiago struggles alone at sea to catch a giant marlin.',
        ),
        QuizQuestion(
          question: 'What does the old man struggle against besides the fish?',
          options: ['A storm', 'Other fishermen', 'His own age and exhaustion', 'A broken boat'],
          correctIndex: 2,
          explanation: 'Santiago battles his own physical limits — age, pain, and exhaustion — throughout the ordeal.',
        ),
        QuizQuestion(
          question: 'What is the main theme of this story?',
          options: ['The danger of the sea', 'Human endurance and dignity in the face of defeat', 'The importance of fishing', 'Nature is always stronger than man'],
          correctIndex: 1,
          explanation: 'Hemingway explores how a person can be destroyed but not defeated through Santiago struggle.',
        ),
      ],
    ),

    StoryItem(
      id: 's6',
      title: 'The Happy Prince',
      origin: 'Adapted from Oscar Wilde',
      difficulty: Difficulty.intermediate,
      body: '''High above the city, on a tall column, stood the statue of the Happy Prince. He was covered all over with thin leaves of fine gold, and for eyes he had two bright sapphires, and a great red ruby glowed on his sword-hilt.

One night a small Swallow flew over the city. He was on his way to Egypt but stopped to rest at the feet of the statue. As he settled to sleep, a large drop of water fell on him, then another. He looked up and saw that the eyes of the Happy Prince were filled with tears.

"Why are you weeping?" asked the Swallow.

"When I was alive and had a human heart," answered the statue, "I did not know what tears were. But now, though I am made of metal, I can see all the suffering of my city, and my heart is made of lead and I cannot choose but weep."

The Prince asked the Swallow to carry his ruby to a poor seamstress whose child was sick with fever. Then his sapphire eyes to a starving writer and a cold match-girl. Each time, the Swallow meant to leave, but stayed one more night.

When the Swallow had given away everything, he lay down at the Prince\'s feet and died. At that moment, the statue\'s lead heart cracked in two.

The city council melted down the statue as it had grown shabby. But the broken lead heart would not melt in the furnace and was thrown away. In another place, God said to his angels: "Bring me the two most precious things in the city." And they brought him the lead heart and the dead bird.''',
      questions: const [
        QuizQuestion(
          question: 'What does the Happy Prince ask the swallow to do?',
          options: ['Bring him food', 'Carry his jewels and gold to the poor', 'Fly him to another city', 'Find him a friend'],
          correctIndex: 1,
          explanation: 'The Happy Prince asks the swallow to take his jewels gold and gold leaf to help the suffering poor.',
        ),
        QuizQuestion(
          question: 'Why does the swallow stay with the prince instead of flying south?',
          options: ['The weather is too cold', 'He falls in love with the prince sword', 'He chooses to help the prince with his mission', 'He is injured'],
          correctIndex: 2,
          explanation: 'The swallow stays out of loyalty and compassion choosing the prince mission over his own survival.',
        ),
        QuizQuestion(
          question: 'What happens to both the prince and the swallow at the end?',
          options: ['They are rewarded by the king', 'They are taken to heaven as the two most precious things in the city', 'The swallow flies away and the prince is repaired', 'They are forgotten'],
          correctIndex: 1,
          explanation: 'God calls them the two most precious things and takes them to paradise.',
        ),
      ],
    ),

    // ADVANCED (8 stories)
    StoryItem(
      id: 's7',
      title: 'The Most Dangerous Game',
      origin: 'Adapted from Richard Connell',
      difficulty: Difficulty.advanced,
      body: '''Rainsford had fallen off the yacht in the darkness and swum to the nearest shore — a dark island that sailors called Ship-Trap Island with dread in their voices. By morning he had found a palatial château and its owner, General Zaroff, a Russian aristocrat of great refinement who welcomed him with every courtesy.

Zaroff was a hunter of legendary skill who had grown bored with every quarry the world offered. Lions, tigers, buffalo — they no longer provided the intellectual challenge the sport demanded, he explained over an exquisite dinner. He had therefore stocked his island with a new animal — one that could reason.

Rainsford understood with cold horror that Zaroff meant human beings. Sailors lured by false lights onto the rocks, then given a knife, a head start of three hours, and three days to survive the jungle while Zaroff hunted them with a small-calibre pistol. Those who lasted three days earned their freedom. None ever had.

The next morning, Rainsford entered the jungle. For three days he used every skill he possessed — Navy trap, Malay man-catcher, pit with stakes — each delaying Zaroff but never stopping him. The general seemed to be enjoying himself thoroughly.

On the third night, cornered at the cliff\'s edge, Rainsford leapt into the sea below.

That evening, Zaroff dined alone, a little disappointed. He went to his bedroom, lit a cigarette, and opened a book. A man emerged from behind the curtain.

"Congratulations," said Rainsford. "You have been found."

Zaroff smiled. "You have won the game."

Rainsford did not smile. "I am still a beast at bay," he said. He had not come to talk.

He slept that night in the very excellent bed of General Zaroff.''',
      questions: const [
        QuizQuestion(
          question: 'What does General Zaroff hunt on his island?',
          options: ['Wild animals', 'Human beings', 'Rare birds', 'Sea creatures'],
          correctIndex: 1,
          explanation: 'Zaroff has grown bored of hunting animals and now hunts humans for sport.',
        ),
        QuizQuestion(
          question: 'What choice does Zaroff give Rainsford?',
          options: ['Leave the island or be a servant', 'Be hunted for three days or be turned over to Ivan', 'Join him in hunting or be killed immediately', 'Swim to safety or be hunted'],
          correctIndex: 1,
          explanation: 'Zaroff gives Rainsford the choice of being hunted for three days or facing Ivan.',
        ),
        QuizQuestion(
          question: 'What is the central irony of the story?',
          options: ['The hunter becomes the hunted', 'The island is actually safe', 'Zaroff is a coward', 'Rainsford admires Zaroff'],
          correctIndex: 0,
          explanation: 'Rainsford the skilled hunter experiences what it feels like to be prey — the hunter becomes the hunted.',
        ),
      ],
    ),

    StoryItem(
      id: 's8',
      title: 'The Yellow Wallpaper',
      origin: 'Adapted from Charlotte Perkins Gilman',
      difficulty: Difficulty.advanced,
      body: '''John is a physician, and perhaps that is one reason I do not get well faster. You see, he does not believe I am sick. If a physician of high standing, and one\'s own husband, assures friends and relatives that there is really nothing the matter with one but temporary nervous depression, what is one to do?

John laughs at me, of course, but one expects that in marriage.

He has taken me to this colonial mansion for the summer. There is something strange about the house — I can feel it. John says I am to have perfect rest and fresh air. I am absolutely forbidden to work until I am well again. Personally, I believe that congenial work would do me good.

The room he has chosen for me is at the top of the house. It has barred windows and a great immovable bed nailed to the floor. The wallpaper is the most repellent thing I have ever encountered — a smouldering, unclean yellow with a pattern that commits every artistic sin. It sprawls and flounders in the most confusing way.

But I begin to see a figure behind the pattern. A woman, stooping down and creeping behind it. At night she shakes the pattern. By day she is still, for she knows John watches.

I have pulled off most of the paper now. The woman is quite free of the pattern. I watch her creep along the garden path below in the open daylight.

John tried to open the locked door. When he finally got in, he found me creeping along the wall.

"What is the matter?" he cried.

"I have got out at last," I said, "and you cannot put me back. For I have peeled off most of the paper, so you cannot put me back."

John fainted. I had to creep over him every time.''',
      questions: const [
        QuizQuestion(
          question: 'Why is the narrator confined to the room?',
          options: ['As punishment', 'Her husband believes rest will cure her nervous condition', 'She chose to stay', 'She is physically ill'],
          correctIndex: 1,
          explanation: 'Her physician husband prescribes complete rest and confines her to the room for her nervous condition.',
        ),
        QuizQuestion(
          question: 'What does the narrator begin to see in the wallpaper?',
          options: ['Flowers and patterns', 'A woman trapped behind bars', 'Her own reflection', 'Moving shadows'],
          correctIndex: 1,
          explanation: 'The narrator becomes obsessed with what she sees as a woman trapped behind the wallpaper pattern.',
        ),
        QuizQuestion(
          question: 'What does the wallpaper symbolize?',
          options: ['Beauty and art', 'The oppression of women in the 19th century', 'Mental illness only', 'Isolation from nature'],
          correctIndex: 1,
          explanation: 'The wallpaper symbolizes the social and domestic constraints that trap women.',
        ),
      ],
    ),

    StoryItem(
      id: 's9',
      title: 'The Lottery',
      origin: 'Adapted from Shirley Jackson',
      difficulty: Difficulty.advanced,
      body: '''The morning of June 27th was clear and sunny, with the fresh warmth of a full-summer day. The people of the village began to gather in the square at ten o\'clock. The children came first, boys collecting stones and making a pile in the corner. The adults followed, speaking of farming and taxes and rain.

The lottery was conducted by Mr. Summers, who had time and energy to devote to civic activities. He arrived carrying the black wooden box, which was shabby and faded and no longer fully black. The lottery had been held so long that no one remembered its original purpose, and much of the original ceremony had been forgotten or abandoned.

Each head of household drew a slip of paper from the box. The crowd was nervous and laughing, the laughter fading quickly.

Bill Hutchinson drew the marked slip. His wife Tessie immediately protested that he had not had enough time to choose.

"Be a good sport, Tessie," her friends said.

Each member of the Hutchinson family then drew. Tessie drew the marked slip.

The villagers had already picked up their stones. Tessie said it wasn\'t fair, but the lottery had always been done this way.

"Come on, come on, everyone," said Old Man Warner, who had participated in seventy-seven lotteries.

The first stone hit her on the side of the head. Tessie Hutchinson said it wasn\'t fair, wasn\'t right, until the very end. Her neighbours and friends and family closed in around her, stones in their hands.''',
      questions: const [
        QuizQuestion(
          question: 'What is the mood at the beginning of the story?',
          options: ['Dark and gloomy', 'Cheerful and normal', 'Frightening and tense', 'Sad and quiet'],
          correctIndex: 1,
          explanation: 'The story begins on a seemingly normal cheerful summer day to contrast with the dark ending.',
        ),
        QuizQuestion(
          question: 'What is the true purpose of the lottery?',
          options: ['To win money', 'To choose a community leader', 'To select someone to be stoned', 'To decide who plants crops'],
          correctIndex: 2,
          explanation: 'The lottery is a violent ritual where the winner is stoned to death by the community.',
        ),
        QuizQuestion(
          question: 'What does the story criticize?',
          options: ['Modern technology', 'Blind tradition and conformity', 'Government corruption', 'Rural life'],
          correctIndex: 1,
          explanation: 'The story is a critique of blindly following traditions without questioning their purpose.',
        ),
      ],
    ),

    StoryItem(
      id: 's10',
      title: 'An Occurrence at Owl Creek Bridge',
      origin: 'Adapted from Ambrose Bierce',
      difficulty: Difficulty.advanced,
      body: '''A man stood upon a railroad bridge in northern Alabama, looking down into the swift water below. The man\'s hands were behind his back, the wrists bound with a cord. A rope closely encircled his neck. He was Peyton Farquhar, a well-to-do planter, devoted to the Southern cause, who had been caught attempting to sabotage the bridge.

The sergeant stepped aside and Farquhar fell.

The rope broke. He struck the water with a noise like the sound of a cannon. Plunging, rising, he freed his hands and clawed at the rope at his throat. He rose to the surface gasping. The soldiers on the bridge fired at him but missed. He was carried downstream, swimming desperately.

He reached the bank and crawled into the forest. All day he travelled through the forest toward his home, his wife, his children. Strange flowers grew along the path. The air was filled with an unfamiliar and overpowering fragrance.

At last he saw the white gate of his home. His wife stood at the bottom of the steps. He ran forward with arms extended, reaching for her.

He felt a stunning blow upon the back of his neck. A blinding white light blazed all about him. Then all was darkness and silence.

Peyton Farquhar was dead. His body, with a broken neck, swung gently from side to side beneath the timbers of the Owl Creek Bridge.

He had never left it.''',
      questions: const [
        QuizQuestion(
          question: 'What is happening to Peyton Farquhar at the start of the story?',
          options: ['He is escaping from prison', 'He is about to be hanged', 'He is crossing a bridge', 'He is fighting in a battle'],
          correctIndex: 1,
          explanation: 'Peyton Farquhar is standing on a bridge about to be executed by hanging.',
        ),
        QuizQuestion(
          question: 'What does the middle section of the story describe?',
          options: ['A real escape from the bridge', 'A dream or hallucination during death', 'His life before the war', 'A rescue by his wife'],
          correctIndex: 1,
          explanation: 'The middle section is Farquhar vivid hallucination of escape happening in the final moments of death.',
        ),
        QuizQuestion(
          question: 'What is the twist at the end of the story?',
          options: ['He successfully escapes', 'The war ends and he is freed', 'The escape was an illusion and he dies', 'His family saves him'],
          correctIndex: 2,
          explanation: 'The entire escape sequence was a dying hallucination — Farquhar dies on the bridge.',
        ),
      ],
    ),

    StoryItem(
      id: 's11',
      title: 'The Tell-Tale Heart',
      origin: 'Adapted from Edgar Allan Poe',
      difficulty: Difficulty.advanced,
      body: '''True — nervous — very, very dreadfully nervous I had been and am; but why will you say that I am mad? The disease had sharpened my senses, not destroyed them. Above all was the sense of hearing acute. I heard all things in the heaven and in the earth. I heard many things in hell. How, then, am I mad?

It is impossible to say how first the idea entered my brain; but once conceived, it haunted me day and night. The old man had never wronged me. He had never given me insult. I had no desire for his gold. I think it was his eye — a pale blue eye, with a film over it — whenever it fell upon me, my blood ran cold.

Every night for seven nights, at midnight, I opened his door and put in my lantern until a single ray fell upon his vulture eye. On the eighth night I was more than usually cautious. Never before that night had I felt the extent of my own powers, of my sagacity. I could scarcely contain my feelings of triumph.

When the deed was done I dismembered the body and concealed it beneath the floor. No stain of any kind. No blood-spot whatever.

When the officers came — a shriek had been heard by a neighbour — I showed them everything, smiling. I brought chairs into the very room and invited them to search. But soon I grew pale. I talked more freely to overcome the sensation. It increased. I found that the noise was not within my ears.

"Villains!" I shrieked. "Dissemble no more! I admit the deed — tear up the planks! Here, here! It is the beating of his hideous heart!"''',
      questions: const [
        QuizQuestion(
          question: 'Why does the narrator kill the old man?',
          options: ['For money', 'Out of hatred', 'Because of the old man eye', 'In self-defense'],
          correctIndex: 2,
          explanation: 'The narrator is obsessed with the old man pale filmy eye and kills him because of it.',
        ),
        QuizQuestion(
          question: 'What does the narrator hear after the murder?',
          options: ['Police sirens', 'The old man voice', 'A heartbeat', 'Footsteps'],
          correctIndex: 2,
          explanation: 'The narrator hears what he believes is the old man still-beating heart under the floorboards.',
        ),
        QuizQuestion(
          question: 'What does the heartbeat symbolize?',
          options: ['The old man ghost', 'The narrator guilt', 'A real sound the police hear', 'The narrator own heartbeat'],
          correctIndex: 1,
          explanation: 'The heartbeat represents the narrator overwhelming guilt driving him to confess.',
        ),
      ],
    ),

    StoryItem(
      id: 's12',
      title: 'The Metamorphosis — Opening',
      origin: 'Adapted from Franz Kafka',
      difficulty: Difficulty.advanced,
      body: '''One morning, when Gregor Samsa woke from troubled dreams, he found himself transformed in his bed into a horrible vermin. He lay on his hard, armour-like back, and if he lifted his head a little he could see his brown, arched abdomen divided by stiff arched segments, on top of which the blanket, ready to slip off altogether, was barely clinging. His many legs, pitifully thin compared to the rest of his bulk, flickered helplessly before his eyes.

"What has happened to me?" he thought. It was not a dream.

His first thought was practical. He was going to miss the five o\'clock train. He would have to explain to the head clerk. He was a commercial traveller. He owed his parents money. He had to keep this job.

His mother knocked on the door. "Gregor, it\'s a quarter to seven. Didn\'t you want to catch the train?" Her voice was sweet. His voice, when he answered, had a painful twittering squeak behind it.

The manager came from the office. His family pleaded with him to be patient. Gregor somehow opened the door. When they saw him, his mother collapsed. His father drove him back into the room with a newspaper and a walking stick, weeping.

In the weeks that followed, the room grew dusty. His sister left food for him and removed it, whatever remained. Gregor discovered that he preferred rotting food. He liked crawling on the walls and the ceiling.

One evening he crept out to hear his sister play the violin. His family and lodgers sat together. The lodgers, when they saw him, gave their notice. His father drove him back with a barrage of apples; one lodged in his back and remained there.

He thought of his family with tenderness and love. The decision that he must disappear was one he held, if possible, even more firmly than his sister. He remained in this state of vacant and peaceful meditation until the tower clock struck three in the morning. He lived until just before dawn. His last thought was that he loved them all.

The charwoman found him. "Come and look," she said. "It\'s dead. It\'s lying there dead as a doornail." She swept him out with the rubbish.''',
      questions: const [
        QuizQuestion(
          question: 'What has happened to Gregor at the start of the story?',
          options: ['He lost his job', 'He transformed into an insect', 'He fell ill', 'He had a nightmare'],
          correctIndex: 1,
          explanation: 'Gregor wakes up to find he has been transformed into a giant insect.',
        ),
        QuizQuestion(
          question: 'What was Gregor job before his transformation?',
          options: ['A teacher', 'A doctor', 'A traveling salesman', 'A banker'],
          correctIndex: 2,
          explanation: 'Gregor was a traveling salesman who worked hard to support his family.',
        ),
        QuizQuestion(
          question: 'What does Gregor transformation symbolize?',
          options: ['A physical illness', 'Alienation and feeling like a burden', 'Freedom from work', 'A punishment'],
          correctIndex: 1,
          explanation: 'Kafka uses the transformation to symbolize how people can feel alienated and dehumanized.',
        ),
      ],
    ),

    StoryItem(
      id: 's13',
      title: 'Harrison Bergeron',
      origin: 'Adapted from Kurt Vonnegut',
      difficulty: Difficulty.advanced,
      body: '''The year was 2081, and everybody was finally equal. They weren\'t only equal before God and the law. They were equal every which way. Nobody was smarter than anybody else. Nobody was better looking than anybody else. Nobody was stronger or quicker than anybody else. All this equality was due to the 211th, 212th, and 213th Amendments to the Constitution, and to the unceasing vigilance of agents of the United States Handicapper General.

Some things about living still weren\'t quite right, though. George, while his intelligence was way above normal, had a little mental handicap radio in his ear — he was required by law to wear it at all times. Every twenty seconds or so, the transmitter would send out some sharp noise to keep people like George from taking unfair advantage of their brains.

Harrison Bergeron, his fourteen-year-old son, was in jail, charged with attempting to overthrow the government.

On television, ballerinas danced — weighed down with sash-weights and bags of birdshot, masked so no one would feel inferior. Harrison appeared on screen, seven feet tall, a living earthquake. He declared himself Emperor. He removed his handicaps. He invited the most beautiful ballerina to be his Empress. Together they danced as no one had ever danced before, leaping thirty feet into the air.

Diana Moon Glampers, the Handicapper General, came into the studio with a shotgun. She fired twice, and the Emperor and Empress were dead.

George came back from the kitchen with a beer and asked what it was that had made Hazel cry. She said something sad on television but couldn\'t remember what. He said that was the thing about people — after a while, they forgot. She said that was true.''',
      questions: const [
        QuizQuestion(
          question: 'What is the purpose of the handicaps in this society?',
          options: ['To punish criminals', 'To make everyone equal', 'To control the population', 'To test citizens'],
          correctIndex: 1,
          explanation: 'The government forces talented people to wear handicaps to make everyone equal.',
        ),
        QuizQuestion(
          question: 'What does Harrison do when he appears on television?',
          options: ['Gives a speech', 'Removes his handicaps and dances freely', 'Escapes the country', 'Surrenders to authorities'],
          correctIndex: 1,
          explanation: 'Harrison tears off his handicaps and dances with a ballerina defying the system.',
        ),
        QuizQuestion(
          question: 'What is the story warning about enforced equality?',
          options: ['Equality is always good', 'Enforced equality destroys excellence and freedom', 'Society needs strong leaders', 'Technology is dangerous'],
          correctIndex: 1,
          explanation: 'Vonnegut warns that forcing everyone to be equal can destroy human potential and freedom.',
        ),
      ],
    ),

    StoryItem(
      id: 's14',
      title: 'The Star',
      origin: 'Adapted from H.G. Wells',
      difficulty: Difficulty.advanced,
      body: '''It was on the first day of the new year that the announcement was made, almost simultaneously from three observatories, that the motion of the planet Neptune had become very erratic. A vast mass of matter, dark and not reflecting enough light to be seen, was hurtling toward the solar system.

The mathematicians calculated its course. It would pass close to Jupiter, be deflected — and strike the Earth.

The news spread across the world. Some wept, some prayed, some began to take what pleasure remained in their dwindling time. Many refused to believe it.

The wandering star and Jupiter collided. The resulting mass, now brilliantly luminous, continued toward the inner planets. The world grew warmer. Glaciers melted. Seas rose. Storms of terrible ferocity swept the coasts. New mountain ranges collapsed. Cities fell under the weight of earthquakes.

The star passed. It grazed the Earth — near enough to raise the tides, to drench the equatorial regions in fire — and swept on and away.

The damage was enormous. The death toll was in the tens of millions. Coastlines had been remade. But the Earth endured.

A Martian astronomer, writing in the learned journal of his world, noted that the terrestrial catastrophe had been a relatively minor event. The star had, of course, caused some small derangement of the orbit and a temporary heating. But the astronomers of that dead cold world, peering through their instruments from so far away, had naturally failed to note the more significant observation: that across the face of that tiny world, in the ruins and the mud, small figures were already beginning to rebuild.''',
      questions: const [
        QuizQuestion(
          question: 'What event is being described at the start of the story?',
          options: ['A solar eclipse', 'A new star appearing that causes disasters on Earth', 'A meteor shower', 'The discovery of a new planet'],
          correctIndex: 1,
          explanation: 'A new star appears and its gravitational effects cause catastrophic floods storms and earthquakes on Earth.',
        ),
        QuizQuestion(
          question: 'How do most humans react to the approaching star?',
          options: ['With calm scientific interest', 'With panic fear and despair', 'With celebration', 'With prayer and hope'],
          correctIndex: 1,
          explanation: 'As the star approaches and disasters multiply most of humanity reacts with fear and despair.',
        ),
        QuizQuestion(
          question: 'What is the ironic twist at the very end of the story?',
          options: ['The star destroys Earth completely', 'Martian astronomers observe the event as a minor disturbance', 'The star misses Earth entirely', 'Humans escape to another planet'],
          correctIndex: 1,
          explanation: 'Martian astronomers casually note the event as a slight perturbation — what was catastrophic for Earth was insignificant to the universe.',
        ),
      ],
    ),
  ];

  // ── CHILDREN\'S STORIES ────────────────────────────────────────────────────
  // To add more: copy any ChildrenStory block and add it to the list below.

  static const List<ChildrenStory> childrenStories = [
    ChildrenStory(
      id: 'c1',
      title: 'The Tortoise and the Hare',
      origin: 'Aesop\'s Fables',
      body: '''Once there was a hare who was very fast. He always boasted to the other animals. "I am the fastest animal in the forest," he said. "Nobody can beat me."

One day, a tortoise said, "I will race you." All the animals laughed. The tortoise was very slow. But the tortoise was serious.

The race began. The hare ran very fast and was soon far ahead. He looked back and could not see the tortoise. "I have time to rest," he thought. He sat under a tree and fell asleep.

The tortoise walked slowly but never stopped. He passed the sleeping hare. He kept walking.

When the hare woke up, he ran as fast as he could. But he was too late. The tortoise had already crossed the finish line.

The tortoise won the race.''',
      moral: 'Slow and steady wins the race.',
      difficulty: Difficulty.beginner,
      questions: const [
        QuizQuestion(
          question: 'Why did the hare lose the race?',
          options: ['He was injured', 'He stopped to sleep and was overconfident', 'He took the wrong path', 'He let the tortoise win on purpose'],
          correctIndex: 1,
          explanation: 'The hare was so confident he would win that he stopped to rest and fell asleep.',
        ),
        QuizQuestion(
          question: 'What is the moral of this story?',
          options: ['Fast is always better', 'Slow and steady wins the race', 'Never race someone slower', 'Confidence leads to success'],
          correctIndex: 1,
          explanation: 'The story teaches that consistent effort can overcome natural talent or speed.',
        ),
      ],
    ),

    ChildrenStory(
      id: 'c2',
      title: 'The Lion and the Mouse',
      origin: 'Aesop\'s Fables',
      body: '''A lion was sleeping in the forest. A small mouse ran across his nose and woke him up. The lion was angry. He caught the mouse in his big paw.

"Please do not eat me," said the mouse. "One day I will help you."

The lion laughed. How could a tiny mouse help the king of the animals? But he let the mouse go.

A few days later, the lion was caught in a hunter\'s net. He roared and pulled but could not get free. The little mouse heard him. The mouse ran to the net and began to chew through the ropes with his small sharp teeth.

Soon there was a hole big enough for the lion to escape. The lion was free.

"Thank you, little mouse," said the lion. "You were right. A small friend can be a great friend."''',
      moral: 'No act of kindness, however small, is ever wasted.',
      difficulty: Difficulty.beginner,
      questions: const [
        QuizQuestion(
          question: 'Why did the lion let the mouse go free?',
          options: ['He was not hungry', 'The mouse made him laugh and he showed mercy', 'The mouse was too small', 'Other animals asked him to'],
          correctIndex: 1,
          explanation: 'The lion laughed at the mouse and decided to let him go out of amusement.',
        ),
        QuizQuestion(
          question: 'How did the mouse help the lion later?',
          options: ['By bringing food', 'By warning of danger', 'By chewing through the ropes of a net', 'By finding water'],
          correctIndex: 2,
          explanation: 'When the lion was trapped in a hunter net the mouse chewed through the ropes.',
        ),
        QuizQuestion(
          question: 'What does this story teach us?',
          options: ['Lions are dangerous', 'No act of kindness is too small', 'Mice are clever', 'Always avoid hunters'],
          correctIndex: 1,
          explanation: 'Even small creatures can help powerful ones — no kindness should be underestimated.',
        ),
      ],
    ),

    ChildrenStory(
      id: 'c3',
      title: 'The Boy Who Cried Wolf',
      origin: 'Aesop\'s Fables',
      body: '''A young shepherd boy watched the sheep on the hill every day. It was a lonely job and the boy was bored. One day, he thought of a way to have some fun.

"Wolf! Wolf!" he shouted. "A wolf is attacking the sheep!"

The farmers in the village ran up the hill to help. But there was no wolf. The boy laughed at them. The farmers went back to their work, feeling angry.

The next week, the boy did the same thing. "Wolf! Wolf!" he shouted again. The farmers ran up again. Again there was no wolf. They went back feeling very angry.

Then one day, a real wolf came. The boy shouted, "Wolf! Wolf! Please help me!" But the farmers thought the boy was lying again. Nobody came.

The wolf ate many of the sheep. The boy learned a very important lesson that day.''',
      moral: 'Nobody believes a liar, even when they tell the truth.',
      difficulty: Difficulty.beginner,
      questions: const [
        QuizQuestion(
          question: 'Why did the villagers stop believing the boy?',
          options: ['They were too busy', 'He had lied about the wolf too many times', 'They did not like him', 'They thought he was joking'],
          correctIndex: 1,
          explanation: 'The boy had falsely cried wolf many times as a prank so nobody believed him.',
        ),
        QuizQuestion(
          question: 'What happened when the real wolf came?',
          options: ['The villagers saved the sheep', 'The boy scared the wolf away', 'The wolf attacked and nobody came to help', 'The boy caught the wolf'],
          correctIndex: 2,
          explanation: 'When the real wolf appeared nobody came because they thought it was another lie.',
        ),
        QuizQuestion(
          question: 'What is the moral of this story?',
          options: ['Wolves are dangerous', 'Nobody believes a liar even when telling the truth', 'Always protect your sheep', 'Shepherds need helpers'],
          correctIndex: 1,
          explanation: 'If you lie repeatedly people will stop trusting you even when you tell the truth.',
        ),
      ],
    ),
  ];

  // ── IDIOMS ─────────────────────────────────────────────────────────────────
  // To add more: copy any IdiomItem block and add it to the list below.

  static const List<IdiomItem> idioms = [
    IdiomItem(id: 'i1', idiom: 'Break a leg', meaning: 'Good luck', example: '"Break a leg tonight!" said her friend before the performance.', origin: 'Theatre tradition — saying "good luck" was considered bad luck on stage.', category: 'General'),
    IdiomItem(id: 'i2', idiom: 'Hit the nail on the head', meaning: 'To describe exactly what is causing a situation or problem', example: '"You really hit the nail on the head with that analysis."', category: 'Work'),
    IdiomItem(id: 'i3', idiom: 'Under the weather', meaning: 'Feeling ill or unwell', example: '"I\'m feeling a bit under the weather today, so I\'ll stay home."', category: 'Health'),
    IdiomItem(id: 'i4', idiom: 'Bite the bullet', meaning: 'To endure a painful or difficult situation that is unavoidable', example: '"Just bite the bullet and apologise to him."', category: 'General'),
    IdiomItem(id: 'i5', idiom: 'Beat around the bush', meaning: 'To avoid talking about what is important', example: '"Stop beating around the bush and tell me what happened."', category: 'General'),
    IdiomItem(id: 'i6', idiom: 'Spill the beans', meaning: 'To reveal secret information accidentally', example: '"Don\'t spill the beans about the surprise party!"', category: 'General'),
    IdiomItem(id: 'i7', idiom: 'Cost an arm and a leg', meaning: 'To be very expensive', example: '"That new phone costs an arm and a leg."', category: 'Shopping'),
    IdiomItem(id: 'i8', idiom: 'Once in a blue moon', meaning: 'Very rarely', example: '"She only visits us once in a blue moon."', category: 'General'),
    IdiomItem(id: 'i9', idiom: 'Let the cat out of the bag', meaning: 'To accidentally reveal a secret', example: '"He let the cat out of the bag when he mentioned the gift."', category: 'General'),
    IdiomItem(id: 'i10', idiom: 'Kill two birds with one stone', meaning: 'To accomplish two things with a single action', example: '"I\'ll kill two birds with one stone by calling him on my way to the shop."', category: 'Work'),
    IdiomItem(id: 'i11', idiom: 'Bite off more than you can chew', meaning: 'To take on more responsibility than you can handle', example: '"She bit off more than she could chew by accepting three projects at once."', category: 'Work'),
    IdiomItem(id: 'i12', idiom: 'The ball is in your court', meaning: 'It is your turn to take action or make a decision', example: '"I\'ve made my offer. The ball is in your court now."', category: 'Sports'),
    IdiomItem(id: 'i13', idiom: 'Hit the books', meaning: 'To study hard', example: '"Exams are next week — time to hit the books."', category: 'School'),
    IdiomItem(id: 'i14', idiom: 'Miss the boat', meaning: 'To miss an opportunity', example: '"You missed the boat on that investment."', category: 'General'),
    IdiomItem(id: 'i15', idiom: 'Burn the midnight oil', meaning: 'To work or study late into the night', example: '"She was burning the midnight oil to finish her thesis."', category: 'School'),
  ];

  // ── GRAMMAR GUIDES ─────────────────────────────────────────────────────────
  // To add more: copy any GrammarGuide block and add it to the list below.

  static const List<GrammarGuide> grammarGuides = [
    GrammarGuide(
      id: 'g1',
      title: 'Articles: A, An, The',
      explanation: 'Use "a" before consonant sounds and "an" before vowel sounds when introducing something for the first time or talking about something non-specific. Use "the" when the listener already knows what you are referring to, or when there is only one of something.',
      examples: ['I saw a dog in the park. The dog was very friendly.', 'She is an engineer.', 'The sun rises in the east.', 'I need an umbrella — it\'s raining.'],
      commonMistake: 'Many learners forget to use articles entirely. Do not say "I am student" — say "I am a student."',
    ),
    GrammarGuide(
      id: 'g2',
      title: 'Present Perfect vs Simple Past',
      explanation: 'Use the Simple Past for actions completed at a specific time in the past. Use the Present Perfect for actions that happened at an unspecified time before now, or that connect the past to the present.',
      examples: ['I visited Paris in 2019. (Simple Past — specific time)', 'I have visited Paris. (Present Perfect — unspecified time)', 'She has lost her keys. (relevant to now — she still doesn\'t have them)', 'He finished the report yesterday. (Simple Past — yesterday is specific)'],
      commonMistake: 'Do not use the Present Perfect with specific past time expressions. Say "I went there last year" — not "I have gone there last year."',
    ),
    GrammarGuide(
      id: 'g3',
      title: 'Countable and Uncountable Nouns',
      explanation: 'Countable nouns can be counted and have a plural form. Uncountable nouns cannot be counted individually and have no plural form.',
      examples: ['Countable: one apple, two apples, a chair, three chairs', 'Uncountable: water, information, advice, furniture, money', 'Correct: "Can I have some water?" / "I need some advice."', 'Incorrect: "Can I have some waters?" / "I need some advices."'],
      commonMistake: 'Words like "information", "advice", "furniture", and "luggage" are uncountable in English. Never add -s to these words.',
    ),
    GrammarGuide(
      id: 'g4',
      title: 'First and Second Conditional',
      explanation: 'The First Conditional describes real, possible situations in the future. The Second Conditional describes unreal or unlikely situations in the present or future.',
      examples: ['First: If it rains tomorrow, I will stay home.', 'First: If you study hard, you will pass the exam.', 'Second: If I had a million dollars, I would travel the world.', 'Second: If she were taller, she would be a model.'],
      commonMistake: 'In Second Conditional, use "were" for all subjects — not "was". Say "If I were you..." not "If I was you..."',
    ),
    GrammarGuide(
      id: 'g5',
      title: 'Prepositions of Time: In, On, At',
      explanation: 'Use "at" for precise times. Use "on" for days and dates. Use "in" for months, years, seasons, and longer periods.',
      examples: ['At: at 3 o\'clock, at midnight, at noon, at the weekend', 'On: on Monday, on 25 July, on my birthday, on Christmas Day', 'In: in January, in 2020, in the summer, in the morning', 'She was born at 6am on a Tuesday in March.'],
      commonMistake: 'Many learners confuse "in the morning" with "on the morning". Use "in the morning" generally, but "on the morning of the event" for a specific morning.',
    ),
    GrammarGuide(
      id: 'g6',
      title: 'Modal Verbs: Can, Could, May, Might',
      explanation: 'Modal verbs express ability, possibility, or permission. "Can" and "could" express ability or possibility (could is more polite or uncertain). "May" and "might" express possibility (might is less certain).',
      examples: ['Can: I can speak three languages. Can I open the window?', 'Could: Could you help me, please? (polite request)', 'May: It may rain later. May I come in?', 'Might: I might go to the party — I\'m not sure yet.'],
      commonMistake: 'Never add "to" after a modal verb. Say "I can swim" — not "I can to swim."',
    ),
    GrammarGuide(
      id: 'g7',
      title: 'Active and Passive Voice',
      explanation: 'In the active voice, the subject performs the action. In the passive voice, the subject receives the action. The passive is formed with the verb "to be" + past participle.',
      examples: ['Active: The chef cooked the meal.', 'Passive: The meal was cooked by the chef.', 'Active: Someone stole my bag.', 'Passive: My bag was stolen.', 'Passive without agent: The bridge was built in 1890.'],
      commonMistake: 'Do not confuse passive voice with past tense. "Was cooked" is passive; "cooked" alone is active past tense.',
    ),
    GrammarGuide(
      id: 'g8',
      title: 'Reported Speech',
      explanation: 'When reporting what someone said, verb tenses usually shift back one step. Pronouns and time expressions also change.',
      examples: ['"I am tired," she said. → She said that she was tired.', '"I will call you," he said. → He said he would call me.', '"We have finished," they said. → They said they had finished.', '"I went yesterday," she said. → She said she had gone the day before.'],
      commonMistake: 'Do not keep the original tense when using reported speech. "She said she is tired" is incorrect — it should be "she said she was tired."',
    ),
  ];
}