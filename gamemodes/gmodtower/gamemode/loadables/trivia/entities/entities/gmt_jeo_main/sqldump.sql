-- phpMyAdmin SQL Dump
-- version 2.11.7.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 24, 2008 at 09:09 PM
-- Server version: 5.0.51
-- PHP Version: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `nican`
--

-- --------------------------------------------------------

--
-- Table structure for table `gm_jeopardy`
--

CREATE TABLE IF NOT EXISTS `gm_jeopardy` (
  `id` int(11) NOT NULL auto_increment,
  `question` text NOT NULL,
  `level` smallint(5) unsigned NOT NULL,
  `cat` varchar(32) NOT NULL,
  `ans1` varchar(25) NOT NULL,
  `ans2` varchar(25) NOT NULL,
  `ans3` varchar(25) NOT NULL,
  `ans4` varchar(25) NOT NULL,
  `count1` smallint(5) unsigned NOT NULL default '0',
  `count2` smallint(5) unsigned NOT NULL default '0',
  `count3` smallint(5) unsigned NOT NULL default '0',
  `count4` smallint(5) unsigned NOT NULL default '0',
  `LastUse` int(11) unsigned NOT NULL default '0',
  `AddedBy` int(11) NOT NULL,
  `EditedBy` int(11) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `categoryindex` (`cat`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=111 ;

--
-- Dumping data for table `gm_jeopardy`
--

INSERT INTO `gm_jeopardy` (`id`, `question`, `level`, `cat`, `ans1`, `ans2`, `ans3`, `ans4`, `count1`, `count2`, `count3`, `count4`, `LastUse`, `AddedBy`, `EditedBy`, `enabled`) VALUES
(1, 'How many wives did Henry VIII have?', 1, 'History', '6', '9', '7', '3', 1, 0, 0, 0, 1229826279, 0, 0, 0),
(2, 'Who was the villain of The Lion King?', 1, 'Films', 'Scar', 'Fred', 'Jafar', 'Vada', 1, 0, 1, 1, 1229827330, 0, 949104, 0),
(3, 'Which bird is the odd one out:', 1, 'Odd One Out', 'Crow', 'Eagle', 'Vulture', 'Falcon', 2, 1, 0, 0, 1229827167, 0, 0, 0),
(4, 'Which language is the odd one out:', 1, 'Odd One Out', 'Chinese', 'English', 'French', 'Spanish', 1, 0, 0, 0, 1229481292, 0, 0, 0),
(5, 'The invasion of which country led to the outbreak of World War II', 1, 'History', 'Poland', 'Austria', 'France', 'England', 3, 1, 0, 0, 1229827651, 0, 0, 0),
(6, 'Cleopatra ruled which country?', 1, 'History', 'Egypt', 'Italy', 'Turkey', 'Sudan', 1, 0, 0, 0, 1229827618, 0, 0, 0),
(9, 'Who was American president at the start of World War II:', 1, 'History', 'Roosevelt', 'Truman', 'Jefferson', 'John Kennedy', 0, 0, 0, 0, 0, 0, 0, 0),
(10, 'Where did the Incas originate', 1, 'History', 'Peru', 'China', 'Brazil', 'Chile', 0, 0, 1, 0, 1229827564, 0, 0, 0),
(11, 'When was the American Declaration of Independence', 1, 'History', '1776', '1800', '1865', '1732', 0, 0, 1, 0, 0, 0, 0, 0),
(12, 'In which country did the Industrial Revolution start?', 1, 'History', 'England', 'France', 'Spain', 'Germany', 1, 0, 0, 2, 1229828439, 0, 0, 0),
(13, 'During which war was the tank first used?', 1, 'History', 'World War I', 'World War II', 'Vietnam War', 'The Cold War', 1, 1, 0, 0, 1229827082, 0, 0, 0),
(14, 'Who owned a sword called Excalibur?', 1, 'Literature', 'King Arthur', 'King Ethelbald', 'King Harold', 'King William', 2, 0, 0, 0, 1229828207, 0, 0, 0),
(15, 'How many grams are there in a kilogram?', 1, 'Pot Luck', '1000', '1024', '720', '100', 1, 1, 0, 0, 1229482086, 0, 0, 0),
(16, 'What is titanium?', 1, 'Pot Luck', 'Mineral', 'Vegetable', 'Animal', 'Plant', 3, 0, 1, 0, 1229826772, 0, 0, 0),
(17, 'Which planet is so large it could contain all the others.', 1, 'Astronomy', 'Jupiter', 'Saturn', 'Uranus', 'Mercury', 2, 0, 1, 0, 1229826805, 0, 0, 0),
(18, 'Which country did Ivan the Terrible rule?', 1, 'History', 'Russia', 'England', 'France', 'Poland', 2, 0, 1, 0, 1229828220, 0, 0, 0),
(19, 'To which domestic animal is the tiger related?', 1, 'Pot Luck', 'Cat', 'Dog', 'Panthera', 'Lion', 3, 1, 1, 0, 1229828419, 0, 0, 0),
(20, 'From what is paper traditionally made?', 1, 'Pot Luck', 'Wood', 'Sand', 'Nitrocellulose', 'Lithium', 1, 0, 0, 2, 1229827906, 0, 0, 0),
(21, 'What is Big Ben?', 1, 'The World', 'A clock', 'An explosion', 'A character', 'A book', 0, 1, 0, 0, 1229824935, 0, 0, 0),
(22, 'What is a wat?', 1, 'Pot Luck', 'A Temple', 'Energy', 'Wide Angle Trail', 'A gas', 1, 1, 1, 0, 1229481240, 0, 0, 0),
(23, 'Who used the code name 007?', 1, 'Pot Luck', 'James Bond', 'Andrew Bond', 'Julia Bound', 'James Bound', 1, 0, 0, 0, 1229482134, 0, 0, 0),
(24, 'Which fruit is the odd one out?', 1, 'Odd One Out', 'Fig', 'Currant', 'Raisin', 'Sultana', 0, 0, 0, 0, 0, 0, 0, 0),
(25, 'Which animal is the one one out?', 1, 'Odd One Out', 'Salamander', 'Crab', 'Lobster', 'Shrimp', 0, 0, 0, 0, 0, 0, 0, 0),
(26, 'George H. Bush is of what political party?', 1, 'Politics', 'Republican', 'Democrat', 'Green', 'Other', 1, 1, 0, 0, 1229481624, 0, 0, 0),
(27, 'Which musical instrument is the odd one out', 1, 'Odd One Out', 'Trumpet', 'Oboe', 'Clarinet', 'Flute', 0, 0, 0, 0, 0, 0, 0, 0),
(28, 'Which is the odd number out?', 1, 'Odd One Out', '8', '11', '9', '15', 1, 1, 1, 1, 1229827105, 0, 0, 0),
(7, 'Which drink is the odd one out?', 1, 'Odd One Out', 'Milk', 'Tea', 'Coffe', 'Cocoa', 2, 1, 1, 0, 1229826316, 0, 0, 0),
(8, 'What is coal?', 1, 'Pot Luck', 'Fossil fuel', 'Element', 'Paper', 'A Star', 2, 0, 0, 1, 1229482166, 0, 0, 0),
(29, 'What is the highest number that has a name?', 1, 'Pot Luck', 'Googelplex', 'Googel', 'Trillion', 'Yotta', 1, 0, 0, 0, 1229828191, 0, 0, 0),
(30, 'Where did the Norse warriors hope to go when they died?', 1, 'Pot Luck', 'Valhalla', 'Heaven', 'Ragnarok', 'Mount Olympus', 0, 0, 0, 0, 0, 0, 0, 0),
(31, 'How many are there in a score?', 1, 'Pot Luck', '20', '50', '100', '15', 0, 0, 0, 0, 0, 0, 0, 0),
(32, 'Which of these snakes is not venomous?', 1, 'Pot Luck', 'boa constrictor', 'rattlesnake', 'viper', 'copperhead', 0, 0, 0, 0, 0, 0, 0, 0),
(33, 'Brittany is part of which country?', 1, 'Pot Luck', 'France', 'Canada', 'Italy', 'Germany', 3, 1, 3, 0, 1229828467, 0, 0, 0),
(34, 'What is the name given to the Earth''s hard outer shell?', 1, 'The Earth', 'Crust', 'Core', 'Mantle', 'Lithosphere', 2, 0, 0, 0, 1229828480, 0, 0, 0),
(35, 'Is the Earth a perfect sphere?', 1, 'The Earth', 'False', 'True', '', '', 1, 1, 0, 0, 1229828409, 0, 0, 0),
(36, 'What is the name of the continent which contains the South Pole? ', 1, 'The Earth', 'Antarctica', 'Australia', 'Africa', 'Meridian', 1, 0, 0, 0, 1229828131, 0, 0, 0),
(37, 'In which way does a stalagmite grow?', 1, 'The Earth', 'Up', 'Down', 'Right', 'Left', 0, 0, 0, 0, 0, 0, 0, 0),
(38, 'What is the commonest gas in the atmosphere?', 1, 'The Earth', 'Nitogren', 'Oxygen', 'Hydrogen', 'Neon', 3, 0, 2, 0, 1229827886, 0, 0, 0),
(39, 'What is `natural gas` mainly made of?', 1, 'The Earth', 'Methane', 'Hydrocarbon', 'Nitrogen', 'Florine', 1, 0, 1, 0, 1229827276, 0, 0, 0),
(40, 'What color are emeralds?', 1, 'The Earth', 'Green', 'Yellow', 'Red', 'Blue', 0, 0, 0, 0, 0, 0, 0, 0),
(41, 'Which of the following is not a gambling game?', 1, 'Pot Luck', 'Patience', 'Dice', 'Poker', 'Roulette', 1, 1, 0, 0, 1229482003, 0, 0, 0),
(42, 'John Constable was:', 1, 'Pot Luck', 'A painter', 'A doctor', 'An explorer', 'A President', 1, 0, 0, 1, 1229482054, 0, 0, 0),
(43, 'Carmen is:', 1, 'Pot Luck', 'An Opera', 'A Car', 'A game', 'A President', 0, 0, 0, 0, 0, 0, 0, 0),
(44, 'In which country would you not drive on the left:', 1, 'Pot Luck', 'Sweden', 'UK', 'Thailand', 'Japan', 0, 0, 0, 0, 0, 0, 0, 0),
(45, 'What game do the Chicago Bulls play?', 1, 'Pot Luck', 'Basketball', 'Football', 'Soccer', 'Baseball', 1, 1, 0, 0, 1229481372, 0, 0, 0),
(46, 'Which of the following is not a citrus fruit?', 1, 'Pot Luck', 'Rhubarb', 'Lemon', 'Orange', 'Grapefruit', 0, 0, 0, 0, 0, 0, 0, 0),
(47, 'In a Portuguese Man o'' War:', 1, 'Pot Luck', 'A jellyfish', 'A ship', 'A warrior', 'A car', 2, 1, 0, 0, 1229827851, 0, 0, 0),
(48, 'In which country was golf invented:', 1, 'Pot Luck', 'Scotland', 'USA', 'Zaire', 'Denmark', 1, 0, 0, 0, 1229734741, 0, 0, 0),
(49, 'How many years is three score and ten?', 1, 'Pot Luck', '70', '30', '60', '55', 1, 0, 0, 0, 1229827394, 0, 0, 0),
(50, 'Alive is the same as:', 1, 'Synonyms', 'Animated', 'Busy', 'Exciting', '', 0, 0, 0, 0, 0, 0, 0, 0),
(51, 'Of which country is Warsaw the capital city?', 1, 'Pot Luck', 'Poland', 'Germany', 'Lithuania', 'Ukraine', 1, 1, 1, 0, 1229481340, 0, 0, 0),
(52, 'What is the first letter of the Greek alphabet?', 1, 'Pot Luck', 'Alpha', 'Beta', 'Gamma', 'Delta', 1, 0, 0, 0, 1229481409, 0, 0, 0),
(53, 'To which country does the island of Crete belong?', 1, 'Pot Luck', 'Greece', 'Italy', 'Frace', 'Turkey', 0, 0, 0, 0, 0, 0, 0, 0),
(54, 'Which is the first book of the Bible?', 1, 'Pot Luck', 'Genesis', 'Exodus', 'Leviticus', 'Numbers', 1, 0, 0, 0, 1229481310, 0, 0, 0),
(55, 'On which coast would you find Oregon?', 1, 'Pot Luck', 'West', 'East', 'South', 'North', 3, 2, 1, 0, 1229828146, 0, 0, 0),
(56, 'How many strings does a guitar usually have?', 1, 'Classical Music', 'Six', 'Seven', 'Nine', 'Three', 4, 1, 0, 0, 1229828454, 0, 0, 0),
(57, 'What is a chihuahua?', 1, 'Pot Luck', 'Small Dog', 'Cat', 'Long Horse', 'Hamster', 0, 0, 0, 0, 0, 0, 0, 0),
(58, 'Which country uses roubles as currency?', 1, 'Pot Luck', 'Russia', 'England', 'Poland', 'Hungary', 4, 0, 1, 1, 1229828168, 0, 0, 0),
(59, 'Shinto is the religion of which country?', 1, 'Religion', 'Japan', 'China', 'Korea', 'Mongolia', 1, 0, 0, 0, 1229827950, 0, 0, 0),
(60, 'Which is the hottest planet?', 1, 'Astronomy', 'Venus', 'Mercury', 'Earth', 'Jupiter', 0, 1, 0, 0, 1229481582, 0, 0, 0),
(61, 'What is the largest city of the United States?', 1, 'Geography', 'New York', 'Chicago', 'Washington D.C.', 'Los Angeles', 1, 0, 0, 0, 1229481441, 0, 0, 0),
(62, 'What sort of animals are dolphins?', 1, 'Pot Luck', 'Mammals', 'Reptiles', 'Amphibians', '', 0, 0, 0, 0, 0, 0, 0, 0),
(63, 'What do you call the control panel of the car?', 1, 'Pot Luck', 'Dashboard', 'Applet', 'Visor', 'Window', 2, 0, 2, 1, 1229827447, 0, 0, 0),
(64, 'Who did Paris, the ruler of Troy, select as the most beautiful goddess?', 1, 'Greeks', 'Aphrodite', 'Athena', 'Apollo', 'Hemera', 1, 1, 0, 0, 1229826708, 0, 0, 0),
(65, 'World War 2 ended in:', 1, 'History', '1945', '1939', '1955', '1931', 2, 0, 2, 0, 1229828234, 0, 0, 0),
(66, 'How many planets are between Earth and the sun?', 1, 'Astronomy', '2', '1', '4', '3', 1, 0, 0, 0, 1229825906, 0, 0, 0),
(67, 'What country covers an entire continent?', 1, 'Geography', 'Australia', 'Antarctica', 'Africa', 'Europe', 1, 0, 1, 0, 1229827937, 0, 0, 0),
(68, 'What finally destroyed the aliens in War of the Worlds?', 1, 'Movies', 'Bacterias', 'Humans', 'Solar flare', 'Time', 1, 0, 0, 0, 1229827132, 0, 0, 0),
(69, 'Who was the first woman to win a Nobel Prize?', 1, 'Science', 'Marie Curie', 'Clara Barton', 'Alice Hamilton', 'Mary Leakey', 0, 0, 0, 0, 0, 0, 0, 0),
(70, 'Who wrote Peter Pan?', 1, 'Literature', 'J. M. Barrie', 'F. D. Bedford', 'P. J. Hogan', 'James Callaghan', 0, 0, 1, 1, 1229826760, 0, 0, 0),
(71, 'Who is the current leader of Cuba?', 1, 'The World', 'Fidel Castro', 'Kim Jong', 'Adolf Hitler', 'Hamid Karzai', 1, 0, 0, 0, 1229827963, 0, 0, 0),
(72, 'What is the capital of Brazil?', 1, 'The World', 'Brasilia', 'Buenos Aires', 'Santiago', 'Madrid', 2, 0, 0, 1, 1229828311, 0, 0, 0),
(73, 'In what year did East and West Germany re-unite?', 1, 'History', '1990', '1945', '1960', '1975', 1, 0, 1, 0, 1229827605, 0, 0, 0),
(74, 'Which family ruled Russia from 1613 to 1917?', 1, 'History', 'Romanov', 'Mironov', 'Medvedev', 'Putin', 1, 1, 0, 0, 1229828279, 0, 0, 0),
(75, 'Which country uses a Yen for money?', 1, 'The World', 'Japan', 'China', 'Korea', 'India', 1, 1, 0, 0, 1229827671, 0, 0, 0),
(76, 'Which country is also a continent?', 1, 'The World', 'Australia', 'Brazil', 'China', 'Africa', 1, 0, 0, 0, 1229736074, 0, 0, 0),
(77, 'Who was the Greek goddess of victory?', 1, 'Greeks', 'Nike', 'Athena', 'Hera', 'Aether', 0, 0, 0, 0, 0, 0, 0, 0),
(78, 'The blood of mammals is red.  What color is insect''s blood?', 1, 'Science', 'Yellow', 'Green', 'Red', 'Blue', 1, 0, 1, 0, 1229826831, 0, 0, 0),
(79, 'What does a speleologist study?', 1, 'Science', 'Caves', 'Montains', 'Mirrors', 'Deep oceans', 0, 0, 0, 0, 0, 0, 0, 0),
(80, 'What is the largest island in the world?', 1, 'Geography', 'Greenland', 'Hawaii', 'Australia', 'Kauai', 2, 0, 1, 0, 1229827548, 0, 0, 0),
(81, 'Rome was originally built on how many hills?', 1, 'History', '7', '2', '5', '15', 0, 0, 0, 0, 0, 0, 0, 0),
(82, 'What is the body''s largest internal organ?', 1, 'Anatomy', 'Small intestine', 'Big intestine', 'Liver', 'Heart', 0, 0, 0, 0, 0, 0, 0, 0),
(83, 'What country lies along the western side of Spain?', 1, 'Geography', 'Portugal', 'France', 'England', 'Poland', 0, 0, 0, 0, 0, 0, 0, 0),
(84, 'How many bones does a shark have?', 1, 'Pot Luck', '0', '23', '102', '55', 1, 1, 0, 0, 1229828262, 0, 0, 0),
(85, 'How many eyelids does a camel''s eye have?', 1, 'Pot Luck', '3', '9', '6', '4', 0, 0, 0, 0, 0, 0, 0, 0),
(86, 'What is the largest Portuguese speaking country in the world?', 1, 'The World', 'Brazil', 'Portugal', 'Argentina', 'Mongolia', 1, 1, 0, 0, 1229828249, 0, 0, 0),
(87, 'What do we now call the country that was once known as Siam?', 1, 'History', 'Thailand', 'Chile', 'Turkey', 'Hungary', 0, 0, 0, 0, 0, 0, 0, 0),
(88, 'What is the largest Japanese speaking country?', 1, 'The World', 'Japan', 'India', 'Korea', 'Mongolia', 0, 0, 0, 0, 0, 0, 0, 0),
(89, 'What city would you go to see a tower that leans?', 1, 'The World', 'Pisa', 'Italy', 'Paris', 'Madrid', 0, 0, 0, 0, 0, 0, 0, 0),
(90, 'The most populated country in western Europe is?', 1, 'The World', 'Germany', 'Poland', 'Greece', 'Finland', 1, 0, 1, 0, 1229827064, 0, 0, 0),
(91, 'Homeowners buy surge protectors to protect their homes from what?', 1, 'Pot Luck', 'Electric Current', 'Air Pressure', 'Water Flow', 'Buyer''s remorse', 1, 0, 0, 0, 1229807496, 0, 0, 0),
(92, 'A white dove, also a symbol of Valentine''s Day, symbolizes what', 1, 'Pot Luck', 'Good Luck', 'Love', 'Peace', 'Relationship', 2, 0, 1, 1, 1229828110, 0, 0, 0),
(93, 'What was Buddha''s name before his enlightenment?', 1, 'Religion', 'Sidhartha', 'Suddhodana', 'Saraha', 'Shantideva', 2, 1, 1, 0, 1229827918, 0, 0, 0),
(94, 'What was Sherlock Holmes'' brother''s name?', 1, 'Literature', 'Mycroft', 'Homer', 'Vernet', 'Watson', 0, 0, 0, 0, 0, 0, 0, 0),
(95, 'What type of rocks floats in water?', 1, 'Pot Luck', 'Pumice', 'Gabbro', 'Granite', 'Peridotite', 1, 0, 2, 0, 1229827688, 0, 0, 0),
(96, 'What is the most abundant metal in the Earth''s crust?', 1, 'The World', 'Aluminum', 'Iron', 'Copper', 'Cobalt', 0, 0, 0, 0, 0, 0, 0, 0),
(97, 'In which part of the Americas did the Aztecs live?', 1, 'History', 'Mexico', 'Chile', 'Brazil', 'Bolivia', 0, 0, 0, 0, 0, 0, 0, 0),
(98, 'What do you call a young lion?', 1, 'Animals', 'A Cub', 'A Trainee', 'A Filhote', 'An Alias', 0, 0, 0, 0, 0, 0, 0, 0),
(99, 'Who uses Braille?', 1, 'Pot Luck', 'Blind people', 'Deaf people', 'Monks', 'Computers', 1, 0, 0, 0, 1229819325, 0, 0, 0),
(100, 'A horn belongs to which class of musical instruments?', 1, 'Pot Luck', 'Brass', 'String', 'Wind', 'Percussion', 0, 0, 1, 0, 1229827590, 0, 0, 0),
(101, 'What do you call a five-sided figure?', 1, 'Geometry', 'Pentagon', 'Fivagon', 'Hexagon', 'Pentadecagon', 2, 1, 0, 0, 1229827635, 0, 0, 0),
(102, 'The weight of which precious metal is measured in carats?', 1, 'Pot Luck', 'Gold', 'Silver', 'Platinum', 'Mercury', 0, 0, 0, 0, 0, 0, 0, 0),
(103, 'What people used a tepee as a dwelling?', 1, 'History', 'Native Americans', 'Egyptians', 'Chinese', 'Aztecs', 1, 0, 0, 0, 1229811195, 0, 0, 0),
(104, 'Which waterway separates Africa from Asia?', 1, 'Places', 'Suez Canal', 'Black Sea', 'Mediterranean Sea', 'Red Sea', 0, 0, 0, 0, 0, 0, 0, 0),
(105, 'Which is the largest of the Greek islands?', 1, 'Places', 'Crete', 'Dokos', 'Lesbos', 'Rhodes', 0, 0, 0, 0, 0, 0, 0, 0),
(106, 'How many minutes does a soccer match last?', 1, 'Pot Luck', '90', '120', '60', '150', 1, 1, 1, 0, 1229827006, 0, 0, 0);
