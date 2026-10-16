import 'models.dart';

const exams = <Exam>[
  Exam(
    id: 'maths',
    subject: 'Mathematics',
    description: 'Algebra, number bases, geometry, statistics and logarithms.',
    duration: Duration(minutes: 15),
    questions: [
      Question(
        prompt: 'Solve for x: 3x + 5 = 20',
        options: ['3', '5', '6', '15'],
        answer: 1,
        explanation: '3x = 15, so x = 5.',
      ),
      Question(
        prompt: 'Evaluate 2³ × 2⁴',
        options: ['64', '128', '256', '4096'],
        answer: 1,
        explanation: '2³ × 2⁴ = 2⁷ = 128.',
      ),
      Question(
        prompt: 'Find the area of a circle of radius 7 cm. (Take π = 22/7)',
        options: ['44 cm²', '88 cm²', '154 cm²', '308 cm²'],
        answer: 2,
        explanation: 'πr² = 22/7 × 49 = 154 cm².',
      ),
      Question(
        prompt: 'Find the mean of 4, 8, 6, 10 and 12.',
        options: ['6', '7', '8', '10'],
        answer: 2,
        explanation: '(4 + 8 + 6 + 10 + 12) ÷ 5 = 40 ÷ 5 = 8.',
      ),
      Question(
        prompt: 'What is 15% of 240?',
        options: ['24', '30', '36', '48'],
        answer: 2,
        explanation: '0.15 × 240 = 36.',
      ),
      Question(
        prompt: 'Convert 1011₂ to base ten.',
        options: ['9', '11', '13', '101'],
        answer: 1,
        explanation: '8 + 0 + 2 + 1 = 11.',
      ),
      Question(
        prompt: 'Find the gradient of the line through (1, 2) and (3, 8).',
        options: ['2', '3', '4', '6'],
        answer: 1,
        explanation: '(8 − 2) ÷ (3 − 1) = 6 ÷ 2 = 3.',
      ),
      Question(
        prompt: 'Factorise x² − 9.',
        options: ['(x − 9)(x + 1)', '(x − 3)²', '(x − 3)(x + 3)', 'x(x − 9)'],
        answer: 2,
        explanation: 'Difference of two squares: x² − 3² = (x − 3)(x + 3).',
      ),
      Question(
        prompt: 'What is the sum of the interior angles of a hexagon?',
        options: ['360°', '540°', '720°', '1080°'],
        answer: 2,
        explanation: '(n − 2) × 180° = 4 × 180° = 720°.',
      ),
      Question(
        prompt: 'Given log₁₀2 = 0.3010, find log₁₀8.',
        options: ['0.6020', '0.9030', '1.2040', '2.4080'],
        answer: 1,
        explanation: 'log 8 = log 2³ = 3 × 0.3010 = 0.9030.',
      ),
    ],
  ),
  Exam(
    id: 'english',
    subject: 'English Language',
    description: 'Vocabulary, grammar, concord, spelling and idioms.',
    duration: Duration(minutes: 15),
    questions: [
      Question(
        prompt: 'Choose the word nearest in meaning to "candid".',
        options: ['Frank', 'Careful', 'Shy', 'Clever'],
        answer: 0,
      ),
      Question(
        prompt: 'Choose the word opposite in meaning to "scarce".',
        options: ['Rare', 'Abundant', 'Expensive', 'Hidden'],
        answer: 1,
      ),
      Question(
        prompt: 'Neither the teacher nor the students ___ present.',
        options: ['was', 'were', 'is', 'has been'],
        answer: 1,
        explanation: 'With "neither … nor", the verb agrees with the nearer subject, "students".',
      ),
      Question(
        prompt: 'Which word is correctly spelt?',
        options: ['Accomodation', 'Acommodation', 'Accommodation', 'Acomodation'],
        answer: 2,
      ),
      Question(
        prompt: 'She has been living in Lagos ___ 2019.',
        options: ['for', 'since', 'from', 'by'],
        answer: 1,
        explanation: '"Since" introduces a point in time; "for" introduces a period.',
      ),
      Question(
        prompt: 'What is the plural of "criterion"?',
        options: ['Criterions', 'Criterias', 'Criteria', 'Criterion'],
        answer: 2,
      ),
      Question(
        prompt: 'To "let the cat out of the bag" means to ___.',
        options: ['set something free', 'reveal a secret', 'cause trouble', 'run away'],
        answer: 1,
      ),
      Question(
        prompt: 'The boy ___ bag was stolen is crying.',
        options: ['who', 'whom', 'whose', 'which'],
        answer: 2,
      ),
      Question(
        prompt: 'He is very good ___ Mathematics.',
        options: ['in', 'at', 'on', 'with'],
        answer: 1,
      ),
      Question(
        prompt: 'In "She ran quickly", the word "quickly" is ___.',
        options: ['a noun', 'an adjective', 'a verb', 'an adverb'],
        answer: 3,
      ),
    ],
  ),
  Exam(
    id: 'physics',
    subject: 'Physics',
    description: 'Units, motion, energy, electricity, light and sound.',
    duration: Duration(minutes: 15),
    questions: [
      Question(
        prompt: 'What is the SI unit of force?',
        options: ['Joule', 'Newton', 'Watt', 'Pascal'],
        answer: 1,
      ),
      Question(
        prompt: 'A car travels 120 km in 2 hours. What is its average speed?',
        options: ['30 km/h', '60 km/h', '120 km/h', '240 km/h'],
        answer: 1,
        explanation: 'Speed = distance ÷ time = 120 ÷ 2 = 60 km/h.',
      ),
      Question(
        prompt: 'Which of these is a vector quantity?',
        options: ['Mass', 'Speed', 'Velocity', 'Temperature'],
        answer: 2,
        explanation: 'Velocity has both magnitude and direction.',
      ),
      Question(
        prompt: 'The acceleration due to gravity on Earth is approximately ___.',
        options: ['1.6 m/s²', '9.8 m/s²', '98 m/s²', '3.0 × 10⁸ m/s²'],
        answer: 1,
      ),
      Question(
        prompt: 'A current of 2 A flows through a 5 Ω resistor. Find the voltage across it.',
        options: ['2.5 V', '7 V', '10 V', '25 V'],
        answer: 2,
        explanation: 'V = IR = 2 × 5 = 10 V.',
      ),
      Question(
        prompt: 'The energy a body has because of its motion is called ___.',
        options: ['potential energy', 'kinetic energy', 'heat energy', 'chemical energy'],
        answer: 1,
      ),
      Question(
        prompt: 'The image formed by a plane mirror is ___.',
        options: ['real and inverted', 'real and upright', 'virtual and upright', 'virtual and inverted'],
        answer: 2,
      ),
      Question(
        prompt: 'What is the SI unit of power?',
        options: ['Watt', 'Joule', 'Volt', 'Ampere'],
        answer: 0,
      ),
      Question(
        prompt: 'Sound cannot travel through ___.',
        options: ['water', 'steel', 'air', 'a vacuum'],
        answer: 3,
        explanation: 'Sound needs a material medium to travel.',
      ),
      Question(
        prompt: 'A 2 kg mass moves at 3 m/s. What is its kinetic energy?',
        options: ['3 J', '6 J', '9 J', '18 J'],
        answer: 2,
        explanation: 'KE = ½mv² = ½ × 2 × 3² = 9 J.',
      ),
    ],
  ),
];
