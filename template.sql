SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gmtower`
--

-- --------------------------------------------------------

--
-- Table structure for table `gm_ballrace`
--

CREATE TABLE `gm_ballrace` (
  `ply` tinytext DEFAULT NULL,
  `name` tinytext DEFAULT NULL,
  `map` tinytext DEFAULT NULL,
  `lvl` tinytext DEFAULT NULL,
  `time` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gm_bans`
--

CREATE TABLE `gm_bans` (
  `steamid` tinytext DEFAULT NULL,
  `name` tinytext NOT NULL,
  `ip` tinytext DEFAULT NULL,
  `reason` tinytext NOT NULL,
  `bannedOn` bigint(20) NOT NULL,
  `time` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `gm_bans`
--

INSERT INTO `gm_bans` (`steamid`, `name`, `ip`, `reason`, `bannedOn`, `time`) VALUES
('STEAM_0:1:22125535', 'Tootage', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:1:10161682', '[YaS] BlackhawkGT', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:1:17162420', '[D3]LuminousSilver', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:0:13388289', 'stgn', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:0:6847392', '||BoB||Squallboogie', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:0:18607667', 'Slash', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:0:9036955', 'PWD]Xeldof', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:0:20550704', 'nitro-n20', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:1:17399955', '.:[MDFB]:. .:GGC:. XMX Fabian', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:0:8563984', 'Killer2', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:0:8268433', 'Tommy the Commy', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:1:14884446', 'Llamalords', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:0:14282678', 'Whitefang', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:1:10742997', 'Teddi', 'unknown', 'Hard coded perma-banned', 1296673476, 0),
('STEAM_0:0:42526218', 'Coffee', 'clean', 'clean', 1494061708, 0),
('STEAM_0:1:44393176', 'Raphy', 'clean', 'clean', 1502833784, 0),
('STEAM_0:1:21016813', '0x0539', 'clean', 'clean', 1494061708, 0),
('STEAM_0:0:5142513', 'Groove [FranceRp]', 'clean', 'clean', 1494061708, 0),
('STEAM_0:0:121531418', 'ARKANIUM ~ ???', NULL, '', 0, 0),
('STEAM_0:0:44240558', 'basedexe', 'clean', 'clean', 1500268937, 0);

-- --------------------------------------------------------

--
-- Table structure for table `gm_casino`
--

CREATE TABLE `gm_casino` (
  `type` tinytext NOT NULL,
  `jackpot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gm_chat`
--

CREATE TABLE `gm_chat` (
  `ply` int(10) NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `srvid` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gm_gomap`
--

CREATE TABLE `gm_gomap` (
  `serverid` int(10) UNSIGNED NOT NULL,
  `authplayers` varchar(45) NOT NULL,
  `gomap` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gm_hats`
--

CREATE TABLE `gm_hats` (
  `id` smallint(6) NOT NULL,
  `hat` text NOT NULL,
  `plymodel` text NOT NULL,
  `vx` varchar(45) NOT NULL,
  `vy` varchar(45) NOT NULL,
  `vz` varchar(45) NOT NULL,
  `ap` varchar(45) NOT NULL,
  `ay` varchar(45) NOT NULL,
  `ar` varchar(45) NOT NULL,
  `scale` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gm_items`
--

CREATE TABLE `gm_items` (
  `unique` varchar(255) DEFAULT NULL,
  `id` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `desc` varchar(255) DEFAULT NULL,
  `storeid` varchar(255) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `weapon` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `gm_items`
--

INSERT INTO `gm_items` (`unique`, `id`, `name`, `desc`, `storeid`, `price`, `model`, `weapon`) VALUES
('Con10x10x10_block_large', '3022', '10x10x10_block_large', 'Concrete', '11', '60', 'models/NightReaper/Concrete/10x10x10_block_large.mdl', '0'),
('conffetigun2', '40463', 'Confetti! (6)', '', '22', '120', 'models/weapons/w_bugbait.mdl', '1'),
('gmtdesk', '13605', 'Computer Desk', 'Place your computer and other things on this desk.', '1', '450', 'models/gmod_tower/gmtdesk.mdl', '0'),
('trophy_bringsomepopcorn', '19034', 'Trophy: Bring Some Popcorn', '', '0', '0', 'models/gmod_tower/trophy_bringsomepopcorn.mdl', '0'),
('potted_plant2', '34954', 'Potted Plant Small', 'A small nice plant.', '6', '10', 'models/props/de_inferno/potted_plant1.mdl', '0'),
('suitecouch', '6064', 'Suite Sofa', 'Sit down on a comfy couch.', '1', '300', 'models/gmod_tower/suitecouch.mdl', '0'),
('weapon_bouncynade', '17078', 'Rubber Grenade', 'Rubber Grenade', '0', '0', 'models/weapons/w_eq_fraggrenade.mdl', '1'),
('poster11_hl2', '15210', 'Half-Life 2', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('furniture_shelf01a', '16236', 'Shelf', 'Place trophies or other items in this nice shelf.', '1', '115', 'models/props/cs_militia/furniture_shelf01a.mdl', '0'),
('mikuclock', '80', 'Miku Clock', 'Collectable Hatsune Miku working clock.', '0', '0', 'models/gmod_tower/mikuclock.mdl', '0'),
('poster49_psychonauts', '6607', 'Psychonauts', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('coffee_mug3', '45542', 'Coffee Mug', 'A coffee mug that\'s just for looks.', '6', '10', 'models/props/cs_office/coffee_mug3.mdl', '0'),
('weapon_stunstick', '41470', 'Stunstick', '', '0', '0', 'models/weapons/w_stunbaton.mdl', '1'),
('conffetigun3', '40464', 'Confetti! (10)', '', '22', '180', 'models/weapons/w_bugbait.mdl', '1'),
('Har10x10x100_beam_long', '45606', '10x10x100_beam_long', 'HardWood', '11', '240', 'models/NightReaper/HardWood/10x10x100_beam_long.mdl', '0'),
('poster60_alienswarm', '37494', 'Alien Swarm', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('Sof5x50x100_window', '44680', '5x50x100_window', 'SoftWood', '11', '310', 'models/NightReaper/SoftWood/5x50x100_window.mdl', '0'),
('weapon_rabbitgod', '37031', 'Rabbit GOD!', '', '0', '0', 'models/weapons/w_rocket_launcher.mdl', '1'),
('Sof5x5x5_block_small', '5104', '5x5x5_block_small', 'SoftWood', '11', '30', 'models/NightReaper/SoftWood/5x5x5_block_small.mdl', '0'),
('poster21_littlebig', '42700', 'Little Big Planet', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('Con5x100x75_panel_flat', '34029', '5x100x75_panel_flat', 'Concrete', '11', '360', 'models/NightReaper/Concrete/5x100x75_panel_flat.mdl', '0'),
('deskchair', '52952', 'Suite Desk Chair', 'Sit in this fancy desk chair.', '1', '85', 'models/props/cs_office/chair_office.mdl', '0'),
('sam_model', '161', 'Liberty Prime', 'Death is a preferable alternative to communism.', '12', '950', 'models/player/sam.mdl', '0'),
('poster4', '14300', 'Ghostbusters', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('Har10x10x10_block_large', '31658', '10x10x10_block_large', 'HardWood', '11', '60', 'models/NightReaper/HardWood/10x10x10_block_large.mdl', '0'),
('weapon_chainsaw', '44888', 'Chainsaw', 'Chainsaw', '0', '0', 'models/weapons/w_pvp_chainsaw.mdl', '1'),
('trampoiline', '9729', 'Trampoline', 'Bouncy Bouncy!', '8', '1400', 'models/gmod_tower/trampoline.mdl', '0'),
('Sof5x40x85_door', '13310', '5x40x85_door', 'SoftWood', '11', '260', 'models/NightReaper/SoftWood/5x40x85_door.mdl', '0'),
('weapon_pvpstealthbox', '41375', 'Stealth Box', 'Hide yourself inside a box and dissapear completely from your enemies\' view.  Taunt them over towards you, then pop out and end their lives.  Snake used it, so can you.', '0', '0', 'models/weapons/w_pvp_ire.mdl', '1'),
('weapon_akimbo', '25071', 'Akimbo', '', '0', '0', 'models/weapons/w_pvp_akimbo.mdl', '1'),
('trunk', '3595', 'Trunk', 'Store tons of items in here.', '0', '0', 'models/gmod_tower/suitetrunk.mdl', '0'),
('poster51_samandmax', '48625', 'Sam and Max', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('weapon_xm8', '3088', 'XM8', 'XM8', '0', '0', 'models/weapons/w_pvp_xm8.mdl', '1'),
('chairantique', '28736', 'Antique Chair', 'An old chair that can really add some class to your suite.', '1', '95', 'models/props/de_inferno/chairantique.mdl', '0'),
('Robot_model', '29255', 'Robot', 'Its I-Robot .. With 2 eyes!', '12', '25000', 'models/player/Robot.mdl', '0'),
('Con5x5x25_beam_tiny', '776', '5x5x25_beam_tiny', 'Concrete', '11', '70', 'models/NightReaper/Concrete/5x5x25_beam_tiny.mdl', '0'),
('poster23_killingfloor', '17526', 'Killing Floor', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('poster25_arrow', '6192', 'Arrow', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('Con5x40x85_door', '6194', '5x40x85_door', 'Concrete', '11', '260', 'models/NightReaper/Concrete/5x40x85_door.mdl', '0'),
('weapon_physgun', '51452', 'Physgun', '', '0', '0', 'models/weapons/w_physics.mdl', '1'),
('tablecoffe', '55556', 'Coffee Table', 'Place your coffee on this nice table.', '1', '150', 'models/props/de_inferno/tablecoffee.mdl', '0'),
('poster35_supersmash', '47907', 'Super Smash Bros.', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('comfychair', '52043', 'Comfy Chair', 'Sit down in the all new Chair X-500!', '1', '900', 'models/gmod_tower/comfychair.mdl', '0'),
('weapon_toyhammer', '40833', 'Toy Hammer', 'Toy Hammer', '0', '0', 'models/weapons/w_pvp_toy.mdl', '1'),
('suiteshelf', '6216', 'Suite Shelf', 'Place tons of items on these shelves.', '1', '320', 'models/gmod_tower/suiteshelf.mdl', '0'),
('trophy_gmodtoweraddiction', '35771', 'Trophy: GMT Addiction', '', '0', '0', 'models/gmod_tower/trophy_gmodtoweraddiction.mdl', '0'),
('cabitnetdarw', '22788', 'Cabinet Drawer', 'A nice piece of furniture to keep your suite looking good.', '1', '185', 'models/props_interiors/furniture_cabinetdrawer02a.mdl', '0'),
('weapon_rpg', '3117', 'Rocket Launcher', '', '0', '0', 'models/weapons/w_rocket_launcher.mdl', '1'),
('pot01a', '6739', 'Tea Kettle', 'Brew tea with this pot.', '6', '5', 'models/props_interiors/pot01a.mdl', '0'),
('pot02a', '6741', 'Pot', 'Used to cook food.', '6', '5', 'models/props_interiors/pot02a.mdl', '0'),
('Present1', '24393', 'Birthday Present', 'Have a fish\'stick!', '8', '1000', 'models/gmod_tower/present.mdl', '0'),
('Sof10x10x50_beam_short', '8899', '10x10x50_beam_short', 'SoftWood', '11', '140', 'models/NightReaper/SoftWood/10x10x50_beam_short.mdl', '0'),
('empty_bottle', '48834', 'Empty Bottle', 'Contains absolutely nothing.  Or does it?  You can\'t be sure until you break it open.', '4', '3', 'models/props_junk/garbage_glassbottle001a.mdl', '0'),
('computer', '27028', 'Desktop Computer', 'Another computer because you need more power.', '7', '500', 'models/props/cs_office/computer_case.mdl', '0'),
('zelda_model', '9466', 'Zelda', 'For all those Zelda fanatics!', '12', '50000', 'models/player/zelda.mdl', '0'),
('pottery02', '2121', 'Round Pot', 'A rounded pot.', '6', '5', 'models/props_c17/pottery02a.mdl', '0'),
('pottery03', '2122', 'Flat Pot', 'A flat pot for plants.', '6', '5', 'models/props_c17/pottery03a.mdl', '0'),
('pottery04', '2123', 'Vase', 'Holds all your flowers.', '6', '5', 'models/props_c17/pottery04a.mdl', '0'),
('Con5x100x100_window', '28146', '5x100x100_window', 'Concrete', '11', '410', 'models/NightReaper/Concrete/5x100x100_window.mdl', '0'),
('pottery07', '2126', 'Large Vase', 'A large vase.', '6', '5', 'models/props_c17/pottery07a.mdl', '0'),
('alcohol_bottle', '11031', 'Alcohol Bottle', 'Get drunk.', '4', '8', 'models/gmod_tower/boozebottle.mdl', '0'),
('pottery09', '2128', 'Ancient Pot', 'An old pot.', '6', '5', 'models/props_c17/pottery09a.mdl', '0'),
('Har10x10x75_beam_medium', '39429', '10x10x75_beam_medium', 'HardWood', '11', '190', 'models/NightReaper/HardWood/10x10x75_beam_medium.mdl', '0'),
('Sof5x100x25_panel_flat', '35357', '5x100x25_panel_flat', 'SoftWood', '11', '260', 'models/NightReaper/SoftWood/5x100x25_panel_flat.mdl', '0'),
('Har5x5x25_beam_tiny', '16457', '5x5x25_beam_tiny', 'HardWood', '11', '70', 'models/NightReaper/HardWood/5x5x25_beam_tiny.mdl', '0'),
('gmt_godhand', '51773', 'God Hand', 'God-o-hando!', '0', '0', 'models/weapons/w_pvp_ire.mdl', '1'),
('Con5x100x100_full_window', '3157', '5x100x100_full_window', 'Concrete', '11', '430', 'models/NightReaper/Concrete/5x100x100_full_window.mdl', '0'),
('Con5x100x100_panel_flat', '1326', '5x100x100_panel_flat', 'Concrete', '11', '400', 'models/NightReaper/Concrete/5x100x100_panel_flat.mdl', '0'),
('jetpack2', '27228', 'Jetpack', 'Fly over your friends with style.', '8', '1400', 'models/gmod_tower/jetpack.mdl', '0'),
('Har5x50x50_panel_flat', '32994', '5x50x50_panel_flat', 'HardWood', '11', '210', 'models/NightReaper/HardWood/5x50x50_panel_flat.mdl', '0'),
('Gla1x40x40_glass', '26246', '1x40x40_glass', 'Glass', '11', '162', 'models/NightReaper/Glass/1x40x40_glass.mdl', '0'),
('chairrstool', '42735', 'Metal Stool', 'Cold and uncomfortable - but useful.', '1', '55', 'models/props_c17/chair_stool01a.mdl', '0'),
('trophy_humanblur', '41729', 'Trophy: Human Blur', '', '0', '0', 'models/gmod_tower/trophy_humanblur.mdl', '0'),
('Con5x5x50_beam_short', '3682', '5x5x50_beam_short', 'Concrete', '11', '120', 'models/NightReaper/Concrete/5x5x50_beam_short.mdl', '0'),
('fire_extinguisher', '4300', 'Fire Extinguisher', 'Put out fires with this.', '6', '35', 'models/props/cs_office/fire_extinguisher.mdl', '0'),
('beercase', '25831', 'Beer Case (15)', 'Get extra drunk.', '4', '100', 'models/props/CS_militia/caseofbeer01.mdl', '0'),
('Gla1x40x50_glass', '26374', '1x40x50_glass', 'Glass', '11', '182', 'models/NightReaper/Glass/1x40x50_glass.mdl', '0'),
('suitespeaker', '25368', 'Suite Speakers', 'A tall speaker that makes you look richer.', '7', '30', 'models/gmod_tower/suitspeaker.mdl', '0'),
('black_sofa', '48644', 'Black Sofa', 'A black expensive large sofa for your guests.', '1', '400', 'models/gmod_tower/css_couch.mdl', '0'),
('plant1', '6873', 'Office Plant', 'A tall plant that fits any place.', '6', '30', 'models/props/cs_office/plant01.mdl', '0'),
('Sof5x100x75_panel_flat', '272', '5x100x75_panel_flat', 'SoftWood', '11', '360', 'models/NightReaper/SoftWood/5x100x75_panel_flat.mdl', '0'),
('Con5x50x100_full_window', '44109', '5x50x100_full_window', 'Concrete', '11', '330', 'models/NightReaper/Concrete/5x50x100_full_window.mdl', '0'),
('potion1', '14257', 'Normal Potion', 'Change your size to 1 the original.', '17', '150', 'models/props_junk/PopCan01a.mdl', '0'),
('sidetable', '800', 'Bed Side Table', 'Put your reading glasses on.', '1', '70', 'models/gmod_tower/bedsidetable.mdl', '0'),
('Sof10x10x75_beam_medium', '54409', '10x10x75_beam_medium', 'SoftWood', '11', '190', 'models/NightReaper/SoftWood/10x10x75_beam_medium.mdl', '0'),
('potion0.1', '1600', 'Tiny Potion', 'Change your size to 0.1 the original.', '0', '0', 'models/props_junk/PopCan01a.mdl', '0'),
('weapon_glauncher', '36109', 'Grenade Launcher', 'Grenade Launcher', '0', '0', 'models/weapons/w_pvp_grenade.mdl', '1'),
('meddeskc', '27053', 'Medium Desk Corner', 'Like the medium desk, but for people who are bent.', '1', '750', 'models/gmod_tower/meddeskcor.mdl', '0'),
('weapon_spas12', '25528', 'SPAS 12', 'SPAS 12', '0', '0', 'models/weapons/w_pvp_s12.mdl', '1'),
('potion0.5', '1604', 'Small Potion', 'Change your size to 0.5 the original.', '17', '600', 'models/props_junk/PopCan01a.mdl', '0'),
('Har5x75x75_panel_flat', '32187', '5x75x75_panel_flat', 'HardWood', '11', '310', 'models/NightReaper/HardWood/5x75x75_panel_flat.mdl', '0'),
('potion1.2', '1605', 'Slightly Bigger Potion', 'Change your size to 1.2 the original.', '17', '500', 'models/props_junk/PopCan01a.mdl', '0'),
('weapon_pvpbase', '51583', 'PVP Base', '', '0', '0', '', '1'),
('file_box', '26598', 'Filing Box', 'A file box to store all your files.', '6', '35', 'models/props/cs_office/file_box.mdl', '0'),
('weapon_357', '2699', '.357 Magnum', '', '0', '0', 'models/weapons/w_357.mdl', '1'),
('Sof5x100x100_doorway', '5392', '5x100x100_doorway', 'SoftWood', '11', '420', 'models/NightReaper/SoftWood/5x100x100_doorway.mdl', '0'),
('poster63_banjo', '6422', 'Banjo Kazooie', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('weapon_m1grand', '49156', 'M1 Grand', 'M1 Grand', '0', '0', 'models/weapons/w_pvp_m1.mdl', '1'),
('sofachair', '1355', 'Sofa Chair', 'Comfy and large - perfect for relaxing in.', '1', '175', 'models/props/cs_office/sofa_chair.mdl', '0'),
('mysterycatsack', '34880', 'Mysterious Cat Sack', 'An admin has passed this mysterious cat sack along to you.... what could be inside it?', '8', '100', 'models/gmod_tower/catbag.mdl', '0'),
('ironman_model', '6430', 'IronMan', 'The CEO of Stark Industries!', '12', '15000', 'models/player/ironman.mdl', '0'),
('furnituredresser001a', '16474', 'Dresser', 'A dresser to keep your clothes together.', '1', '45', 'models/props_c17/furnituredresser001a.mdl', '0'),
('poster24_gmod', '30798', 'Garry\'s Mod', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('Con5x100x100_double_doorway', '49284', '5x100x100_double_doorway', 'Concrete', '11', '410', 'models/NightReaper/Concrete/5x100x100_double_doorway.mdl', '0'),
('Har5x5x100_beam_long', '23676', '5x5x100_beam_long', 'HardWood', '11', '220', 'models/NightReaper/HardWood/5x5x100_beam_long.mdl', '0'),
('clock', '3229', 'Clock', 'Semi-working clock.', '6', '5', 'models/props_combine/breenclock.mdl', '0'),
('furnituretable002a', '18606', 'Table', 'A square table to place your things on.', '1', '40', 'models/props_c17/furnituretable002a.mdl', '0'),
('weapon_sword', '12900', 'Sword', 'Sword', '0', '0', 'models/weapons/w_pvp_swd.mdl', '1'),
('weapon_rynov', '12908', 'RYNO V', 'America!', '0', '0', 'models/Weapons/w_rocket_launcher.mdl', '1'),
('comfybed', '26814', 'Comfy Bed', 'Sleep well in this new and improved bed!', '1', '1500', 'models/gmod_tower/comfybed.mdl', '0'),
('Har5x50x100_doorway', '45963', '5x50x100_doorway', 'HardWood', '11', '310', 'models/NightReaper/HardWood/5x50x100_doorway.mdl', '0'),
('poster14_counterstrike', '11427', 'Counter-Strike Source', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('Har5x5x5_block_small', '31014', '5x5x5_block_small', 'HardWood', '11', '30', 'models/NightReaper/HardWood/5x5x5_block_small.mdl', '0'),
('potion0.25', '3255', 'Smaller Potion', 'Change your size to 0.25 the original.', '17', '1000', 'models/props_junk/PopCan01a.mdl', '0'),
('trophy_drunkenbastard', '43185', 'Trophy: Drunken Bastard', '', '0', '0', 'models/gmod_tower/trophy_drunkenbastard.mdl', '0'),
('clone_maker', '47289', 'Clone Maker', 'Smith?', '0', '0', 'models/weapons/w_pvp_ire.mdl', '1'),
('digiskinf', '52942', 'Skin 2', 'Test', '16', '1000', 'models/player/digi.mdl', '0'),
('table_shed', '55529', 'Wooden Table', 'A very large durable table.', '1', '95', 'models/props/cs_militia/table_shed.mdl', '0'),
('weapon_shanasword', '21425', 'Shana\'s Sword', 'Shana\'s Sword', '0', '0', 'models/weapons/w_shanasw.mdl', '1'),
('scarecrow_model', '14062', 'Scare Crow', 'A scare crow with a twist', '12', '50000', 'models/player/scarecrow.mdl', '0'),
('poster34_mortalkombat', '947', 'Mortal Kombat', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('Sof5x100x100_panel_flat', '44942', '5x100x100_panel_flat', 'SoftWood', '11', '410', 'models/NightReaper/SoftWood/5x100x100_panel_flat.mdl', '0'),
('couch', '3274', 'Couch', 'A couch that\'s both comfortable and stylish.', '1', '200', 'models/props/cs_militia/couch.mdl', '0'),
('Sof5x100x50_panel_flat', '37405', '5x100x50_panel_flat', 'SoftWood', '11', '310', 'models/NightReaper/SoftWood/5x100x50_panel_flat.mdl', '0'),
('frame', '3283', 'Picture Frame', 'Remember Alyx\'s family with this picture.', '6', '5', 'models/props_lab/frame002a.mdl', '0'),
('Har5x100x100_doorway', '31302', '5x100x100_doorway', 'HardWood', '11', '410', 'models/NightReaper/HardWood/5x100x100_doorway.mdl', '0'),
('poster64_housemd', '27238', 'House MD', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('potion1.7', '1610', 'Extra Big Potion', 'Change your size to 1.7 the original.', '8', '5000', 'models/props_junk/PopCan01a.mdl', '0'),
('potion0.75', '3265', 'Medium Potion', 'Change your size to 0.75 the original.', '17', '350', 'models/props_junk/PopCan01a.mdl', '0'),
('digiskinn', '52950', 'skin 10', 'Test', '16', '650', 'models/player/digi.mdl', '0'),
('digisking', '52943', 'skin 3', 'Test', '16', '1000', 'models/player/digi.mdl', '0'),
('Gla1x90x40_glass', '31366', '1x90x40_glass', 'Glass', '11', '262', 'models/NightReaper/Glass/1x90x40_glass.mdl', '0'),
('nesguitar', '175', 'NES Guitar', 'Famicom with an attitude.  If only this guitar would play songs...oh wait it does!', '8', '3000', 'models/gmod_tower/nesguitar.mdl', '0'),
('obamacutout', '50947', 'Obama Cutout', 'Your very own Obama cutout.', '22', '1500', 'models/gmod_tower/obamacutout.mdl', '0'),
('voicesofancestors', '8615', 'voices of ancestors', 'voices of ancestors', '0', '0', 'models/gmod_tower/headheart.mdl', '0'),
('weapon_ragingbull', '19645', 'Raging Bull', 'Raging Bull', '0', '0', 'models/weapons/w_pvp_ragingb.mdl', '1'),
('renamon_model', '10782', 'Renamon model', 'Rena Power! by VoiDeD~', '0', '0', 'models/player/renamon.mdl', '0'),
('Con5x75x25_panel_flat', '4548', '5x75x25_panel_flat', 'Concrete', '11', '210', 'models/NightReaper/Concrete/5x75x25_panel_flat.mdl', '0'),
('digiskink', '52947', 'skin 7', 'Test', '16', '1250', 'models/player/digi.mdl', '0'),
('Con5x75x50_panel_flat', '6596', '5x75x50_panel_flat', 'Concrete', '11', '260', 'models/NightReaper/Concrete/5x75x50_panel_flat.mdl', '0'),
('Sof5x100x100_double_doorway', '24795', '5x100x100_double_doorway', 'SoftWood', '11', '430', 'models/NightReaper/SoftWood/5x100x100_double_doorway.mdl', '0'),
('poster26_facepunch', '43921', 'Facepunch', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('digiskinj', '52946', 'skin 6', 'Test', '16', '1000', 'models/player/digi.mdl', '0'),
('digiskini', '52945', 'skin 5', 'Test', '16', '1000', 'models/player/digi.mdl', '0'),
('digiskinh', '52944', 'skin 4', 'Test', '16', '1000', 'models/player/digi.mdl', '0'),
('digiskine', '52941', 'Skin 1', 'Test', '16', '1000', 'models/player/digi.mdl', '0'),
('Digi101', '10669', 'Digi Skin 1', 'Use it to change model!', '16', '750', 'models/player/digi.mdl', '0'),
('Gla1x90x50_glass', '31494', '1x90x50_glass', 'Glass', '11', '282', 'models/NightReaper/Glass/1x90x50_glass.mdl', '0'),
('bed', '702', 'Suite Bed', 'Sleep off your worries.', '0', '0', 'models/gmod_tower/suitebed.mdl', '0'),
('Har10x10x25_beam_tiny', '27422', '10x10x25_beam_tiny', 'HardWood', '11', '90', 'models/NightReaper/HardWood/10x10x25_beam_tiny.mdl', '0'),
('tv_large', '28963', 'Bigscreen TV', 'Watch YouTube and other videos on a larger screen.', '7', '3150', 'models/gmod_tower/suitetv_large.mdl', '0'),
('poster53_pvpbattle', '52768', 'PVP Battle', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('Disco', '2729', 'Disco Ball', 'Let\'s get this party started!!', '0', '0', 'models/gmod_tower/discoball.mdl', '0'),
('weapon_crowbar', '50756', 'Crowbar', '', '0', '0', 'models/weapons/w_crowbar.mdl', '1'),
('meddesk', '13477', 'Medium Desk', 'Imagine all the things you can do at this desk ...', '1', '750', 'models/gmod_tower/meddesk.mdl', '0'),
('Har5x75x25_panel_flat', '11707', '5x75x25_panel_flat', 'HardWood', '11', '210', 'models/NightReaper/HardWood/5x75x25_panel_flat.mdl', '0'),
('Har5x75x50_panel_flat', '13755', '5x75x50_panel_flat', 'HardWood', '11', '260', 'models/NightReaper/HardWood/5x75x50_panel_flat.mdl', '0'),
('poster18_prototype', '49948', 'Prototype', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('poster9_borderlands', '45914', 'Borderlands: Claptrap', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('Sof5x5x75_beam_medium', '54879', '5x5x75_beam_medium', 'SoftWood', '11', '170', 'models/NightReaper/SoftWood/5x5x75_beam_medium.mdl', '0'),
('poster42_jakdaxter', '45247', 'Jak & Daxter/Ratchet & Clank', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('poster38_backto', '12753', 'Back to the Future', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('Har10x10x50_beam_short', '1409', '10x10x50_beam_short', 'HardWood', '11', '140', 'models/NightReaper/HardWood/10x10x50_beam_short.mdl', '0'),
('PianoChair', '38923', 'Piano Chair', 'Don\'t float, Don\'t gloat', '1', '750', 'models/fishy/furniture/piano_seat.mdl', '0'),
('poster2', '14298', 'Legend of Zelda: Twlight Princess', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('trophy_longwalk', '48904', 'Trophy: Long Walk Through GMT', '', '0', '0', 'models/gmod_tower/trophy_longwalk.mdl', '0'),
('Har5x100x100_high_window', '54541', '5x100x100_high_window', 'HardWood', '11', '420', 'models/NightReaper/HardWood/5x100x100_high_window.mdl', '0'),
('poster48_3ddotgame', '37694', '3D Dot Game Heroes', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('tv', '354', 'TV', 'Watch YouTube and other videos.', '0', '0', 'models/gmod_tower/suitetv.mdl', '0'),
('Piano', '2871', 'Piano', 'Have mozart playing in your suite', '8', '1500', 'models/fishy/furniture/piano.mdl', '0'),
('trophy_youtubeaddiction', '14833', 'Trophy: YouTube Addiction', '', '0', '0', 'models/gmod_tower/trophy_youtubeaddiction.mdl', '0'),
('remotecontrol', '17378', 'Remote Control', 'Turn on and off your TV with ease.', '7', '15', 'models/props/cs_office/projector_remote.mdl', '0'),
('poster62_eureka', '13233', 'Eureka', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('poster61_pokemon', '26756', 'Pokemon', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('Sof5x100x100_window', '30872', '5x100x100_window', 'SoftWood', '11', '410', 'models/NightReaper/SoftWood/5x100x100_window.mdl', '0'),
('computer_monitor', '55196', 'Desktop Display', 'Another display for your computer.', '7', '130', 'models/props/cs_office/computer_monitor.mdl', '0'),
('poster58_conker', '13582', 'Conker\'s Bad Fur Day', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('weapon_neszapper', '38245', 'NES Zapper', 'NES Zapper', '0', '0', 'models/weapons/w_pvp_neslg.mdl', '1'),
('patiochair01', '1417', 'Patio Chair', 'A comfy outdoor patio chair.', '1', '135', 'models/props/de_tides/patio_chair.mdl', '0'),
('Har5x50x100_high_window', '11292', '5x50x100_high_window', 'HardWood', '11', '320', 'models/NightReaper/HardWood/5x50x100_high_window.mdl', '0'),
('patiochair02', '1418', 'Patio Chair', 'A comfy metal outdoor patio chair.', '1', '100', 'models/props/de_tides/patio_chair2.mdl', '0'),
('poster36_sf4', '15388', 'Street Fighter 4', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('Con10x10x75_beam_medium', '10793', '10x10x75_beam_medium', 'Concrete', '11', '190', 'models/NightReaper/Concrete/10x10x75_beam_medium.mdl', '0'),
('weapon_pistol', '25650', 'Pistol', '', '0', '0', 'models/weapons/w_pistol.mdl', '1'),
('poster56_vidcritter', '54901', 'Video Game Critters', 'A poster you can use to decorate your suite with.', '15', '100', 'models/gmod_tower/poster4.mdl', '0'),
('Sof5x50x25_panel_flat', '34691', '5x50x25_panel_flat', 'SoftWood', '11', '160', 'models/NightReaper/SoftWood/5x50x25_panel_flat.mdl', '0'),
('poster54_ballrace', '51543', 'Ball Race', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('poster52_gmt', '15418', 'GMod Tower', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('poster50_minecraft', '47175', 'Minecraft', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('poster47_metroid', '26990', 'Metroid', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('radio', '3353', 'Radio', 'Listen to some music and chill out.', '0', '0', 'models/props/cs_office/radio.mdl', '0'),
('communist_destroyer', '46551', 'Communist Destroyer', '', '0', '0', '', '1'),
('poster45_okami', '6530', 'Okami', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('Har5x5x50_beam_short', '35044', '5x5x50_beam_short', 'HardWood', '11', '120', 'models/NightReaper/HardWood/5x5x50_beam_short.mdl', '0'),
('weapon_snowball', '47835', 'Snowball', '', '0', '0', 'models/weapons/w_snowball.mdl', '1'),
('sofa', '1681', 'Sofa', 'An expensive large sofa for your guests.', '1', '350', 'models/props/cs_office/sofa.mdl', '0'),
('beerkeg', '12893', 'Beer Keg', 'Get drunk (with friends). 36 drinks.', '4', '250', 'models/props/de_inferno/wine_barrel.mdl', '0'),
('theater_seat', '8298', 'Traincar Seat', 'A nice seat that you\'d find at a train station.', '1', '250', 'models/props_trainstation/traincar_seats001.mdl', '0'),
('poster44_windwaker', '51971', 'Wind Waker', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('weapon_shotgun', '51492', 'Shotgun', '', '0', '0', 'models/weapons/w_shotgun.mdl', '1'),
('poster16_metalgear', '44931', 'Metal Gear Solid', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('poster41_portal2org', '40880', 'Portal 2: Orange', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('poster13_gta4', '30654', 'Grand Theft Auto 4', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('poster39_redrabbit', '52689', 'Red Rabbit', 'A questionably sexy rabbit poster for you.  For a price, of course.', '15', '5000', 'models/gmod_tower/poster3.mdl', '0'),
('breenglobe', '50984', 'Globe', 'Look at the earth and study its geography.', '6', '5', 'models/props_combine/breenglobe.mdl', '0'),
('Har5x5x75_beam_medium', '51134', '5x5x75_beam_medium', 'HardWood', '11', '202', 'models/NightReaper/HardWood/5x5x75_beam_medium.mdl', '0'),
('poster32_p911', '30487', 'Porsche 911', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('candycorn_revolver', '16644', 'Candycorn Revolver', 'Shoot some candy corns.', '0', '0', 'models/weapons/w_pvp_ire.mdl', '1'),
('poster31_scarface', '49911', 'Scarface', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('Sof5x75x25_panel_flat', '15452', '5x75x25_panel_flat', 'SoftWood', '11', '210', 'models/NightReaper/SoftWood/5x75x25_panel_flat.mdl', '0'),
('wood_table', '6227', 'Wood Table', 'A small, but durable wood table.', '1', '75', 'models/props/cs_militia/wood_table.mdl', '0'),
('Har5x100x100_panel_flat', '29962', '5x100x100_panel_flat', 'HardWood', '11', '410', 'models/NightReaper/HardWood/5x100x100_panel_flat.mdl', '0'),
('mdl_spacesuite', '27926', 'Space suit', 'Keep a person alive and comfortable in the harsh environment of outer space.', '8', '950', 'models/player/spacesuit.mdl', '0'),
('microwave', '55293', 'Microwave', 'Cook things to perfection in minutes.', '7', '100', 'models/props/cs_office/microwave.mdl', '0'),
('weapon_rage', '6275', 'Rage Fists', 'Rage Fists', '0', '0', 'models/weapons/w_pvp_ire.mdl', '1'),
('Sof10x10x10_block_large', '46638', '10x10x10_block_large', 'SoftWood', '11', '60', 'models/NightReaper/SoftWood/10x10x10_block_large.mdl', '0'),
('poster28_zombieland', '50893', 'Zombieland', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('poster27_assassian', '46879', 'Assassin\'s Creed', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('weapon_stealthpistol', '29507', 'Stealth Pistol', 'Stealth Pistol', '0', '0', 'models/weapons/w_pistol.mdl', '1'),
('Con5x100x100_high_window', '52834', '5x100x100_high_window', 'Concrete', '11', '420', 'models/NightReaper/Concrete/5x100x100_high_window.mdl', '0'),
('poster22_audiosurf', '41321', 'Audiosurf', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('poster20_fallout3', '46975', 'Fallout 3', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('furnituredrawer001a', '34997', 'Drawer', 'A simple drawer to add to your suite.', '1', '40', 'models/props_c17/furnituredrawer001a.mdl', '0'),
('poster19_bioshock', '50709', 'Bioshock', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('medchair', '27000', 'Medium Chair', 'Just big enough for secks', '1', '450', 'models/gmod_tower/medchair.mdl', '0'),
('weapon_snowball2', '40155', 'Snowball! (12)', 'Hit people with a ball of snow!', '10', '275', 'models/weapons/w_snowball.mdl', '1'),
('Har5x100x75_panel_flat', '48347', '5x100x75_panel_flat', 'HardWood', '11', '360', 'models/NightReaper/HardWood/5x100x75_panel_flat.mdl', '0'),
('huladoll', '27632', 'Hula Doll', 'Reminds you of a place you\'d like to be.', '22', '5', 'models/props_lab/huladoll.mdl', '0'),
('computer_display', '54511', 'Desktop Display w/ Keyboard', 'This display comes with a keyboard and a mouse.', '7', '150', 'models/props/cs_office/computer.mdl', '0'),
('poster43_ratchet', '26018', 'Ratchet and Clank', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('Har5x25x25_panel_flat', '14562', '5x25x25_panel_flat', 'HardWood', '11', '110', 'models/NightReaper/HardWood/5x25x25_panel_flat.mdl', '0'),
('Con5x50x100_window', '43317', '5x50x100_window', 'Concrete', '11', '310', 'models/NightReaper/Concrete/5x50x100_window.mdl', '0'),
('bookshelf3', '51946', 'Suite Shelf', 'A shelf with books on it.', '1', '100', 'models/props/cs_office/bookshelf3.mdl', '0'),
('Con5x75x75_panel_flat', '25028', '5x75x75_panel_flat', 'Concrete', '11', '310', 'models/NightReaper/Concrete/5x75x75_panel_flat.mdl', '0'),
('gmt_extinguisher', '8446', 'Extinguisher', '', '0', '0', '', '1'),
('poster40_portal2blu', '38782', 'Portal 2: Blue', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('weapon_smg1', '6279', 'Sub-machine Gun', '', '0', '0', 'models/weapons/w_smg1.mdl', '1'),
('sunshrine', '3400', 'Sunabouzu Shrine', 'A shrine in honor of Sunabouzu.', '6', '150000', 'models/gmod_tower/sunshrine.mdl', '0'),
('Har5x100x25_panel_flat', '27867', '5x100x25_panel_flat', 'HardWood', '11', '260', 'models/NightReaper/HardWood/5x100x25_panel_flat.mdl', '0'),
('poster10_silenthill', '25761', 'Silent Hill', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('kitchentable', '53170', 'Kitchen Table', 'Eat your exotic food at this new table!', '1', '2000', 'models/gmod_tower/kitchentable.mdl', '0'),
('weapon_patriot', '51142', 'Patriot', 'Patriot', '0', '0', 'models/weapons/w_pvp_patriotmg.mdl', '1'),
('poster8_district9', '24672', 'District 9', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('Con5x5x100_beam_long', '47879', '5x5x100_beam_long', 'Concrete', '11', '220', 'models/NightReaper/Concrete/5x5x100_beam_long.mdl', '0'),
('weapon_invremover', '20769', 'Inventory REMOVER', '', '0', '0', 'models/weapons/w_toolgun.mdl', '1'),
('poster5_left4dead', '21285', 'Left 4 Dead', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('Sof10x10x100_beam_long', '53096', '10x10x100_beam_long', 'SoftWood', '11', '240', 'models/NightReaper/SoftWood/10x10x100_beam_long.mdl', '0'),
('poster1', '14297', 'Classic Video Games', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('painkiller', '54831', 'Painkillers', 'Heal all your wounds. Damage, drunk, fire, freeze.', '21', '15', 'models/props_lab/jar01a.mdl', '0'),
('chair01a', '25667', 'Bar chair.', '', '0', '0', 'models/props_interiors/furniture_chair01a.mdl', '0'),
('mikucake', '27719', 'Miku\'s Birthday Cake', '', '0', '0', 'models/gmod_tower/mikucake.mdl', '0'),
('Con5x50x100_doorway', '30282', '5x50x100_doorway', 'Concrete', '11', '310', 'models/NightReaper/Concrete/5x50x100_doorway.mdl', '0'),
('Sof5x75x75_panel_flat', '35932', '5x75x75_panel_flat', 'SoftWood', '11', '310', 'models/NightReaper/SoftWood/5x75x75_panel_flat.mdl', '0'),
('Sof5x75x50_panel_flat', '17500', '5x75x50_panel_flat', 'SoftWood', '11', '260', 'models/NightReaper/SoftWood/5x75x50_panel_flat.mdl', '0'),
('poster30_indiania', '48795', 'Indiana Jones', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('Christie_model', '2396', 'Christie', 'Christie... and her 7 personalities', '12', '12000', 'models/player/christie.mdl', '0'),
('weapon_invsaver', '46783', 'Inventory saver', '', '0', '0', 'models/weapons/w_toolgun.mdl', '1'),
('IMac', '1201', 'IMac', 'Made by Apple!', '7', '750', 'models/gmod_tower/suite/imac.mdl', '0'),
('phone', '3421', 'Phone', 'A phone to keep you in contact with the world.', '7', '20', 'models/props/cs_office/phone.mdl', '0'),
('trophy_arcadejunkie', '33034', 'Trophy: Arcade Junkie', '', '0', '0', 'models/gmod_tower/trophy_arcadejunkie.mdl', '0'),
('Sof5x5x50_beam_short', '9134', '5x5x50_beam_short', 'SoftWood', '11', '120', 'models/NightReaper/SoftWood/5x5x50_beam_short.mdl', '0'),
('poster7_tf2pryo', '19631', 'TF2: Pyro', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('jetpack2_admin2', '52500', 'Admin Jetpack (1.0)', '', '0', '800', 'models/gmod_tower/jetpack.mdl', '0'),
('Sof10x10x25_beam_tiny', '31167', '10x10x25_beam_tiny', 'SoftWood', '11', '90', 'models/NightReaper/SoftWood/10x10x25_beam_tiny.mdl', '0'),
('Sof5x50x100_full_window', '32160', '5x50x100_full_window', 'SoftWood', '11', '315', 'models/NightReaper/SoftWood/5x50x100_full_window.mdl', '0'),
('poster55_virus', '6848', 'Virus', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('Sof5x50x100_high_window', '26272', '5x50x100_high_window', 'SoftWood', '11', '320', 'models/NightReaper/SoftWood/5x50x100_high_window.mdl', '0'),
('Sof5x50x50_panel_flat', '36739', '5x50x50_panel_flat', 'SoftWood', '210', '0', 'models/NightReaper/SoftWood/5x50x50_panel_flat.mdl', '0'),
('weapon_pulsesmartpen', '33689', 'Pulse Smart Pen', 'Pulse Smart Pen', '0', '0', 'models/weapons/w_psmartpen.mdl', '1'),
('Har5x100x50_panel_flat', '29915', '5x100x50_panel_flat', 'HardWood', '11', '310', 'models/NightReaper/HardWood/5x100x50_panel_flat.mdl', '0'),
('Con5x50x50_panel_flat', '25835', '5x50x50_panel_flat', 'Concrete', '11', '210', 'models/NightReaper/Concrete/5x50x50_panel_flat.mdl', '0'),
('Sof5x50x100_doorway', '33008', '5x50x100_doorway', 'SoftWood', '11', '310', 'models/NightReaper/SoftWood/5x50x100_doorway.mdl', '0'),
('joker_model', '54727', 'Joker', 'Who will have the last laugh?', '12', '25000', 'models/player/joker.mdl', '0'),
('Har5x100x100_double_doorway', '7375', '5x100x100_double_doorway', 'HardWood', '11', '415', 'models/NightReaper/HardWood/5x100x100_double_doorway.mdl', '0'),
('weapon_supershotty', '53203', 'Super Shotty', 'Super Shotty', '0', '0', 'models/weapons/w_pvp_supershoty.mdl', '1'),
('poster59_mario', '6868', 'Mario', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('Sof5x100x100_high_window', '28936', '5x100x100_high_window', 'SoftWood', '11', '420', 'models/NightReaper/SoftWood/5x100x100_high_window.mdl', '0'),
('weapon_snowball1', '40154', 'Snowball! (6)', 'Hit people with a ball of snow!', '10', '150', 'models/weapons/w_snowball.mdl', '1'),
('Har5x100x100_window', '43827', '5x100x100_window', 'HardWood', '11', '420', 'models/NightReaper/HardWood/5x100x100_window.mdl', '0'),
('lamp', '1598', 'Desktop Lamp', 'Add some light to your desktop.', '6', '15', 'models/props_lab/desklamp01.mdl', '0'),
('suitetable', '6163', 'Suite Table', 'A well-crafted table for your stuff.', '1', '200', 'models/gmod_tower/suitetable.mdl', '0'),
('chair1', '6369', 'Chair', 'A homely chair to sit on.', '1', '90', 'models/props_c17/furniturechair001a.mdl', '0'),
('rabbitskin²', '53331', 'PVP Rabbit', 'Skin by Hells High.', '9', '1800', 'models/player/redrabbit3.mdl', '0'),
('poster37_batman', '12730', 'Batman', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('cabinet', '12734', 'Letter Box Cabinet', 'Used to store mail with.', '6', '35', 'models/props_lab/partsbin01.mdl', '0'),
('Smith_model', '30919', 'Agent Smith', 'Mr Anderson!!', '12', '54000', 'models/player/smith.mdl', '0'),
('furnituredrawer002a', '34999', 'Drawer', 'A small and simple drawer for your suite.', '1', '35', 'models/props_c17/furnituredrawer002a.mdl', '0'),
('Con5x25x25_panel_flat', '7403', '5x25x25_panel_flat', 'Concrete', '11', '110', 'models/NightReaper/Concrete/5x25x25_panel_flat.mdl', '0'),
('Con5x50x25_panel_flat', '23787', '5x50x25_panel_flat', 'Concrete', '11', '160', 'models/NightReaper/Concrete/5x50x25_panel_flat.mdl', '0'),
('weapon_shield', '25576', 'Shield', 'Keep the players away.', '0', '0', 'models/weapons/w_pvp_ire.mdl', '1'),
('digiskinl', '52948', 'skin 8', 'Test', '16', '1200', 'models/player/digi.mdl', '0'),
('furnituretable001a', '18604', 'Table', 'A small round table to place things on.', '1', '70', 'models/props_c17/furnituretable001a.mdl', '0'),
('poster3', '14299', 'Portal: Companion Cube', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('poster17_inception', '45331', 'Inception', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('jetpack2_admin3', '52501', 'Admin Jetpack (3.0)', '', '0', '800', 'models/gmod_tower/jetpack.mdl', '0'),
('Har5x100x100_full_window', '4864', '5x100x100_full_window', 'HardWood', '11', '430', 'models/NightReaper/HardWood/5x100x100_full_window.mdl', '0'),
('workinglamp', '14826', 'Lamp', 'A decorative lamp that can be turned off and on.', '1', '250', 'models/gmod_tower/suite_lamptakenfromhl2.mdl', '0'),
('gmt_confetti', '47950', 'Confetti!', '', '0', '0', 'models/weapons/w_bugbait.mdl', '1'),
('picnic_table', '1477', 'Picnic Table', 'Setup a picnic or host an event with this table.', '1', '150', 'models/gmod_tower/patio_table.mdl', '0'),
('gmt_exterminator', '7938', 'Rabbit Exterminator', '', '0', '0', '', '1'),
('poster33_bmw', '15353', 'BMW', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('trophy_starfox', '52641', 'Trophy: Starfox', '', '0', '0', 'models/gmod_tower/trophy_starfox.mdl', '0'),
('candycane', '51949', 'Candy Cane', 'Candy cane wrapped in ribbons.', '10', '80', 'models/gmod_tower/candycane.mdl', '0'),
('clipboard', '53156', 'Clipboard', 'Manage your company.', '6', '5', 'models/props_lab/clipboard.mdl', '0'),
('jetpack2_admin1', '52499', 'Admin Jetpack (0.4)', '', '0', '800', 'models/gmod_tower/jetpack.mdl', '0'),
('Har5x40x85_door', '45375', '5x40x85_door', 'HardWood', '11', '260', 'models/NightReaper/HardWood/5x40x85_door.mdl', '0'),
('barstool', '26198', 'Bar Stool', 'Sit up high, just like at a bar.', '1', '65', 'models/props/cs_militia/barstool01.mdl', '0'),
('Sof5x100x100_full_window', '34824', '5x100x100_full_window', 'SoftWood', '11', '430', 'models/NightReaper/SoftWood/5x100x100_full_window.mdl', '0'),
('gmt_adminpunch', '21883', 'Admin Fistsmoke', 'Punch your enemies...', '0', '0', 'models/weapons/w_pvp_ire.mdl', '1'),
('trophy_ballracevirgin', '49675', 'Trophy: Ball Race Virgin', '', '0', '0', 'models/gmod_tower/trophy_ballracevirgin.mdl', '0'),
('pottery06', '2125', 'Fancy Pot', 'A pot with a nifty design.', '6', '5', 'models/props_c17/pottery06a.mdl', '0'),
('sack_plushie', '54372', 'Sack Plushie', 'Holiday version of everyone\'s favorite plushie.', '10', '3500', 'models/gmod_tower/sackplushie.mdl', '0'),
('statueofbreen', '42924', 'statue of breen', 'statue of breen', '0', '0', 'models/props_combine/breenbust.mdl', '0'),
('Har5x50x100_full_window', '17180', '5x50x100_full_window', 'HardWood', '11', '330', 'models/NightReaper/HardWood/5x50x100_full_window.mdl', '0'),
('oldmicrowave', '3477', 'Old Microwave', 'Old, but still usable.', '7', '80', 'models/props/cs_militia/microwave01.mdl', '0'),
('wepon_357', '1944', '.357', '', '0', '0', 'models/weapons/w_357.mdl', '1'),
('poster15_crysis', '12351', 'Crysis', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('tvcabinet', '2353', 'TV Cabinet', 'Organize your entertainment with this TV cabinet.', '1', '500', 'models/gmod_tower/gt_woodcabinet01.mdl', '0'),
('weapon_handgun', '50420', 'Handgun', 'Kabang.', '0', '0', 'models/weapons/w_pvp_ire.mdl', '1'),
('weapon_sniper', '25716', 'Sniper', 'Sniper', '0', '0', 'models/weapons/w_pvp_as50.mdl', '1'),
('poster12_kirby', '5936', 'Kirby', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('christmas_present', '11534', 'Holiday Present', 'A present...?  Don\'t you wonder what\'s inside it?', '0', '0', 'models/gmod_tower/present2.mdl', '0'),
('digiskinm', '52949', 'skin 9', 'Test', '16', '1000', 'models/player/digi.mdl', '0'),
('toothbrushset01', '26770', 'Tooth Brush Set', 'Keep your tooth brushes in one set.', '6', '5', 'models/props/cs_militia/toothbrushset01.mdl', '0'),
('Har5x50x100_window', '23375', '5x50x100_window', 'HardWood', '11', '310', 'models/NightReaper/HardWood/5x50x100_window.mdl', '0'),
('bar01', '2977', 'Bar Table', 'A table, stolen from a bar.', '1', '400', 'models/props/cs_militia/bar01.mdl', '0'),
('furnituredrawer003a', '35001', 'Drawer', 'A tall and simple drawer for your suite.', '1', '20', 'models/props_c17/furnituredrawer003a.mdl', '0'),
('Gla1x90x90_glass', '32006', '1x90x90_glass', 'Glass', '11', '362', 'models/NightReaper/Glass/1x90x90_glass.mdl', '0'),
('weapon_babynade', '44516', 'Babynade', 'Babynade', '0', '0', 'models/props_c17/doll01.mdl', '1'),
('Con5x50x100_high_window', '38221', '5x50x100_high_window', 'Concrete', '11', '320', 'models/NightReaper/Concrete/5x50x100_high_window.mdl', '0'),
('Con5x100x100_doorway', '55505', '5x100x100_doorway', 'Concrete', '11', '405', 'models/NightReaper/Concrete/5x100x100_doorway.mdl', '0'),
('Con10x10x50_beam_short', '42656', '10x10x50_beam_short', 'Concrete', '11', '140', 'models/NightReaper/Concrete/10x10x50_beam_short.mdl', '0'),
('poster57_ico', '15481', 'ICO', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster4.mdl', '0'),
('weapon_semiauto', '47062', 'Semi-auto Glock', 'Semi-auto Glock', '0', '0', 'models/weapons/w_pvp_semiauto.mdl', '1'),
('Har5x50x25_panel_flat', '30946', '5x50x25_panel_flat', 'HardWood', '11', '160', 'models/NightReaper/HardWood/5x50x25_panel_flat.mdl', '0'),
('jetpack1', '27227', 'Fairy Wings', 'Tinker Bell\'s remains are now part of your wingspan.', '8', '800', 'models/gmod_tower/fairywings.mdl', '0'),
('Con5x5x75_beam_medium', '43975', '5x5x75_beam_medium', 'Concrete', '11', '170', 'models/NightReaper/Concrete/5x5x75_beam_medium.mdl', '0'),
('Con5x5x5_block_small', '55217', '5x5x5_block_small', 'Concrete', '11', '30', 'models/NightReaper/Concrete/5x5x5_block_small.mdl', '0'),
('hatsunmiku_model', '853', 'Hatsunmiu', 'Your avarage 16 year old music-fanatic', '12', '50000', 'models/player/christie.mdl', '0'),
('Sof5x5x25_beam_tiny', '3502', '5x5x25_beam_tiny', 'SoftWood', '11', '70', 'models/NightReaper/SoftWood/5x5x25_beam_tiny.mdl', '0'),
('conffetigun1', '40462', 'Confetti! (3)', '', '22', '60', 'models/weapons/w_bugbait.mdl', '1'),
('suitelamp', '2993', 'Suite Lamp', 'A decorative lamp.', '1', '25', 'models/gmod_tower/suite_lamptakenfromhl2.mdl', '0'),
('trophy_geometricallyimpossible', '51736', 'Trophy: Geometrically Impossible', '', '0', '0', 'models/gmod_tower/trophy_geometricallyimpossible.mdl', '0'),
('poster29_28days', '10415', '28 Days Later', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster2.mdl', '0'),
('jar01a', '6307', 'Jar', 'Pills here.', '6', '5', 'models/props_lab/jar01a.mdl', '0'),
('furniture_couch02a', '15022', 'Furniture Couch', 'Sit in this couch and enjoy the fire.', '1', '250', 'models/props/de_inferno/furniture_couch02a.mdl', '0'),
('mikucake_slice', '2399', 'Miku\'s Birthday Cake (slice)', '', '0', '0', 'models/gmod_tower/mikucake_slice.mdl', '0'),
('potted_plant1', '34953', 'Potted Plant', 'A nice plant.', '6', '10', 'models/props/de_inferno/potted_plant2.mdl', '0'),
('weapon_ar2', '3000', 'AR2 Rifle', '', '0', '0', 'models/weapons/w_irifle.mdl', '1'),
('snowman', '14476', 'Snowman', 'A wonderous snowman that will bring holiday cheer.', '10', '600', 'models/gmod_tower/snowman.mdl', '0'),
('trophy_zeldafanboy', '9932', 'Trophy: Zelda Fanboy', '', '0', '0', 'models/gmod_tower/trophy_zeldafanboy.mdl', '0'),
('Sof5x25x25_panel_flat', '18307', '5x25x25_panel_flat', 'SoftWood', '11', '110', 'models/NightReaper/SoftWood/5x25x25_panel_flat.mdl', '0'),
('faith_model', '44231', 'Faith', 'Wait till you see her twin sister \'trust\'', '12', '10000', 'models/player/faith.mdl', '0'),
('backpack', '25477', 'Backpack', 'Get access to your trunk at any place', '8', '10000', 'models/gmod_tower/jetpack.mdl', '0'),
('deckchair', '51928', 'Deck Chair', 'A comfty and affordable deck chair.', '1', '85', 'models/deckchair.mdl', '0'),
('poster6_waroftheservers', '15573', 'War of the Servers', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster1.mdl', '0'),
('Con10x10x25_beam_tiny', '20263', '10x10x25_beam_tiny', 'Concrete', '11', '90', 'models/NightReaper/Concrete/10x10x25_beam_tiny.mdl', '0'),
('gmt_beatstick', '38690', 'Admin Beatstick', 'Beat em up.', '0', '0', 'models/weapons/w_stunbaton.mdl', '1'),
('gmt_laser_pen', '41261', 'Unknown', '', '0', '0', 'models/weapons/w_pistol.mdl', '1'),
('restauranttable', '39744', 'Restaurant Table', 'A fancy table used mostly for restaurants.', '1', '145', 'models/props/de_tides/restaurant_table.mdl', '0'),
('Con5x100x25_panel_flat', '13549', '5x100x25_panel_flat', 'Concrete', '11', '260', 'models/NightReaper/Concrete/5x100x25_panel_flat.mdl', '0'),
('Con5x100x50_panel_flat', '15597', '5x100x50_panel_flat', 'Concrete', '11', '310', 'models/NightReaper/Concrete/5x100x50_panel_flat.mdl', '0'),
('Con10x10x100_beam_long', '31288', '10x10x100_beam_long', 'Concrete', '11', '240', 'models/NightReaper/Concrete/10x10x100_beam_long.mdl', '0'),
('Zoey_model', '47009', 'Zoey', 'Multitasking is one advantage with Zoey.', '12', '1250', 'models/player/zoey.mdl', '0'),
('trophy_fancypants', '22584', 'Trophy: Fancy Pants', '', '0', '0', 'models/gmod_tower/trophy_fancypants.mdl', '0'),
('trophy_jackrabbit', '23211', 'Trophy: Jack Rabbit', '', '0', '0', 'models/gmod_tower/trophy_jackrabbit.mdl', '0'),
('poster46_kingdomhearts', '37301', 'Kingdom Hearts', 'A poster you can use to decorate your suite with.', '15', '35', 'models/gmod_tower/poster3.mdl', '0'),
('trophy_devhq', '26681', 'Trophy: Smooth Detective', '', '0', '0', 'models/gmod_tower/trophy_devhq.mdl', '0'),
('weapon_thompson', '47611', 'Thompson', 'Thompson', '0', '0', 'models/weapons/w_pvp_tom.mdl', '1'),
('weapon_physcannon', '22985', 'Physcannon', '', '0', '0', 'models/weapons/w_physics.mdl', '1'),
('gun_cabinet', '53655', 'Gun Cabinet', 'A display cabinet filled with authentic shotguns.', '1', '500', 'models/props/cs_militia/gun_cabinet.mdl', '0'),
('weapon_tmp', '3128', 'Tmp', '', '0', '0', 'models/weapons/w_smg_tmp.mdl', '1'),
('weapon_flechettegun', '7075', 'Flechette Gun', '', '0', '0', 'models/weapons/w_smg1.mdl', '1'),
('weapon_fists', '12615', 'Fists', '', '0', '0', '', '1'),
('fworkfirefly', '3305', 'Fireflies', 'Shoots colorful lights in a random upward pattern which twinkle like fireflies.', '14', '150', 'models/gmod_tower/firework_fountain.mdl', '0'),
('rabbitskin{', '53276', 'Ichigo Rabbit', 'Use it to become it.', '9', '1000', 'models/player/redrabbit2.mdl', '0'),
('fworkring', '410', 'Ring Firework', 'Rocket-based firework that explodes in a ring-like pattern.', '14', '130', 'models/gmod_tower/firework_rocket.mdl', '0'),
('weapon_fiveseven', '36449', 'Fiveseven', '', '0', '0', 'models/weapons/w_pist_fiveseven.mdl', '1'),
('rabbitskint', '53269', 'Zombie Rabbit', 'Use it to become it.', '9', '950', 'models/player/redrabbit2.mdl', '0'),
('weapon_mac10', '12398', 'Mac10', '', '0', '0', 'models/weapons/w_smg_mac10.mdl', '1'),
('weapon_pumpshotgun', '50574', 'Pump Shotgun', '', '0', '0', 'models/weapons/w_shot_m3super90.mdl', '1'),
('rabbitskin£', '53316', 'Tribe Rabbit', 'They are civilized.', '9', '1200', 'models/player/redrabbit3.mdl', '0'),
('weapon_planegun', '46799', 'Unknown', '', '0', '0', 'models/weapons/w_357.mdl', '1'),
('weapon_mp5', '3047', 'Mp5', '', '0', '0', 'models/weapons/w_smg_mp5.mdl', '1'),
('rabbitskin«', '53324', 'Flash Rabbit', 'Skin by  ningaglio.', '0', '0', 'models/player/redrabbit3.mdl', '0'),
('potion5', '14261', 'Test Potion', 'Change your size to 5 the original.', '8', '0', 'models/props_junk/PopCan01a.mdl', '0'),
('rabbitskinq', '53266', 'Soldier Rabbit', 'Use it to become it.', '9', '700', 'models/player/redrabbit2.mdl', '0'),
('RabbitTeslaCapacitor', '45792', 'Rabbit Tesla Capacitor', 'For cool light shows!', '0', '0', '', '0');
INSERT INTO `gm_items` (`unique`, `id`, `name`, `desc`, `storeid`, `price`, `model`, `weapon`) VALUES
('rabbitskiny', '53274', 'Transparent Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('rabbitskin±', '53330', 'Gir Rabbit', 'Skin by CrimsonFloyd.', '9', '1400', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin°', '53329', 'Ratchet Rabbit', 'Skin by CrimsonFloyd.', '9', '1400', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin®', '53327', 'Mr Burns Rabbit', 'Skin by Zexion-91.', '9', '1500', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin­', '53326', 'Sack Rabbit', 'Skin by AlexGhost.', '9', '1500', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin¬', '53325', 'Hunter Rabbit', 'Skin by Andy.', '0', '0', 'models/player/redrabbit3.mdl', '0'),
('rabbitskinª', '53323', 'Renamon Rabbit', 'Blake: \"Only for the real furry.\" Skin by Sapphire Dragon.', '0', '0', 'models/player/redrabbit3.mdl', '0'),
('rabbitskinj', '53259', 'Old Buhyena Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('rabbitskinw', '53272', 'Cube Rabbit', 'Skin by Nican.', '9', '1000', 'models/player/redrabbit2.mdl', '0'),
('rabbitskin¨', '53321', 'Tom Rabbit', 'Skin by Captain Quirk.', '9', '1350', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin§', '53320', 'Jerry Rabbit', 'Skin by Captain Quirk.', '9', '1350', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin¦', '53319', 'GBuhyena Rabbit', 'Skin by -DiGi-', '9', '1250', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin¥', '53318', 'Buhyena Pup Rabbit', 'Skin by -DiGi-', '9', '1250', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin¤', '53317', 'Wolverine Rabbit', 'Skin by Wolverine and Davey-G', '9', '1000', 'models/player/redrabbit3.mdl', '0'),
('rabbitskinr', '53267', 'Gordon Rabbit', 'Use it to become it.', '9', '1500', 'models/player/redrabbit2.mdl', '0'),
('rabbitskin¢', '53315', 'CandyCane Rabbit', 'Skin by Suicide Cupcakes.', '9', '900', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin¡', '53314', 'Cat Rabbit', 'Skin by Cat.', '0', '0', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin ', '53313', 'Raving Rabbit', 'Go home. Skin by Zargero.', '9', '1000', 'models/player/redrabbit3.mdl', '0'),
('rabbitskinŸ', '53312', 'Louis Rabbit', 'PEELZ WHERE. Skin by Zargero.', '9', '900', 'models/player/redrabbit3.mdl', '0'),
('rabbitskinž', '53311', 'Avatar Rabbit', 'Skin by Cute Coon :3', '9', '1500', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin', '53310', 'Felinae Rabbit', 'Skin by Suicide Cupcakes.', '9', '900', 'models/player/redrabbit3.mdl', '0'),
('rabbitskinœ', '53309', 'Spock Rabbit', 'Use it to become it.', '9', '1100', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin™', '53306', 'Dr. Manhattan Rabbit', 'Skin by Firm.', '9', '1000', 'models/player/redrabbit3.mdl', '0'),
('rabbitskinz', '53275', 'Bugs Rabbit', 'Use it to become it.', '9', '950', 'models/player/redrabbit2.mdl', '0'),
('rabbitskin›', '53308', 'Vampire Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit3.mdl', '0'),
('rabbitskinš', '53307', 'Batman Rabbit', 'Use it to become it.', '9', '1000', 'models/player/redrabbit3.mdl', '0'),
('rabbitskin‚', '53283', 'Tuxedo Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('rabbitskin', '53282', 'Ice Rabbit', 'Use it to become it.', '9', '900', 'models/player/redrabbit2.mdl', '0'),
('rabbitskin€', '53281', 'Midna Rabbit', 'Use it to become it.', '9', '700', 'models/player/redrabbit2.mdl', '0'),
('rabbitskin', '53280', 'Boota Rabbit', 'Skin by Nican. Row Row Fight the Power!', '9', '1000', 'models/player/redrabbit2.mdl', '0'),
('rabbitskin|', '53277', 'Pikachu Rabbit', 'Use it to become it.', '9', '1500', 'models/player/redrabbit2.mdl', '0'),
('rabbitskin©', '53322', 'Hazard Rabbit', 'Skin by arleitiss2.', '0', '0', 'models/player/redrabbit3.mdl', '0'),
('rabbitskinv', '53271', 'Warning Rabbit', 'Skin by Nican.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('rabbitskinu', '53270', 'Lava Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('rabbitskins', '53268', 'Lucario Rabbit', 'Skin by Nican, dedicated to Yusage/FoxMan.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('fworkufo', '27943', 'UFO Firework', 'Spins and travels around like a small UFO would.', '14', '60', 'models/gmod_tower/firework_ufo.mdl', '0'),
('rabbitskino', '53264', 'Undead Rabbit', 'Use it to become it.', '9', '900', 'models/player/redrabbit2.mdl', '0'),
('rabbitskinl', '53261', 'White Rabbit', 'Use it to become it.', '9', '1200', 'models/player/redrabbit2.mdl', '0'),
('rabbitskink', '53260', 'Minion Buhyena Rabbit', 'Skin by -DiGi-', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('rabbitskini', '53258', 'Dark Red Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('rabbitskinh', '53257', 'Pink Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('rabbitsking', '53256', 'Orange Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('rabbitskine', '53254', 'Blue Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('fworkscreamer', '7928', 'Screamer Firework', 'Rocket-based firework that emits a loud sound.', '14', '75', 'models/gmod_tower/firework_groundrocket.mdl', '0'),
('fworkpalm', '364', 'Palm Firework', 'Rocket-based firework that explodes in the shape of a palm tree.', '14', '350', 'models/gmod_tower/firework_rocket.mdl', '0'),
('fworkmulti', '959', 'Multi Firework', 'Rocket-based firework that explodes with two shades of colors.', '14', '80', 'models/gmod_tower/firework_rocket.mdl', '0'),
('Present3', '24395', 'Admin Present', 'From omgmac!', '0', '100', 'models/items/cs_gift.mdl', '0'),
('ttt', '820', 'Tic Tac Toe', 'Now you can play in your suite!', '7', '10000', 'models/props_wasteland/kitchen_counter001b.mdl', '0'),
('weapon_snowball_death', '11537', 'Snowball', '', '0', '0', 'models/weapons/w_snowball.mdl', '1'),
('rabbitskinp', '53265', 'Spider Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('rabbitskin—', '53304', 'Mickey Rabbit', 'Skin by Andy^integrity.', '9', '800', 'models/player/redrabbit3.mdl', '0'),
('rabbitskinx', '53273', 'Joker Rabbit', 'Use it to become it.', '9', '1200', 'models/player/redrabbit2.mdl', '0'),
('weapon_medkit', '25330', 'Medkit', '', '0', '0', 'models/weapons/w_medkit.mdl', '1'),
('fworkfountain', '7380', 'Fountain Firework', 'Emits a fountain of wondrous colored sparks.', '14', '125', 'models/gmod_tower/firework_fountain.mdl', '0'),
('rabbitskinm', '53262', 'Bee Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('rabbitskin¯', '53328', 'Cheshire Rabbit', 'Skin by CrimsonFloyd.', '9', '1400', 'models/player/redrabbit3.mdl', '0'),
('RabbitTesla', '19974', 'Rabbit Tesla', 'Makes your ears have electricity!', '9', '2500', '', '0'),
('weapon_ak47', '6031', 'Ak47', '', '0', '0', 'models/weapons/w_rif_ak47.mdl', '1'),
('rabbitskin˜', '53305', 'Santa Rabbit', 'Ho ho here comes Santa. Skin by Firm.', '9', '800', 'models/player/redrabbit3.mdl', '0'),
('weapon_base', '6171', 'Unknown', '', '0', '0', 'models/weapons/w_357.mdl', '1'),
('rabbitskin}', '53278', 'Jazz Rabbit', 'Use it to become it.', '9', '1250', 'models/player/redrabbit2.mdl', '0'),
('fworkspinrocket', '35314', 'Spinning Rocket Firework', 'Rocket-based firework that lifts off while spinning and explodes in multiple colors.', '14', '90', 'models/gmod_tower/firework_groundrocket.mdl', '0'),
('gmt_retroguitar', '8969', 'NES Guitar', '', '0', '0', 'models/weapons/w_rguitar.mdl', '1'),
('fworkrocket', '1982', 'Rocket Firework', 'Rocket-based firework that explodes from the center.', '14', '50', 'models/gmod_tower/firework_groundrocket.mdl', '0'),
('flechette_gun', '21625', 'Flechette Gun', '', '0', '0', 'models/weapons/w_pistol.mdl', '1'),
('tetris', '7101', 'Blockles', 'Warning you might get stuck in walls!', '7', '10000', 'models/gmod_tower/gba.mdl', '0'),
('rabbitskinf', '53255', 'Purple Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit2.mdl', '0'),
('weapon_m4', '1437', 'M4', '', '0', '0', 'models/weapons/w_rif_m4a1.mdl', '1'),
('rabbitskinn', '53263', 'Army Rabbit', 'Use it to become it.', '9', '650', 'models/player/redrabbit2.mdl', '0'),
('weapon_deagle', '24993', 'Deagle', '', '0', '0', 'models/weapons/w_pist_deagle.mdl', '1'),
('weapon_para', '6277', 'Para', '', '0', '0', 'models/weapons/w_mach_m249para.mdl', '1'),
('fworkwine', '448', 'Wine Firework', 'Rocket-based firework that explodes in the shape of a wine glass.', '14', '400', 'models/gmod_tower/firework_rocket.mdl', '0'),
('rabbitskin~', '53279', 'Bunny Rabbit', 'Use it to become it.', '9', '1200', 'models/player/redrabbit2.mdl', '0'),
('weapon_glock', '12597', 'Glock', '', '0', '0', 'models/weapons/w_pist_glock18.mdl', '1'),
('mdl_yoshi', '54765', 'Yoshi', 'Yooshi!', '13', '15000', 'models/player/yoshi.mdl', '0'),
('bball', '3096', 'Beach Ball', 'We stole this from the pool, don\'t tell anyone!', '22', '500', 'models/gmod_tower/beachball.mdl', '0'),
('trampoline', '4827', 'Trampoline', 'Jump around all crazy like!', '22', '500', 'models/gmod_tower/trampoline.mdl', '0'),
('mdl_bobafett', '46293', 'Boba Fett', 'There\'s a price on your head and I\'ve come to collect.', '13', '17000', 'models/player/bobafett.mdl', '0'),
('Sof5x5x100_beam_long2', '51147', '5x5x100_beam_long', 'SoftWood', '11', '220', 'models/NightReaper/SoftWood/5x5x100_beam_long.mdl', '0'),
('suitetetris', '12681', 'Blockless Machine', 'Your own personal Blockless machine!', '0', '0', 'models/gmod_tower/gba.mdl', '0'),
('plush_fox', '1785', 'Plushy: Fox', 'A cute fuzzy plush.', '22', '1500', 'models/gmod_tower/plush_fox.mdl', '0'),
('mdl_zelda', '54657', 'Zelda', 'When peace returns to Hyrule, it will be time for us to say goodbye.', '13', '4000', 'models/player/zelda.mdl', '0'),
('fwork_screamer', '12328', 'Screamer Firework', 'Rocket-based firework that emits a loud sound.', '14', '75', 'models/gmod_tower/firework_groundrocket.mdl', '0'),
('mdl_teslaarmor', '28081', 'Tesla Armor', 'Nikola Tesla is so jealous.', '13', '25000', 'models/player/teslapower.mdl', '0'),
('plazaboothstore', '49941', 'Food Court Table', 'Food court table, ripped right off the ground.', '1', '150', 'models/gmod_tower/courttable.mdl', '0'),
('MelonPet', '23326', 'Melon Pet', 'A joyful melon pet!', '8', '15000', 'models/props_junk/watermelon01.mdl', '0'),
('disco_ball', '51163', 'Disco ball', 'Spawns a colorful ball', '7', '4387', 'models/gmod_tower/discoball.mdl', '0'),
('turntab', '14756', 'Turn Table', 'Show everyone that you\'re the best DJ in town!', '7', '525', 'models/props_vtmb/turntable.mdl', '0'),
('mdl_gmen', '27156', 'Gmen', 'Over time, my husband will desire me less sexually, but he will always enjoy my pies.', '13', '5500', 'models/player/gmen.mdl', '0'),
('mdl_ironman', '51741', 'Iron Man', '\"Iron Man.\" That\'s kind of catchy. It\'s got a nice ring to it.', '13', '7500', 'models/player/ironman.mdl', '0'),
('comfchair', '53432', 'Comfy Chair', 'A nice, comfy chair.', '1', '425', 'models/gmod_tower/comfychair.mdl', '0'),
('mdl_faith', '54332', 'Faith', 'Be all like parkour, yo.', '13', '6000', 'models/player/faith.mdl', '0'),
('mdl_libertyprime', '37946', 'Liberty Prime', 'Death is a preferable alternative to communism.', '13', '2000', 'models/player/sam.mdl', '0'),
('oldphone', '27965', 'Old Phone', 'Stuck in the past? Prove it with this ancient phone.', '7', '400', 'models/sunabouzu/old_phone.mdl', '0'),
('painting2', '55232', 'Suite Painting', 'A nice painting to decorate your suite with.', '1', '100', 'models/gmod_tower/suite_art_large.mdl', '0'),
('gmt_bubblegun', '40025', 'Bubble Gun', 'Shoot as many bubbles as you\'d like.', '22', '375', 'models/weapons/w_pistol.mdl', '1'),
('mdl_red', '13550', 'Red', 'Gotta catch them all!', '13', '10000', 'models/player/red.mdl', '0'),
('waterspigot', '8290', 'Water Spigot', 'Forget your kitchen sink, and get your water out of the ground!', '16', '275', 'models/props_farm/water_spigot.mdl', '0'),
('mdl_jacksparrow', '41175', 'Jack Sparrow', 'I got a jar of dirt!', '13', '19500', 'models/player/jack_sparrow.mdl', '0'),
('plush_penguin2', '5149', 'Plushy: Penguin (Blue Tie)', 'A cute fuzzy plush.', '22', '1800', 'models/gmod_tower/plush_penguin.mdl', '0'),
('mdl_altair', '53243', 'Altair', 'Peace be upon you.', '13', '1800', 'models/player/altair.mdl', '0'),
('modernlamp', '372', 'Modern Lamp', 'A nice working lamp to put on your desk.', '7', '500', 'models/gmod_tower/lamp02.mdl', '0'),
('oldtv', '3422', 'Old TV', 'Incase new technology isn\'t your thing.', '7', '250', 'models/props_spytech/tv001.mdl', '0'),
('jerrycan', '27428', 'Jerrycan', 'A jerrycan, useful to store liquids in.', '16', '1250', 'models/props_farm/oilcan01b.mdl', '0'),
('mdl_zexion', '54003', 'Zexion', 'Then I shall make you see... that your hopes are nothing! Nothing but a mere illusion!', '13', '2000', 'models/player/zexion.mdl', '0'),
('woodpile', '29377', 'Wood Pile', 'The leftover wood that stood at the Merchant\'s house. Collected for your placing-pleasure!', '16', '175', 'models/props_forest/woodpile_indoor.mdl', '0'),
('woodcow', '14609', 'Wooden Cow', 'Reminds me of a place, with 2 forts...', '16', '1250', 'models/props_2fort/cow001_reference.mdl', '0'),
('hwtoyspider', '5888', 'Toy Spider', 'Love spiders? So do we!', '19', '800', 'models/gmod_tower/halloween_spidertoy.mdl', '0'),
('plush_penguin4', '5151', 'Plushy: Penguin (Black Tie)', 'A cute fuzzy plush.', '22', '1800', 'models/gmod_tower/plush_penguin.mdl', '0'),
('mdl_hunter', '53631', 'Hunter', 'Be all like L4D, yo. And pounce people.', '13', '5500', 'models/player/hunter.mdl', '0'),
('notesbook', '1368', 'Note Book', 'Take note: This is a notebook.', '6', '25', 'models/sunabouzu/notebook_elev.mdl', '0'),
('mdl_boxman', '53383', 'Boxman', 'Seriously, who drew this bear mouth on my box!?', '13', '10000', 'models/player/nuggets.mdl', '0'),
('cardbox', '12926', 'Cardboard Box', '\'Useful for building forts!\' -Basical', '16', '25', 'models/props_junk/cardboard_box001a.mdl', '0'),
('mdl_jawa', '27155', 'Jawa', 'Utinni!', '13', '7000', 'models/player/jawa.mdl', '0'),
('saturnplush', '6158', 'Mr. Saturn', 'Am happy. Am in trouble. No, wait. Am happy.', '16', '3500', 'models/uch/saturn.mdl', '0'),
('mdl_spy', '13597', 'Spy', 'I never really was on your side.', '13', '20000', 'models/player/drpyspy/spy.mdl', '0'),
('ferns', '3263', 'Ferns', 'Nice ferns for in your garden.', '20', '175', 'models/hessi/palme.mdl', '0'),
('DuelSniper', '36087', 'Duel - Snipers', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '200', 'models/weapons/w_pvp_as50.mdl', '0'),
('streamergun3', '24115', 'Streamers! (10)', 'Shoot streams of color!', '22', '250', 'models/weapons/w_pistol.mdl', '1'),
('basketwood', '48841', 'Wooden Basket', 'A wooden basket. Useful to store fruits in.', '1', '75', 'models/props_swamp/crate_ref.mdl', '0'),
('mdl_robot', '54610', 'Robot', 'Main systems fully online.', '13', '3000', 'models/player/robot.mdl', '0'),
('mdl_rayman', '53679', 'Rayman', 'Utbay... I mean Aymanray!', '13', '9000', 'models/player/rayman.mdl', '0'),
('camera', '6385', 'Camera', 'Take screenshots without the HUD - and with zoom!', '7', '250', 'models/weapons/w_camphone.mdl', '1'),
('DuelFists', '45583', 'Duel - Fists', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '180', 'models/weapons/w_pvp_ire.mdl', '0'),
('mdl_zero', '27303', 'Zero', 'Somehow... I... I did it... But... It... It cost me everything...', '13', '16000', 'models/player/lordvipes/mmz/zero/zero_playermodel_cvp.mdl', '0'),
('ancestors', '52547', 'Voices Of The Ancestors', 'Then put headphones on your heart...', '0', '0', 'models/gmod_tower/headheart.mdl', '0'),
('tseat', '3522', 'Theater Seat', 'A must have for all home theater.', '1', '525', 'models/gmod_tower/theater_seat.mdl', '0'),
('trafficcone', '7857', 'Traffic Cone', 'Block of the streets- or rather, your suite with this traffic cone.', '16', '50', 'models/props/de_vertigo/trafficcone_clean.mdl', '0'),
('tire', '1693', 'Tire', 'For your future car.', '16', '125', 'models/props_2fort/tire001.mdl', '0'),
('bushred', '13574', 'Small Red Bush', 'A red bush to put in your garden.', '20', '150', 'models/gmod_tower/plant/largebush01.mdl', '0'),
('fwork_wine', '723', 'Wine Firework', 'Rocket-based firework that explodes in the shape of a wine glass.', '14', '400', 'models/gmod_tower/firework_rocket.mdl', '0'),
('plazabooth', '1450', 'Food Court Booth', 'The food court booth just for you!', '1', '400', 'models/gmod_tower/plazabooth.mdl', '0'),
('mdl_azuisleet', '39935', 'AzuiSleet', 'I can never be wrong. It\'s a curse I have.', '13', '4500', 'models/player/azuisleet1.mdl', '0'),
('VirusFlame', '44822', 'Virus Flame', 'Ignite yourself with the flame of the infected!', '0', '0', 'models/player/virusi.mdl', '0'),
('mdl_romanbelic', '28442', 'Roman Belic', 'Cousin! Lets go bowling!', '13', '2000', 'models/player/roman.mdl', '0'),
('mdl_arrow', '54429', 'The Arrow', 'My name is Oliver Queen, and you have failed this city!', '13', '15000', 'models/player/greenarrow.mdl', '0'),
('juicecup', '27806', 'Juice Cup', 'A nice cup.', '6', '70', 'models/sunabouzu/juice_cup.mdl', '0'),
('BallRaceBall', '10874', 'Ball Race Orb', 'Step into the ball and get rolling.', '0', '0', 'models/gmod_tower/BALL.mdl', '0'),
('pinkbed', '13966', 'Heart Bed', 'A big, heart shaped pink bed.', '1', '1250', 'models/props_vtmb/heartbed.mdl', '0'),
('woodcrate', '3140', 'Wooden Crate', 'What\'s a Source game without crates?', '16', '75', 'models/props_junk/wood_crate001a.mdl', '0'),
('mdl_scarecrow', '40386', 'Scarecrow', 'Now, they will learn the true nature of fear!', '13', '2500', 'models/player/scarecrow.mdl', '0'),
('neon_tube3', '55360', 'Neon Tube (yellow)', 'A cool neon tube.', '7', '125', 'models/gmod_tower/kartracer/rave/neon_tube.mdl', '0'),
('StealthBox', '43537', 'Stealth Box', 'Sneak around the lobby.', '0', '0', 'models/gmod_tower/stealth box/box.mdl', '0'),
('grain', '3300', 'Grain Sack', 'A sack full of grain.', '20', '500', 'models/props_granary/grain_sack.mdl', '0'),
('treestump', '2497', 'Tree Stump', 'This was once a tree...', '20', '375', 'models/props_foliage/tree_stump01.mdl', '0'),
('mopbucket', '773', 'Mop And Bucket', 'To keep your suite extra clean.', '16', '100', 'models/props_2fort/mop_and_bucket.mdl', '0'),
('painting', '27591', 'Suite Painting', 'A nice painting to decorate your suite with.', '1', '100', 'models/gmod_tower/suite_art_large.mdl', '0'),
('hwgravestone', '3077', 'R.I.P. Tombstone', 'Remember when FPS games didn\'t suck?', '19', '1800', 'models/gmod_tower/halloween_gravestone.mdl', '0'),
('hwcandybucket', '50703', 'Candy Bucket', 'Trick or treat! Oh, it\'s already filled up!', '19', '500', 'models/gmod_tower/halloween_candybucket.mdl', '0'),
('hwhouse', '13943', 'Scary House', 'Boo.', '19', '1600', 'models/gmod_tower/halloween_scaryhouse.mdl', '0'),
('endtable', '26765', 'End Table', 'A small table you can put next to something.', '1', '250', 'models/sunabouzu/end_table.mdl', '0'),
('rbrchrblue', '981', 'Rubber Chair: Blue', 'A blue, rubber chair.', '1', '375', 'models/mirrorsedge/seat_blue1.mdl', '0'),
('mdl_deathstroke', '37377', 'Deathstroke', 'I\'m a goddam killing machine!', '13', '14000', 'models/norpo/arkhamorigins/assassins/deathstroke_valvebiped.mdl', '0'),
('ggnome', '6651', 'Garden Gnome', 'A gnome that the bird made on his own, hence the price!', '20', '1000', 'models/props_junk/gnome.mdl', '0'),
('fireworkgun6', '45043', 'Firework RPG (6)', 'Shoot fireworks!', '22', '900', 'models/weapons/w_rocket_launcher.mdl', '1'),
('blackcurtain', '28681', 'Black Curtains', 'Nice curtains if you\'re not a fan of sunlight.', '1', '275', 'models/sunabouzu/mansion_curtains.mdl', '0'),
('neon_tube4', '55361', 'Neon Tube (green)', 'A cool neon tube.', '7', '125', 'models/gmod_tower/kartracer/rave/neon_tube.mdl', '0'),
('pianostool', '668', 'Piano Stool', 'Sit with this and play your piano with style.', '8', '150', 'models/fishy/furniture/piano_seat.mdl', '0'),
('JumpShoes', '47913', 'Jump Shoes', 'Jump up way high with these special shoes! (crouch jumping makes you go even higher)', '22', '10000', 'models/props_junk/shoe001a.mdl', '0'),
('ttttable', '29581', 'TicTacToe Table', 'Play TicTacToe in your suite.', '22', '2000', 'models/gmod_tower/gametable.mdl', '0'),
('DuelXM8', '11266', 'Duel - XM8', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '250', 'models/weapons/w_pvp_xm8.mdl', '0'),
('DuelM1Garand', '27574', 'Duel - M1 Garand', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '200', 'models/weapons/w_pvp_m1.mdl', '0'),
('reclining', '154', 'Reclining Chair', 'A cool, futuristic chair.', '1', '525', 'models/haxxer/me2_props/reclining_chair.mdl', '0'),
('shotglass', '1760', 'Shot Glass', 'Take a virtual shot.', '6', '100', 'models/sunabouzu/shot_glass.mdl', '0'),
('mdl_alice', '54303', 'Alice', 'My Wonderland is shattered. It\'s dead to me.', '13', '12000', 'models/player/alice.mdl', '0'),
('toybumper', '3239', 'Toy Bumper', 'Great for any Hula Doll Ballrace contest!', '22', '350', 'models/gmod_tower/bumper.mdl', '0'),
('toytrain', '29556', 'Toy Train', 'Choo Choo!', '22', '6000', 'models/minitrains/loco/swloco007.mdl', '0'),
('mdl_subzero', '52368', 'Subzero', 'I\'ve got a score to settle.', '13', '12000', 'models/player/subzero.mdl', '0'),
('streamergun1', '24113', 'Streamers! (3)', 'Shoot streams of color!', '22', '100', 'models/weapons/w_pistol.mdl', '1'),
('neon_tube1', '55358', 'Neon Tube (pink)', 'A cool neon tube.', '7', '125', 'models/gmod_tower/kartracer/rave/neon_tube.mdl', '0'),
('Con5x50x100_doorway2', '5049', '5x50x100_doorway', 'Concrete', '11', '310', 'models/NightReaper/Concrete/5x50x100_doorway.mdl', '0'),
('mdl_doomguy', '51344', 'Doom Guy', '...', '13', '10000', 'models/kryptonite/doomguy/doomguy_pm.mdl', '0'),
('plush_penguin', '30332', 'Plushy: Penguin (Red Tie)', 'A cute fuzzy plush.', '22', '1800', 'models/gmod_tower/plush_penguin.mdl', '0'),
('redvalve', '27945', 'Red Valve', 'You may not buy 3 valves.', '16', '50', 'models/props_mining/crank02.mdl', '0'),
('weathervane', '6401', 'Weather Vane', 'Tell where the north is, that is, if you place it right.', '16', '500', 'models/props_2fort/weathervane001.mdl', '0'),
('handscan', '26516', 'Hand Scanner', 'An extra security measure for your holy bathroom.', '7', '525', 'models/maxofs2d/button_04.mdl', '0'),
('lavenderbush', '49047', 'Lavender Bush', 'A nice lavender bush. Will surely make your suite smell great!', '20', '200', 'models/props/de_inferno/largebush03.mdl', '0'),
('weapon_akimibo', '50255', 'Akimibo', 'Akimibo', '0', '0', 'models/weapons/w_pvp_ire.mdl', '1'),
('btoilet', '13478', 'Toilet', 'A toilet with comfort in mind.', '21', '75', 'models/props_interiors/toilet.mdl', '0'),
('neon_tube2', '55359', 'Neon Tube (cyan)', 'A cool neon tube.', '7', '125', 'models/gmod_tower/kartracer/rave/neon_tube.mdl', '0'),
('lobbychair', '54987', 'Lobby Chair', 'A modern, comfy chair.', '1', '300', 'models/sunabouzu/lobby_chair.mdl', '0'),
('BcornPet', '21934', 'Balloonicorn Pet', 'Oh my goodness! Is it Balloonicorn? The Mayor of Pyroland? Don\'t be ridiculous, we\'re talking about an inflatable unicorn. He\'s the Municipal Ombudsman.', '8', '22000', 'models/player/items/all_class/pet_balloonicorn.mdl', '0'),
('fwork_spinner', '6500', 'Spinner Firework', 'Spins and jumps all around while emitting colorful sparks.', '14', '150', 'models/gmod_tower/firework_spinner.mdl', '0'),
('fwork_ring', '685', 'Ring Firework', 'Rocket-based firework that explodes in a ring-like pattern.', '14', '130', 'models/gmod_tower/firework_rocket.mdl', '0'),
('mdl_rorschach', '42687', 'Rorschach', 'None of you seem to understand. I\'m not locked in here with you. You\'re locked in here with me!', '13', '8000', 'models/player/rorschach.mdl', '0'),
('glowdonut', '54894', 'Glowing Donut', 'A big glowing, RGB donut. Perfect for rave parties.', '7', '5000', 'models/gmod_tower/kartracer/rave/glowing_donut.mdl', '0'),
('mdl_stormtrooper', '17086', 'Stormtrooper', 'Aren\'t you a little short for a Stormtrooper?', '13', '11000', 'models/player/stormtrooper.mdl', '0'),
('ppiece', '6983', 'Puzzle Piece', 'One puzzle piece. Looks like this Puzzle is Impossible.', '6', '75', 'models/gmod_tower/puzzlepiece1.mdl', '0'),
('modelrocket', '638', 'Model Rocket', 'One small rocket for men, one giant gap for wallet-kind.', '16', '2250', 'models/props_spytech/rocket002_skybox.mdl', '0'),
('mdl_bigboss', '50830', 'Big Boss', 'Do you think love can bloom even on a battlefield?', '13', '15000', 'models/player/big_boss.mdl', '0'),
('kitchtable', '54976', 'Kitchen Table', 'A modern kitchen table.', '1', '750', 'models/gmod_tower/kitchentable.mdl', '0'),
('gmt_moneygun', '49329', 'Money Gun', 'Dosh, grab it while it\'s hot!', '0', '0', 'models/weapons/w_pvp_ire.mdl', '1'),
('GhostPet', '22958', 'Ghost Pet', 'A spooky ghost, next to your side.', '19', '25000', 'models/player/items/all_class/hwn_pet_ghost.mdl', '0'),
('mdl_chrisredfield', '53638', 'Chris Redfield', 'There are only three S.T.A.R.S. members left now.', '13', '3000', 'models/player/chris.mdl', '0'),
('Duel357', '11069', 'Duel - .357', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '200', 'models/weapons/w_357.mdl', '0'),
('streamergun2', '24114', 'Streamers! (6)', 'Shoot streams of color!', '22', '175', 'models/weapons/w_pistol.mdl', '1'),
('mdl_dinosaur', '46861', 'Dinosaur', 'Go on, rip it up, you extinct shakey-saurus thing you!', '13', '2500', 'models/player/foohysaurusrex.mdl', '0'),
('mdl_harrypotter', '44470', 'Harry Potter', 'I\'m sorry, professor... But I must not tell lies!', '13', '15000', 'models/player/harry_potter.mdl', '0'),
('mdl_sunabouzu', '43058', 'Sunabouzu', 'Finally some recognition for - wait.', '13', '4000', 'models/player/Sunabouzu.mdl', '0'),
('toytrainsmall', '4611', 'Toy Train Small', 'Choo Choo (but small)', '22', '5000', 'models/minitrains/loco/swloco007.mdl', '0'),
('mdl_spacesuit', '41695', 'Space suit', 'Keep a person alive and comfortable in the harsh environment of outer space.', '13', '950', 'models/player/spacesuit.mdl', '0'),
('wcooler', '14324', 'Water Cooler', 'Keep your guests hydrated with this nice water cooler.', '7', '750', 'models/props_spytech/watercooler.mdl', '0'),
('DuelRagingBull', '18630', 'Duel - Raging Bull', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '250', 'models/weapons/w_pvp_ragingb.mdl', '0'),
('rabbitskin³', '53332', 'Pyro Rabbit', 'Skin by CrimsonFloyd.', '9', '1400', 'models/player/redrabbit3.mdl', '0'),
('plush_penguin3', '5150', 'Plushy: Penguin (Whacky Orange Tie)', 'A cute fuzzy plush.', '22', '1800', 'models/gmod_tower/plush_penguin.mdl', '0'),
('mdl_carley', '53158', 'Carley', '...', '13', '15000', 'models/nikout/carleypm.mdl', '0'),
('mdl_joker', '54496', 'Joker', 'Do you want to know why I use a knife? Guns are too quick. You can\'t savor all the... little emotions.', '13', '7750', 'models/player/joker.mdl', '0'),
('mdl_mario', '54465', 'Mario', 'Ya-hoo!', '13', '15000', 'models/player/sumario_galaxy.mdl', '0'),
('DuelAkimbo', '35442', 'Duel - Akimbos', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '180', 'models/weapons/w_pvp_akimbo.mdl', '0'),
('plush_penguin5', '5152', 'Plushy: Penguin (Pink Tie)', 'A cute fuzzy plush.', '22', '1800', 'models/gmod_tower/plush_penguin.mdl', '0'),
('turkeydish', '7400', 'Turkey Dinner', 'Turkey dinner has never been more pixelated before.', '18', '1000', 'models/gmod_tower/turkey.mdl', '0'),
('mdl_smith', '54636', 'Agent Smith', 'Mr. Anderson! Surprised to see me?', '13', '3000', 'models/player/smith.mdl', '0'),
('portaltoy', '2058', 'Portal Papertoy', 'Portal, paper edition!', '22', '1000', 'models/gmod_tower/portaltoy.mdl', '0'),
('mdl_postaldude', '29166', 'Postal Dude', 'Hi there. Would you like to sign my petition?', '13', '3000', 'models/player/dude.mdl', '0'),
('mdl_masseffect', '23979', 'Mass Effect Dude', 'Why is it whenever someone says \'with all due respect\', they really mean \'kiss my ass\'?', '13', '8000', 'models/player/masseffect.mdl', '0'),
('mdl_jillvalentine', '23494', 'Jill Valentine', 'You were almost a Jill sandwich!', '13', '3250', 'models/player/jill.mdl', '0'),
('fwork_palm', '639', 'Palm Firework', 'Rocket-based firework that explodes in the shape of a palm tree.', '14', '350', 'models/gmod_tower/firework_rocket.mdl', '0'),
('fwork_firefly', '5505', 'Fireflies', 'Shoots colorful lights in a random upward pattern which twinkle like fireflies.', '14', '150', 'models/gmod_tower/firework_fountain.mdl', '0'),
('mdl_knight', '53531', 'Knight', 'Praise the sun!', '13', '19000', 'models/player/knight.mdl', '0'),
('mdl_raz', '13564', 'Raz', 'I\'m glad you took that ass-kicking I handed to you and turned it into something nice... like gardening.', '13', '8000', 'models/player/masseffect.mdl', '0'),
('nbottle', '13789', 'Noir Bottle', 'A nice bottle.', '6', '200', 'models/sunabouzu/noir_bottle.mdl', '0'),
('illusive', '27613', 'Illusive Chair', 'A cool, futuristic chair.', '1', '500', 'models/haxxer/me2_props/illusive_chair.mdl', '0'),
('DuelSword', '45868', 'Duel - Swords', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '180', 'models/weapons/w_pvp_swd.mdl', '0'),
('SkinScroller', '609', 'Skin Scroller', 'See all colors of the rabbit!', '0', '0', '', '0'),
('rbrchrwhite', '2349', 'Rubber Chair: White', 'A white, rubber chair.', '1', '375', 'models/mirrorsedge/seat_blue2.mdl', '0'),
('plush_fox4', '3622', 'Plushy: Pink Fox', 'A cute fuzzy plush.', '22', '1500', 'models/gmod_tower/plush_fox.mdl', '0'),
('neon_tube5', '55362', 'Neon Tube (orange)', 'A cool neon tube.', '7', '125', 'models/gmod_tower/kartracer/rave/neon_tube.mdl', '0'),
('rabbitskin´', '53333', 'Robot Rabbit', 'Use it to become it.', '0', '0', 'models/player/redrabbit3.mdl', '0'),
('toysmokemachine', '17345', 'Fog Machine', 'Fog up your place with this smoke machine.', '19', '3000', 'models/gmod_tower/halloween_fogmachine.mdl', '0'),
('mdl_nikobelic', '40330', 'Niko Belic', 'Welcome to America.', '13', '2000', 'models/player/niko.mdl', '0'),
('thermos', '14181', 'Thermos', 'Keep drinks nice and warm.', '6', '75', 'models/props_2fort/thermos.mdl', '0'),
('mdl_robber', '53687', 'Robber', 'Rob the bank and then some.', '13', '1500', 'models/player/robber.mdl', '0'),
('ParticleSystemVIP', '47763', 'Particle: Beauty Cone', 'Shiny.', '23', '30000', 'models/weapons/w_pvp_ire.mdl', '0'),
('pilepaper', '535', 'Pile Of Papers', 'Think your suite is too clean? Think again!', '6', '150', 'models/sunabouzu/paper_stack.mdl', '0'),
('mdl_luigi', '54563', 'Luigi', 'It\'s-a Luigi time!', '13', '14999', 'models/player/suluigi_galaxy.mdl', '0'),
('DuelChainsaw', '30807', 'Duel - Chainsaws', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '200', 'models/weapons/w_pvp_chainsaw.mdl', '0'),
('DuelSMG', '11261', 'Duel - Sub-Machine Guns', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '150', 'models/weapons/w_smg1.mdl', '0'),
('DuelRPG', '11263', 'Duel - Rockets', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '250', 'models/weapons/w_rocket_launcher.mdl', '0'),
('rubikscube', '4299', 'Huge Rubik\'s Cube', 'Play with your cubes, Rubik.', '22', '800', 'models/gmod_tower/rubikscube.mdl', '0'),
('haybale', '13313', 'Hay Bale', 'A special hay bale that you can\'t buy!', '0', '0', 'models/props_gameplay/haybale.mdl', '0'),
('rockpile', '28465', 'Rock Pile', 'A pile of rocks, nice to decorate your garden with.', '20', '175', 'models/props_nature/rock_worn_cluster002.mdl', '0'),
('goldingot', '54510', 'Pure Gold Ingot', 'The finest gold around. Show off your juicy GMC with this ingot.', '16', '100000', 'models/props_mining/ingot001.mdl', '0'),
('bigrock', '13069', 'Big Rock', 'A big rock to place in your garden.', '20', '250', 'models/props_nature/rock_worn001.mdl', '0'),
('neon_tube6', '55363', 'Neon Tube (purple)', 'A cool neon tube.', '7', '125', 'models/gmod_tower/kartracer/rave/neon_tube.mdl', '0'),
('fallentree', '49930', 'Fallen Tree Trunk', 'A fallen over tree trunk.', '20', '750', 'models/props_foliage/fallentree01.mdl', '0'),
('hydrabush', '245', 'Big Hydrangea Bush', 'A big hydrangea bush.', '20', '375', 'models/props/de_inferno/largebush05.mdl', '0'),
('wildbush', '28850', 'Wild Bush', 'Collected from Narnia, this wild bush will sure make your garden look interesting.', '20', '175', 'models/props/de_inferno/largebush02.mdl', '0'),
('bushbig', '13521', 'Big Bush', 'A bigger version of that other bush, for even better gardens.', '20', '350', 'models/garden/gardenbush.mdl', '0'),
('mdl_megaman', '51349', 'Mega Man', 'What if I become a maverick?', '13', '9000', 'models/vinrax/player/megaman64_no_gun_player.mdl', '0'),
('compcube', '26869', 'Weighted Companion Cube', 'The Enrichment Center reminds you that the Weighted Companion Cube will never threaten to stab you and, in fact, cannot speak.', '6', '125', 'models/props/metal_box.mdl', '0'),
('bushsmall', '54688', 'Small Bush', 'A small bush to decorate your garden with, or home!', '20', '250', 'models/garden/gardenbush2.mdl', '0'),
('desklamp', '26494', 'Desk Lamp', 'Perfect for reading a book, or for interrogating a suspect.', '7', '600', 'models/gmod_tower/lamp01.mdl', '0'),
('bigspeaker', '49779', 'Big Speaker', 'Increase the effectiveness of your sound system tenfold.', '7', '1000', 'models/sunabouzu/speaker.mdl', '0'),
('typewriter', '8314', 'Typewriter', 'The incessant clacking is enough to drive any man insane. That\'s why I became a private eye.', '7', '1500', 'models/sunabouzu/typewriter.mdl', '0'),
('fwork_fountain', '11780', 'Fountain Firework', 'Emits a fountain of wonderous colored sparks.', '14', '125', 'models/gmod_tower/firework_fountain.mdl', '0'),
('lightcube', '54933', 'Light Cube', 'Decorate your suite with some shiny ambient lighting, totally not from Rave.', '7', '2500', 'models/gmod_tower/kartracer/rave/light_cube.mdl', '0'),
('hwtraincart', '4352', 'Toy Train Cart', 'A toy cart from the Haunted Mansion ride.', '19', '3000', 'models/gmod_tower/halloween_minitraincar.mdl', '0'),
('mdl_assassin', '47097', 'Assassin', 'We all start with innocence, but world leads us to quit.', '13', '15000', 'models/player/dishonored_assassin1.mdl', '0'),
('DuelShotgun', '16669', 'Duel - Shotguns', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '180', 'models/weapons/w_shotspas12z.mdl', '0'),
('gmt_lantern', '51935', 'Lantern', 'A lightup spooky lantern to decorate your place with.', '19', '1000', 'models/gmod_tower/halloween_lantern.mdl', '0'),
('mshelf', '6946', 'Metal Shelf', 'A metal shelf to store stuff in.', '1', '225', 'models/sunabouzu/metal_shelf.mdl', '0'),
('ReinPet', '11806', 'Reindeer Pet', 'No, this is not a Balloonicorn. We promise!', '10', '22000', 'models/player/items/all_class/pet_reinballoonicorn.mdl', '0'),
('fwork_rocket', '3082', 'Rocket Firework', 'Rocket-based firework that explodes from the center.', '14', '50', 'models/gmod_tower/firework_groundrocket.mdl', '0'),
('toyboat', '14578', 'Toy Boat', 'The perfect toy for fellow boat enthousiasts.', '6', '125', 'models/gmod_tower/rcboat.mdl', '0'),
('fwork_ufo', '298', 'UFO Firework', 'Spins and travels around like a small UFO would.', '14', '60', 'models/gmod_tower/firework_ufo.mdl', '0'),
('magicscroll', '49721', 'Magical Scroll', 'An acient scroll... We\'re not quite sure what it could be for.', '16', '10000', 'models/props_medieval/medieval_scroll.mdl', '0'),
('mdl_gentleman', '38537', 'Classy Gentleman', 'Elegant, classy, modern... I\'m the entire package.', '13', '25000', 'models/player/macdguy.mdl', '0'),
('fwork_multi', '1509', 'Multi Firework', 'Rocket-based firework that explodes with two shades of colors.', '14', '80', 'models/gmod_tower/firework_rocket.mdl', '0'),
('mdl_chewbacca', '37176', 'Chewbacca', 'Let the Wookiee win.', '13', '20000', 'models/player/chewbacca.mdl', '0'),
('workingclock', '29685', 'Clock', 'Collectable GMT working clock.', '7', '650', 'models/gmod_tower/clock.mdl', '0'),
('ParticleSystemBanana', '49403', 'Particle: Bananas', 'Express your love for bananas with this cool particle effect!', '23', '10000', 'models/weapons/w_pvp_ire.mdl', '0'),
('comfbed', '13270', 'Comfy Bed', 'A nice, comfy bed.', '1', '750', 'models/gmod_tower/comfybed.mdl', '0'),
('banana_bed', '47281', 'Banana Bed', '\'Sleepin\' in dat Vitamin B6\' -Basical 2018 [LIMITED ITEM]', '0', '0', 'models/props/banana_bed.mdl', '0'),
('mdl_deadpool', '46027', 'Deadpool', 'BANG-BANG BANG BANG BANG!', '13', '14000', 'models/player/deadpool.mdl', '0'),
('DuelCrossbow', '32055', 'Duel - Crossbow', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '200', 'models/weapons/w_crossbow.mdl', '0'),
('mdl_gordon', '53487', 'Gordon Freeman', 'Gordon Freeman, in the flesh - or, rather, in the hazard suit.', '13', '5000', 'models/player/gordon.mdl', '0'),
('hwmincauldron', '8324', 'Mini Cauldron', 'A decorative mini cauldron.', '19', '1000', 'models/gmod_tower/halloween_minicauldron.mdl', '0'),
('weapon_getoverhere', '34855', 'GET OVER HERE!', 'FATALITY!', '0', '0', 'models/weapons/w_pvp_ire.mdl', '1'),
('whitebench', '4660', 'White Bench', 'A nice modern bench.', '1', '400', 'models/mirrorsedge/bench_wooden.mdl', '0'),
('painting3', '55233', 'Suite Painting', 'A nice painting to decorate your suite with.', '1', '100', 'models/gmod_tower/suite_art_large.mdl', '0'),
('lsaber', '6844', 'Toy Light Saber', 'Use the force, Luke.', '22', '5000', 'models/gmod_tower/toy_lightsaber.mdl', '0'),
('mpillar', '13972', 'Big Pillar', 'Perfect for making constructions with.', '1', '500', 'models/sunabouzu/mansion_pillar.mdl', '0'),
('gmt_puker', '54768', 'Puker', 'For the sick admins.', '0', '0', '', '1'),
('ballarrow', '51645', 'Red Arrow', 'An red arrow from Ballrace, useful to point at stuff.', '16', '500', 'models/gmod_tower/arrow.mdl', '0'),
('rosebush', '28834', 'Rose Bush', 'Nice red roses packed in a bush.', '20', '210', 'models/props/de_inferno/largebush04.mdl', '0'),
('piano', '3383', 'Piano', 'Become your own personal Beethoven.', '8', '8000', 'models/sims/piano.mdl', '0'),
('mdl_windranger', '29957', 'Wind Ranger', 'Taste my arrow!', '13', '10000', 'models/heroes/windranger/windranger.mdl', '0'),
('TakeOnBall', '38987', 'Take On Me', 'Increase your speed and become \'80s pop!', '0', '0', 'models/gmod_tower/takeonball.mdl', '0'),
('mdl_zerosuitsamus', '35005', 'Zero Suit Samus', 'The last Metroid is in capavity. The galaxy is at peace.', '13', '14000', 'models/player/samusz.mdl', '0'),
('mdl_midna', '54469', 'Midna', 'Aww, but it was so nic here in the twilight... What\'s so great about a world of light, anyway?', '13', '18000', 'models/player/midna.mdl', '0'),
('fireworkgun3', '45040', 'Firework RPG (3)', 'Shoot fireworks!', '22', '600', 'models/weapons/w_rocket_launcher.mdl', '1'),
('fwork_blossom', '5455', 'Blossom Firework', 'Rocket-based firework that explodes like a blossoming flower.', '14', '100', 'models/gmod_tower/firework_groundrocket.mdl', '0'),
('RubikPet', '24550', 'Rubik Pet', 'Solve me...', '8', '12000', 'models/gmod_tower/rubikscube.mdl', '0'),
('DuelNES', '11237', 'Duel - NES Zapper', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '250', 'models/weapons/w_pvp_neslg.mdl', '0'),
('fwork_spinrocket', '52914', 'Spinning Rocket Firework', 'Rocket-based firework that lifts off while spinning and explodes in multiple colors.', '14', '90', 'models/gmod_tower/firework_groundrocket.mdl', '0'),
('mdl_marty', '54497', 'Marty McFly', 'Are you telling me that you built a time machine... out of a DeLorean?', '13', '19850', 'models/player/martymcfly.mdl', '0'),
('mdl_freddy', '53388', 'Freddy Kruger', '1,2 Freddy is coming for you.', '13', '16000', 'models/player/freddykruger.mdl', '0'),
('mdl_leonkennedy', '47967', 'Leon Kennedy', 'Small world, eh? Well, I see that the President\'s equipped his daughter with... ballistics too.', '13', '5500', 'models/player/leon.mdl', '0'),
('mdl_jackskellington', '46181', 'Jack Skellington', 'I\'m a master of fright, and a demon of light.', '13', '12000', 'models/vinrax/player/jack_player.mdl', '0'),
('mdl_tron', '27300', 'Tron Anon', 'The only way to win the game is not to play.', '13', '11000', 'models/player/anon/anon.mdl', '0'),
('mdl_zoey', '27327', 'Zoey', 'Be all like L4D, yo.', '13', '2000', 'models/player/zoey.mdl', '0'),
('mdl_blockdude', '37678', 'Mine Blockdude', 'Minecraft, I\'m talkin \'bout Minecraft...', '13', '17000', 'models/player/blockdude.mdl', '0'),
('mdl_link', '27195', 'Link', 'Hyaaaa!', '13', '15000', 'models/player/linktp.mdl', '0'),
('mdl_scorpion', '48469', 'Scorpion', 'Get over here!', '13', '13000', 'models/player/scorpion.mdl', '0'),
('mdl_christie', '46740', 'Christie', 'The DOA experience for you.', '13', '2000', 'models/player/christie.mdl', '0'),
('mdl_shaun', '54572', 'Shaun', 'You\'ve got red on you.', '13', '16000', 'models/player/shaun.mdl', '0'),
('simsbedpink', '6679', 'Pink Bed', 'Unveil the princess inside you.', '1', '775', 'models/sims/gm_pinkbed.mdl', '0'),
('Bumper', '5684', 'Bumper', 'Place a bumper from Ball Race anywhere you\'d like.', '0', '0', 'models/gmod_tower/bumper.mdl', '0'),
('svase', '3535', 'Skull Vase', 'A special vase found in a secret castle in Narnia.', '1', '1000', 'models/props_manor/vase_01.mdl', '0'),
('lbookshelf', '53973', 'Tall Bookcase', 'Show off you precious items in this tall bookcase.', '1', '375', 'models/sims/gm_bookcase.mdl', '0'),
('tcrack', '6965', 'Time Card Rack', 'Keep track of who shows up late every day.', '1', '175', 'models/props_spytech/time_card_rack.mdl', '0'),
('oldpcmonitor', '3968', 'Old Computer Monitor', 'What cable does this use again?', '7', '145', 'models/props_lab/monitor01a.mdl', '0'),
('plush_fox5a', '7343', 'Plushy: Orange Fox', 'A cute fuzzy plush.', '22', '1500', 'models/gmod_tower/plush_fox.mdl', '0'),
('plush_fox3', '3621', 'Plushy: Grey Fox', 'A cute fuzzy plush.', '22', '1500', 'models/gmod_tower/plush_fox.mdl', '0'),
('RobotPet', '24334', 'Robot Pet', 'Your personal robot assistant!', '8', '75000', 'models/player/items/all_class/pet_robro.mdl', '0'),
('plush_fox2', '3620', 'Plushy: Blue Fox', 'A cute fuzzy plush.', '22', '1500', 'models/gmod_tower/plush_fox.mdl', '0'),
('mdl_aphaztech', '37727', 'Aperture Haztech', 'Please assume the party escort submission position.', '13', '2500', 'models/player/aphaztech.mdl', '0'),
('DuelMain', '22732', 'Duel - Magnums', 'Duel a single player on the server for GMC or for fun. One time use.', '24', '150', 'models/weapons/w_357.mdl', '0'),
('mdl_crimson', '51305', 'Crimson Lance', 'I work for the Atlas corporation.', '13', '14000', 'models/player/lordvipes/bl_clance/crimsonlanceplayer.mdl', '0'),
('mdl_isaac', '54449', 'Isaac Clarke', 'Stick around. I\'m full of bad ideas', '13', '20000', 'models/wolfkann/isaac_clarke.mdl', '0'),
('deertrophy', '49940', 'Deer Trophy', 'You accidentally shot this deer at Narnia, better make good use of it!', '16', '350', 'models/props_swamp/trophy_deer.mdl', '0'),
('mdl_laracroft', '38937', 'Lara Croft', 'I woke up this morning and I just hated everything.', '13', '3000', 'models/player/lara.mdl', '0');

-- --------------------------------------------------------

--
-- Table structure for table `gm_jeopardy`
--

CREATE TABLE `gm_jeopardy` (
  `id` int(11) NOT NULL,
  `question` text NOT NULL,
  `level` smallint(5) UNSIGNED NOT NULL,
  `cat` varchar(32) NOT NULL,
  `ans1` varchar(25) NOT NULL,
  `ans2` varchar(25) NOT NULL,
  `ans3` varchar(25) NOT NULL,
  `ans4` varchar(25) NOT NULL,
  `count1` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `count2` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `count3` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `count4` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `LastUse` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `AddedBy` int(11) NOT NULL,
  `EditedBy` int(11) NOT NULL,
  `enabled` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `gm_jeopardy`
--

INSERT INTO `gm_jeopardy` (`id`, `question`, `level`, `cat`, `ans1`, `ans2`, `ans3`, `ans4`, `count1`, `count2`, `count3`, `count4`, `LastUse`, `AddedBy`, `EditedBy`, `enabled`) VALUES
(1, 'How many wives did Henry VIII have?', 1, 'History', '6', '9', '7', '3', 21, 20, 19, 10, 1502841550, 0, 0, 0),
(2, 'Who was the villain of The Lion King?', 1, 'Films', 'Scar', 'Fred', 'Jafar', 'Vada', 45, 6, 12, 8, 1627446113, 0, 949104, 0),
(3, 'Which bird is the odd one out:', 1, 'Odd One Out', 'Crow', 'Eagle', 'Vulture', 'Falcon', 42, 13, 21, 9, 1501915471, 0, 0, 0),
(4, 'Which language is the odd one out:', 1, 'Odd One Out', 'Chinese', 'English', 'French', 'Spanish', 50, 21, 4, 4, 1502849180, 0, 0, 0),
(5, 'The invasion of which country led to the outbreak of World War II', 1, 'History', 'Poland', 'Austria', 'France', 'England', 41, 13, 15, 9, 1502841859, 0, 0, 0),
(6, 'Cleopatra ruled which country?', 1, 'History', 'Egypt', 'Italy', 'Turkey', 'Sudan', 34, 6, 7, 7, 1502592931, 0, 0, 0),
(9, 'Who was American president at the start of World War II:', 1, 'History', 'Roosevelt', 'Truman', 'Jefferson', 'John Kennedy', 34, 9, 16, 14, 1502875128, 0, 0, 0),
(10, 'Where did the Incas originate', 1, 'History', 'Peru', 'China', 'Brazil', 'Chile', 34, 14, 14, 25, 1503012982, 0, 0, 0),
(11, 'When was the American Declaration of Independence', 1, 'History', '1776', '1800', '1865', '1732', 46, 9, 22, 12, 1502875365, 0, 0, 0),
(12, 'In which country did the Industrial Revolution start?', 1, 'History', 'England', 'France', 'Spain', 'Germany', 41, 13, 9, 19, 1502835012, 0, 0, 0),
(13, 'During which war was the tank first used?', 1, 'History', 'World War I', 'World War II', 'Vietnam War', 'The Cold War', 35, 11, 6, 8, 1502875192, 0, 0, 0),
(14, 'Who owned a sword called Excalibur?', 1, 'Literature', 'King Arthur', 'King Ethelbald', 'King Harold', 'King William', 52, 4, 2, 5, 1502875063, 0, 0, 0),
(15, 'How many grams are there in a kilogram?', 1, 'Pot Luck', '1000', '1024', '720', '100', 35, 8, 1, 14, 1502879422, 0, 0, 0),
(16, 'What is titanium?', 1, 'Pot Luck', 'Mineral', 'Vegetable', 'Animal', 'Plant', 54, 5, 1, 2, 1565869493, 0, 0, 0),
(17, 'Which planet is so large it could contain all the others.', 1, 'Astronomy', 'Jupiter', 'Saturn', 'Uranus', 'Mercury', 41, 18, 17, 8, 1501915511, 0, 0, 0),
(18, 'Which country did Ivan the Terrible rule?', 1, 'History', 'Russia', 'England', 'France', 'Poland', 41, 11, 17, 19, 1503013014, 0, 0, 0),
(19, 'To which domestic animal is the tiger related?', 1, 'Pot Luck', 'Cat', 'Dog', 'Panthera', 'Lion', 47, 3, 8, 13, 1502879385, 0, 0, 0),
(20, 'From what is paper traditionally made?', 1, 'Pot Luck', 'Wood', 'Sand', 'Nitrocellulose', 'Lithium', 46, 8, 8, 7, 1502875347, 0, 0, 0),
(21, 'What is Big Ben?', 1, 'The World', 'A clock', 'An explosion', 'A character', 'A book', 45, 8, 9, 5, 1502593073, 0, 0, 0),
(22, 'What is a wat?', 1, 'Pot Luck', 'A Temple', 'Energy', 'Wide Angle Trail', 'A gas', 20, 35, 13, 7, 1502841602, 0, 0, 0),
(23, 'Who used the code name 007?', 1, 'Pot Luck', 'James Bond', 'Andrew Bond', 'Julia Bound', 'James Bound', 56, 2, 0, 16, 1502841453, 0, 0, 0),
(24, 'Which fruit is the odd one out?', 1, 'Odd One Out', 'Fig', 'Currant', 'Raisin', 'Sultana', 25, 15, 23, 17, 1502879405, 0, 0, 0),
(25, 'Which animal is the one one out?', 1, 'Odd One Out', 'Salamander', 'Crab', 'Lobster', 'Shrimp', 44, 10, 8, 7, 1503020971, 0, 0, 0),
(26, 'George H. Bush is of what political party?', 1, 'Politics', 'Republican', 'Democrat', 'Green', 'Other', 46, 33, 2, 5, 1565869511, 0, 0, 0),
(27, 'Which musical instrument is the odd one out', 1, 'Odd One Out', 'Trumpet', 'Oboe', 'Clarinet', 'Flute', 26, 26, 4, 7, 1503013029, 0, 0, 0),
(28, 'Which is the odd number out?', 1, 'Odd One Out', '8', '11', '9', '15', 30, 15, 8, 5, 1565869458, 0, 0, 0),
(7, 'Which drink is the odd one out?', 1, 'Odd One Out', 'Milk', 'Tea', 'Coffe', 'Cocoa', 38, 17, 11, 17, 1503020913, 0, 0, 0),
(8, 'What is coal?', 1, 'Pot Luck', 'Fossil fuel', 'Element', 'Paper', 'A Star', 71, 14, 0, 6, 1627446083, 0, 0, 0),
(29, 'What is the highest number that has a name?', 1, 'Pot Luck', 'Googelplex', 'Googel', 'Trillion', 'Yotta', 41, 13, 18, 11, 1565869472, 0, 0, 0),
(30, 'Where did the Norse warriors hope to go when they died?', 1, 'Pot Luck', 'Valhalla', 'Heaven', 'Ragnarok', 'Mount Olympus', 40, 14, 12, 18, 1502904782, 0, 0, 0),
(31, 'How many are there in a score?', 1, 'Pot Luck', '20', '50', '100', '15', 36, 11, 22, 15, 1503020928, 0, 0, 0),
(32, 'Which of these snakes is not venomous?', 1, 'Pot Luck', 'boa constrictor', 'rattlesnake', 'viper', 'copperhead', 35, 12, 7, 13, 1565869444, 0, 0, 0),
(33, 'Brittany is part of which country?', 1, 'Pot Luck', 'France', 'Canada', 'Italy', 'Germany', 36, 21, 24, 15, 1502875301, 0, 0, 0),
(34, 'What is the name given to the Earth\'s hard outer shell?', 1, 'The Earth', 'Crust', 'Core', 'Mantle', 'Lithosphere', 30, 12, 7, 8, 1565869411, 0, 0, 0),
(35, 'Is the Earth a perfect sphere?', 1, 'The Earth', 'False', 'True', '', '', 41, 19, 0, 0, 1501907527, 0, 0, 0),
(36, 'What is the name of the continent which contains the South Pole? ', 1, 'The Earth', 'Antarctica', 'Australia', 'Africa', 'Meridian', 44, 5, 5, 7, 1627446145, 0, 0, 0),
(37, 'In which way does a stalagmite grow?', 1, 'The Earth', 'Up', 'Down', 'Right', 'Left', 36, 26, 9, 7, 1502904689, 0, 0, 0),
(38, 'What is the commonest gas in the atmosphere?', 1, 'The Earth', 'Nitogren', 'Oxygen', 'Hydrogen', 'Neon', 37, 22, 32, 6, 1501911090, 0, 0, 0),
(39, 'What is `natural gas` mainly made of?', 1, 'The Earth', 'Methane', 'Hydrocarbon', 'Nitrogen', 'Florine', 36, 17, 32, 6, 1565866515, 0, 0, 0),
(40, 'What color are emeralds?', 1, 'The Earth', 'Green', 'Yellow', 'Red', 'Blue', 37, 3, 4, 4, 1501907446, 0, 0, 0),
(41, 'Which of the following is not a gambling game?', 1, 'Pot Luck', 'Patience', 'Dice', 'Poker', 'Roulette', 52, 10, 6, 3, 1503012934, 0, 0, 0),
(42, 'John Constable was:', 1, 'Pot Luck', 'A painter', 'A doctor', 'An explorer', 'A President', 31, 17, 25, 9, 1503013109, 0, 0, 0),
(43, 'Carmen is:', 1, 'Pot Luck', 'An Opera', 'A Car', 'A game', 'A President', 41, 8, 15, 13, 1502709383, 0, 0, 0),
(44, 'In which country would you not drive on the left:', 1, 'Pot Luck', 'Sweden', 'UK', 'Thailand', 'Japan', 29, 26, 13, 22, 1502841775, 0, 0, 0),
(45, 'What game do the Chicago Bulls play?', 1, 'Pot Luck', 'Basketball', 'Football', 'Soccer', 'Baseball', 31, 16, 7, 13, 1502849313, 0, 0, 0),
(46, 'Which of the following is not a citrus fruit?', 1, 'Pot Luck', 'Rhubarb', 'Lemon', 'Orange', 'Grapefruit', 50, 7, 8, 5, 1565869366, 0, 0, 0),
(47, 'In a Portuguese Man o\' War:', 1, 'Pot Luck', 'A jellyfish', 'A ship', 'A warrior', 'A car', 29, 23, 27, 6, 1502875387, 0, 0, 0),
(48, 'In which country was golf invented:', 1, 'Pot Luck', 'Scotland', 'USA', 'Zaire', 'Denmark', 51, 14, 3, 12, 1565869429, 0, 0, 0),
(49, 'How many years is three score and ten?', 1, 'Pot Luck', '70', '30', '60', '55', 31, 30, 17, 14, 1502875426, 0, 0, 0),
(50, 'Alive is the same as:', 1, 'Synonyms', 'Animated', 'Busy', 'Exciting', '', 33, 5, 18, 0, 1502841586, 0, 0, 0),
(51, 'Of which country is Warsaw the capital city?', 1, 'Pot Luck', 'Poland', 'Germany', 'Lithuania', 'Ukraine', 39, 12, 9, 15, 1502904756, 0, 0, 0),
(52, 'What is the first letter of the Greek alphabet?', 1, 'Pot Luck', 'Alpha', 'Beta', 'Gamma', 'Delta', 54, 9, 4, 3, 1502879357, 0, 0, 0),
(53, 'To which country does the island of Crete belong?', 1, 'Pot Luck', 'Greece', 'Italy', 'Frace', 'Turkey', 31, 13, 4, 17, 1502593382, 0, 0, 0),
(54, 'Which is the first book of the Bible?', 1, 'Pot Luck', 'Genesis', 'Exodus', 'Leviticus', 'Numbers', 41, 11, 10, 6, 1502709331, 0, 0, 0),
(55, 'On which coast would you find Oregon?', 1, 'Pot Luck', 'West', 'East', 'South', 'North', 48, 25, 11, 17, 1501910042, 0, 0, 0),
(56, 'How many strings does a guitar usually have?', 1, 'Classical Music', 'Six', 'Seven', 'Nine', 'Three', 40, 11, 6, 5, 1502592640, 0, 0, 0),
(57, 'What is a chihuahua?', 1, 'Pot Luck', 'Small Dog', 'Cat', 'Long Horse', 'Hamster', 34, 5, 5, 8, 1502593041, 0, 0, 0),
(58, 'Which country uses roubles as currency?', 1, 'Pot Luck', 'Russia', 'England', 'Poland', 'Hungary', 47, 5, 17, 22, 1502841743, 0, 0, 0),
(59, 'Shinto is the religion of which country?', 1, 'Religion', 'Japan', 'China', 'Korea', 'Mongolia', 32, 13, 13, 21, 1502835270, 0, 0, 0),
(60, 'Which is the hottest planet?', 1, 'Astronomy', 'Venus', 'Mercury', 'Earth', 'Jupiter', 31, 41, 3, 7, 1502904654, 0, 0, 0),
(61, 'What is the largest city of the United States?', 1, 'Geography', 'New York', 'Chicago', 'Washington D.C.', 'Los Angeles', 35, 6, 8, 32, 1502487570, 0, 0, 0),
(62, 'What sort of animals are dolphins?', 1, 'Pot Luck', 'Mammals', 'Reptiles', 'Amphibians', '', 54, 6, 19, 0, 1502615002, 0, 0, 0),
(63, 'What do you call the control panel of the car?', 1, 'Pot Luck', 'Dashboard', 'Applet', 'Visor', 'Window', 47, 3, 12, 4, 1503013076, 0, 0, 0),
(64, 'Who did Paris, the ruler of Troy, select as the most beautiful goddess?', 1, 'Greeks', 'Aphrodite', 'Athena', 'Apollo', 'Hemera', 36, 36, 11, 18, 1565869384, 0, 0, 0),
(65, 'World War 2 ended in:', 1, 'History', '1945', '1939', '1955', '1931', 45, 7, 19, 3, 1502849343, 0, 0, 0),
(66, 'How many planets are between Earth and the sun?', 1, 'Astronomy', '2', '1', '4', '3', 43, 11, 15, 22, 1502874998, 0, 0, 0),
(67, 'What country covers an entire continent?', 1, 'Geography', 'Australia', 'Antarctica', 'Africa', 'Europe', 39, 20, 16, 9, 1502841799, 0, 0, 0),
(68, 'What finally destroyed the aliens in War of the Worlds?', 1, 'Movies', 'Bacterias', 'Humans', 'Solar flare', 'Time', 38, 16, 25, 17, 1502849220, 0, 0, 0),
(69, 'Who was the first woman to win a Nobel Prize?', 1, 'Science', 'Marie Curie', 'Clara Barton', 'Alice Hamilton', 'Mary Leakey', 35, 17, 22, 9, 1502841481, 0, 0, 0),
(70, 'Who wrote Peter Pan?', 1, 'Literature', 'J. M. Barrie', 'F. D. Bedford', 'P. J. Hogan', 'James Callaghan', 28, 21, 18, 28, 1502841966, 0, 0, 0),
(71, 'Who is the current leader of Cuba?', 1, 'The World', 'Fidel Castro', 'Kim Jong', 'Adolf Hitler', 'Hamid Karzai', 37, 6, 6, 22, 1502849202, 0, 0, 0),
(72, 'What is the capital of Brazil?', 1, 'The World', 'Brasilia', 'Buenos Aires', 'Santiago', 'Madrid', 32, 13, 15, 13, 1501761350, 0, 0, 0),
(73, 'In what year did East and West Germany re-unite?', 1, 'History', '1990', '1945', '1960', '1975', 24, 19, 15, 18, 1502582602, 0, 0, 0),
(74, 'Which family ruled Russia from 1613 to 1917?', 1, 'History', 'Romanov', 'Mironov', 'Medvedev', 'Putin', 58, 23, 13, 17, 1502841724, 0, 0, 0),
(75, 'Which country uses a Yen for money?', 1, 'The World', 'Japan', 'China', 'Korea', 'India', 44, 25, 4, 5, 1503020943, 0, 0, 0),
(76, 'Which country is also a continent?', 1, 'The World', 'Australia', 'Brazil', 'China', 'Africa', 36, 6, 6, 14, 1502904637, 0, 0, 0),
(77, 'Who was the Greek goddess of victory?', 1, 'Greeks', 'Nike', 'Athena', 'Hera', 'Aether', 39, 29, 26, 15, 1501598382, 0, 0, 0),
(78, 'The blood of mammals is red.  What color is insect\'s blood?', 1, 'Science', 'Yellow', 'Green', 'Red', 'Blue', 28, 23, 16, 9, 1502789204, 0, 0, 0),
(79, 'What does a speleologist study?', 1, 'Science', 'Caves', 'Montains', 'Mirrors', 'Deep oceans', 24, 13, 10, 16, 1502593321, 0, 0, 0),
(80, 'What is the largest island in the world?', 1, 'Geography', 'Greenland', 'Hawaii', 'Australia', 'Kauai', 35, 12, 40, 7, 1502849467, 0, 0, 0),
(81, 'Rome was originally built on how many hills?', 1, 'History', '7', '2', '5', '15', 34, 18, 20, 11, 1501907569, 0, 0, 0),
(82, 'What is the body\'s largest internal organ?', 1, 'Anatomy', 'Small intestine', 'Big intestine', 'Liver', 'Heart', 38, 34, 17, 7, 1502841318, 0, 0, 0),
(83, 'What country lies along the western side of Spain?', 1, 'Geography', 'Portugal', 'France', 'England', 'Poland', 49, 20, 15, 16, 1502841705, 0, 0, 0),
(84, 'How many bones does a shark have?', 1, 'Pot Luck', '0', '23', '102', '55', 37, 17, 23, 24, 1502828193, 0, 0, 0),
(85, 'How many eyelids does a camel\'s eye have?', 1, 'Pot Luck', '3', '9', '6', '4', 34, 4, 18, 30, 1503020956, 0, 0, 0),
(86, 'What is the largest Portuguese speaking country in the world?', 1, 'The World', 'Brazil', 'Portugal', 'Argentina', 'Mongolia', 46, 34, 13, 10, 1567433014, 0, 0, 0),
(87, 'What do we now call the country that was once known as Siam?', 1, 'History', 'Thailand', 'Chile', 'Turkey', 'Hungary', 23, 24, 21, 14, 1502614883, 0, 0, 0),
(88, 'What is the largest Japanese speaking country?', 1, 'The World', 'Japan', 'India', 'Korea', 'Mongolia', 41, 3, 7, 7, 1503012951, 0, 0, 0),
(89, 'What city would you go to see a tower that leans?', 1, 'The World', 'Pisa', 'Italy', 'Paris', 'Madrid', 50, 27, 14, 5, 1502593544, 0, 0, 0),
(90, 'The most populated country in western Europe is?', 1, 'The World', 'Germany', 'Poland', 'Greece', 'Finland', 37, 11, 10, 13, 1502841901, 0, 0, 0),
(91, 'Homeowners buy surge protectors to protect their homes from what?', 1, 'Pot Luck', 'Electric Current', 'Air Pressure', 'Water Flow', 'Buyer\'s remorse', 37, 9, 13, 4, 1502709348, 0, 0, 0),
(92, 'A white dove, also a symbol of Valentine\'s Day, symbolizes what', 1, 'Pot Luck', 'Good Luck', 'Love', 'Peace', 'Relationship', 20, 30, 25, 8, 1502904814, 0, 0, 0),
(93, 'What was Buddha\'s name before his enlightenment?', 1, 'Religion', 'Sidhartha', 'Suddhodana', 'Saraha', 'Shantideva', 35, 35, 26, 13, 1503020895, 0, 0, 0),
(94, 'What was Sherlock Holmes\' brother\'s name?', 1, 'Literature', 'Mycroft', 'Homer', 'Vernet', 'Watson', 24, 11, 10, 26, 1502593127, 0, 0, 0),
(95, 'What type of rocks floats in water?', 1, 'Pot Luck', 'Pumice', 'Gabbro', 'Granite', 'Peridotite', 38, 8, 23, 15, 1502841985, 0, 0, 0),
(96, 'What is the most abundant metal in the Earth\'s crust?', 1, 'The World', 'Aluminum', 'Iron', 'Copper', 'Cobalt', 26, 25, 21, 12, 1502841822, 0, 0, 0),
(97, 'In which part of the Americas did the Aztecs live?', 1, 'History', 'Mexico', 'Chile', 'Brazil', 'Bolivia', 38, 15, 14, 15, 1502849159, 0, 0, 0),
(98, 'What do you call a young lion?', 1, 'Animals', 'A Cub', 'A Trainee', 'A Filhote', 'An Alias', 35, 5, 5, 3, 1502874966, 0, 0, 0),
(99, 'Who uses Braille?', 1, 'Pot Luck', 'Blind people', 'Deaf people', 'Monks', 'Computers', 43, 12, 11, 3, 1502849294, 0, 0, 0),
(100, 'A horn belongs to which class of musical instruments?', 1, 'Pot Luck', 'Brass', 'String', 'Wind', 'Percussion', 26, 3, 25, 9, 1502828209, 0, 0, 0),
(101, 'What do you call a five-sided figure?', 1, 'Geometry', 'Pentagon', 'Fivagon', 'Hexagon', 'Pentadecagon', 30, 6, 17, 1, 1502904672, 0, 0, 0),
(102, 'The weight of which precious metal is measured in carats?', 1, 'Pot Luck', 'Gold', 'Silver', 'Platinum', 'Mercury', 35, 8, 7, 14, 1503012968, 0, 0, 0),
(103, 'What people used a tepee as a dwelling?', 1, 'History', 'Native Americans', 'Egyptians', 'Chinese', 'Aztecs', 41, 15, 8, 17, 1502849394, 0, 0, 0),
(104, 'Which waterway separates Africa from Asia?', 1, 'Places', 'Suez Canal', 'Black Sea', 'Mediterranean Sea', 'Red Sea', 18, 15, 14, 13, 1502874837, 0, 0, 0),
(105, 'Which is the largest of the Greek islands?', 1, 'Places', 'Crete', 'Dokos', 'Lesbos', 'Rhodes', 31, 10, 11, 15, 1502593061, 0, 0, 0),
(106, 'How many minutes does a soccer match last?', 1, 'Pot Luck', '90', '120', '60', '150', 32, 23, 11, 11, 1501911000, 0, 0, 0),
(114, 'ffffawwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww', 0, 'dwwa', 'dawdadw', 'dwadaw', 'wawdaw', 'wdawad', 0, 0, 0, 0, 0, 143985234, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `gm_loading`
--

CREATE TABLE `gm_loading` (
  `gamemode` tinytext NOT NULL,
  `steamids` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gm_loading`
--

INSERT INTO `gm_loading` (`gamemode`, `steamids`) VALUES
('pvpbattle', ''),
('ballrace', ''),
('minigolf', ''),
('ultimatechimerahunt', ''),
('sourcekarts', ''),
('gourmetrace', ''),
('virus', ''),
('zombiemassacre', '');

-- --------------------------------------------------------

--
-- Table structure for table `gm_log`
--

CREATE TABLE `gm_log` (
  `type` text CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `message` text CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `srvid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gm_log_error`
--

CREATE TABLE `gm_log_error` (
  `srvid` int(11) NOT NULL,
  `message` text CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gm_log_trade`
--

CREATE TABLE `gm_log_trade` (
  `ply1` text NOT NULL,
  `ply2` text NOT NULL,
  `money1` int(11) NOT NULL,
  `money2` int(11) NOT NULL,
  `recv1` text NOT NULL,
  `recv2` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gm_maps`
--

CREATE TABLE `gm_maps` (
  `map` tinytext NOT NULL,
  `mapname` tinytext NOT NULL,
  `desc` text NOT NULL,
  `author` tinytext NOT NULL,
  `gamemode` tinytext NOT NULL,
  `playedCount` int(11) NOT NULL,
  `dateAdded` int(11) NOT NULL,
  `dateModified` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `gm_maps`
--

INSERT INTO `gm_maps` (`map`, `mapname`, `desc`, `author`, `gamemode`, `playedCount`, `dateAdded`, `dateModified`) VALUES
('gmt_ballracer_facile', 'Facile', 'A simplisic, but difficult world. Avoid repellers in space, or go full hyperspeed while magnetized.', 'GMTower: Deluxe Team', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_flyinhigh01', 'Flyin\' High', 'Easy levels with fun mechanics. Also home to the one and only Bumper Island.', 'Muffin', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_grassworld01', 'Grass World', 'Light and fluffy level design with a broader appeal to difficulty.', 'MacDGuy', 'ballrace', 0, 1249150914, 1249150914),
('gmt_ballracer_iceworld03', 'Ice World', 'Someone built a Ball Race course in the Arctic Circle. They didn\'t, however, build any snowmen...', 'Angry Penguin', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_khromidro02', 'Khromidro', 'Inspired by mini golf courses, Khromidro boasts anti-gravity as a feature.', 'Lifeless', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_memories02', 'Memories', 'New gameplay gimmicks - repellers and attracters that twist the concept of gravity. Being the hardest, most difficult Ball Race map, it contains the highest level count and randomly chosen left or right paths for replay value.', 'MacDGuy/Mr. Sunabouzu', 'ballrace', 0, 1280871103, 1280871103),
('gmt_ballracer_metalworld', 'Metal World', 'Hard levels in a world made of metal, also introducing new objects such as crushers, lava and gears.', 'GMTower: Deluxe Team', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_midori02', 'Midori', 'Wait a minute... is that a Robot in the sky?', 'Lifeless', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_neonlights01', 'Neon Lights', 'Roll around in this world full of bright Neon Lights!', 'PikaUCH', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_nightball', 'Night World', 'Roll trough this gravity defying world with moving obstacles, lasers, and lots of speed!', 'GMTower: Deluxe Team', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_paradise03', 'Paradise', 'Capturing the essence of summer, Paradise is a tropical-themed level with a penchant for explosions... and tubes.', 'Matt', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_sandworld02', 'Sand World', 'Some might call the desert gritzy. Others might say it has shifting sands. All I know is that it doesn\'t rain.', 'Neox', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_skyworld01', 'Sky World', 'The easiest of all the worlds. This world will introduce you to the basic concepts that become harder in the future.', 'MacDGuy', 'ballrace', 0, 1249150914, 1249150914),
('gmt_ballracer_spaceworld01', 'Space World', 'Hard, more dynamic levels with new obstacles such as a catapult.', 'GMTower: Deluxe Team', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_tranquil01', 'Tranquil', 'A magical world full of... RAINBOWS!', 'GMTower: Deluxe Team', 'ballrace', 0, 1339137397, 1339252668),
('gmt_ballracer_waterworld02', 'Water World', 'Meet water physics in this fun, fast paced world. Float, dive and bounce to victory!', 'GMTower: Deluxe Team', 'ballrace', 0, 1339137397, 1339252668),
('gmt_build002a', 'Lobby \'12', 'The Lobby serves a multitude of different purposes. For one it\'s a nice, calming area to first spawn at. The luxurious design and lucid layout aims to both interest and solify new users. For normal users, it can easily be used for a meeting point for creating new friends.', 'PixelTail Games', 'gmtlobby', 0, 1249150914, 1249150914),
('gmt_build0c2a', 'Holiday \'12 Lobby', 'Happy holidays from Tower! A snowy version of Lobby filled with holiday goodness. Take a breather and walk outside and hang around the heated pool. Buy exclusive holiday items located in the present sack.', 'PixelTail Games', 'gmtlobby', 0, 1355168548, 1355168548),
('gmt_build0c3', 'Holiday \'13 Lobby', 'Happy holidays from GMod Tower! A snowy version of Lobby filled with holiday goodness. Take a breather and walk outside and hang around the heated pool. Buy exclusive holiday items located in the present sack.', 'PixelTail Games', 'gmtlobby', 0, 1355168548, 1355168548),
('gmt_build0c3a', 'Winter \'14 Lobby', 'Holidays are over, but the snow is here to stay.', 'PixelTail Games', 'gmtlobby', 0, 1355168548, 1355168548),
('gmt_build0h2', 'Haunted \'12 Lobby', 'Spooky, scary, and bone chilling Lobby. Decorated for Halloween, the night of the dead. Ride the new Haunted Mansion ride located near the suites!', 'PixelTail Games', 'gmtlobby', 0, 1249150914, 1249150914),
('gmt_build0h3', 'Haunted \'13 Lobby', 'Spooky, scary, and bone chilling Lobby. Decorated for Halloween, the night of the dead. Ride the Haunted Mansion ride or discover a new area!', 'PixelTail Games', 'gmtlobby', 0, 1249150914, 1249150914),
('gmt_build0h3_games', 'âˆŸâˆŸâˆŸâˆŸâˆŸâˆŸâˆŸ', '????????????', '', 'gmtlobby', 0, 1249150914, 1249150914),
('gmt_build0j2', 'July \'13 Lobby', 'A rock show?', 'PixelTail Games', 'gmtlobby', 0, 1355168548, 1355168548),
('gmt_build0s2', 'Spring \'13 Lobby', 'The snow has finally melted, and spring has been ushered in!', 'PixelTail Games', 'gmtlobby', 0, 1355168548, 1355168548),
('gmt_build0s2a', 'Spring \'13 Lobby', 'The snow has finally melted, and spring has been ushered in!', 'PixelTail Games', 'gmtlobby', 0, 1355168548, 1355168548),
('gmt_build0s2b', 'Summer \'14 Lobby', 'Summer is here and the Entertainment Plaza has been given a new lick of paint.', 'PixelTail Games', 'gmtlobby', 0, 1399590414, 1399590414),
('gmt_gr_nile', 'The Nile', 'A small Egyptic town with food... lots of food.', 'Bumpy', 'gourmetrace', 0, 1374298302, 1374298302),
('gmt_gr_ruins', 'Ruins', 'Explore the ancient ruins left behind in this big swamp.', 'Bumpy', 'gourmetrace', 0, 1374298302, 1374298302),
('gmt_halloween2014', 'Halloween 2014', 'Enter the madness.', 'MacDGuy', 'gmtlobby', 0, 1416200139, 1416200139),
('gmt_halloween2015', 'Halloween 2015', 'Enter the madness.', 'MacDGuy', 'gmtlobby', 0, 1416200139, 1416200139),
('gmt_lobby2_01', 'Lobby 2 Beta #1', 'Welcome to Lobby 2. A new, fresh, and exciting map full of gorgeous views and fun. As it is a beta, things might not always work. No refunds.', 'PixelTail Games', 'gmtlobby', 0, 1399590414, 1399590414),
('gmt_lobby2_02', 'Lobby 2 Beta #2', 'Welcome to Lobby 2. A new, fresh, and exciting map full of gorgeous views and fun. As it is a beta, things might not always work.', 'PixelTail Games', 'gmtlobby', 0, 1399590414, 1399590414),
('gmt_lobby2_03', 'Lobby 2 Beta #3', 'Welcome to Lobby 2. A new, fresh, and exciting map full of gorgeous views and fun. As it is a beta, things might not always work.', 'PixelTail Games', 'gmtlobby', 0, 1399590414, 1399590414),
('gmt_lobby2_04', 'Lobby 2 Beta #4', 'Welcome to Lobby 2. A new, fresh, and exciting map full of gorgeous views and fun. As it is a beta, things might not always work.', 'PixelTail Games', 'gmtlobby', 0, 1399590414, 1399590414),
('gmt_lobby2_r3', 'Lobby 2', 'Welcome to Lobby 2. A new, fresh, and exciting map full of gorgeous views and fun. As it is a beta, things might not always work.', 'PixelTail Games', 'gmtlobby', 0, 1399590414, 1399590414),
('gmt_lobby2_r6', 'Lobby 2 - Deluxe', 'The construction workers have finally finished the Arcade and opened up some new stores, and wow, would you look at those lights in the Plaza! We\'re not quite sure where the sun went though...', 'PixelTail Games / GMT: Deluxe Team', 'gmtlobby', 0, 1399590414, 1399590414),
('gmt_lobby2_r6c', '[Christmas] Lobby 2 - Deluxe', 'Happy holidays from GMTower: Deluxe! A snowy version of Lobby filled with holiday goodness. Take a breather and walk outside and hang around the heated pool. Buy exclusive holiday items located in the present sack.', 'PixelTail Games / GMT: Deluxe Team', 'gmtlobby', 0, 1399590414, 1399590414),
('gmt_lobby2_r6h', '[Halloween] Lobby 2 - Deluxe', 'A spooky version of the Lobby. Search for Candy Buckets around the Plaza and drop them off at the cauldron for special Halloween items! Feeling lucky? Try our new prize wheel \"Spin or Treat\".', 'PixelTail Games / GMT: Deluxe Team', 'gmtlobby', 0, 1399590414, 1399590414),
('gmt_lobby2_r7', 'Lobby 2 - Deluxe', 'The construction workers have finally finished the Arcade and opened up some new stores, and wow, would you look at those lights in the Plaza! We\'re not quite sure where the sun went though...', 'PixelTail Games / GMT: Deluxe Team', 'gmtlobby', 0, 1399590414, 1399590414),
('gmt_minigolf_desert01', 'Desert', 'Golf your way through the hot desert, on courses build by the pharaohs. Be sure to take a bottle of water with you!', 'Bumpy', 'minigolf', 0, 1374298302, 1374298302),
('gmt_minigolf_forest04', 'Forest', 'This course will take you through a delightful forest with challenging courses.', 'madmijk and IrZipher', 'minigolf', 0, 1374298302, 1374298302),
('gmt_minigolf_garden05', 'Karafuru Gardens', 'Look at all the nice lotus flowers. Enjoy the babbling brook. Marvel in the non-zen of it all. PS: Karafuru means colorful in Japanese.', 'Matt/Aigik', 'minigolf', 0, 1345328453, 1345506617),
('gmt_minigolf_moon01', 'Moon', 'One small step for man, one giant putt for minigolf.', 'nyro', 'minigolf', 0, 1374298302, 1374298302),
('gmt_minigolf_sandbar06', 'Sand Bar', 'Relax, and listen to the calming waves. Hear the seagulls calling. Wonder where all of the bars are in this sandbar.', 'Matt', 'minigolf', 0, 1345328453, 1345506617),
('gmt_minigolf_snowfall01', 'Snow Fall', 'Way up north, there\'s a peaceful and quiet golf course. Ignoring the fact that it\'s sub zero temperatures and you\'re prone to frostbite and hypthermia, we\'d say it\'s a pretty decent place.', 'Lifeless', 'minigolf', 0, 1374298302, 1374298302),
('gmt_minigolf_waterhole04', 'Waterhole', 'Go on, take a drink from the watering hole. It won\'t bite, I promise. Ha ha! I lied!', 'Lifeless', 'minigolf', 0, 1345328453, 1345506617),
('gmt_pvp_aether', 'Aether', 'Some island floating above the clouds, are now a battleground for some worthy combatants. Some say that this is the home to the gods and that some are even watching these battles, so you better be on your best today. You wouldn\'t want to embarrass yourself in front of gods.', 'Bumpy', 'pvpbattle', 0, 1249150914, 1249150914),
('gmt_pvp_construction01', 'Construction Zone', 'Inspired by a Half-Life 2: Deathmatch map, dm_construction - this map is sure to please everyone. This map creates layers of carnage.', 'Mr. Sunabouzu', 'pvpbattle', 0, 1249150914, 1249150914),
('gmt_pvp_containership02', 'Container Ship', 'Take the battle across the sea on a moving cargo ship. Dozens of containers for cover and sneak attacks. Multiple layers of action packed destruction. Careful not to fall into the water, as the sharks will surely eat you up for breakfast.', 'Lifeless', 'pvpbattle', 0, 1283286092, 1339745343),
('gmt_pvp_frostbite01', 'Frost Bite', 'The complete opposite of Meadows. It\'s large, cold, dark, and unforgiving. There\'s two power ups and around three medkits on this level. It comes complete with a sniper tower, ice mines, and blow up shacks. This battlefield is geared more towards long range, but can still become close range before you know it.', 'Mr. Sunabouzu/MacDGuy', 'pvpbattle', 0, 1249150914, 1249150914),
('gmt_pvp_mars', 'Mars', 'A small group of survivors were discovered living in a secret military base. They were also found to be endlessly shooting each other and respawning.', 'Bumpy / Zoki', 'pvpbattle', 0, 1249150914, 1249150914),
('gmt_pvp_meadow01', 'Meadows', 'Based on Metal Gear Solid 3\'s boss level, this small meadow will offer the most destructive gameplay currently available. With only one power up and one medkit, things are sure to heat up. Watch your enemies fall like pedals.', 'Mr. Sunabouzu', 'pvpbattle', 0, 1249150914, 1249150914),
('gmt_pvp_neo', 'Neo', 'A virtual world that you somehow ended up in. I guess the best thing to do now is to kill people.', 'Bumpy', 'pvpbattle', 0, 1249150914, 1249150914),
('gmt_pvp_oneslip01', 'OneSlip', 'Another Jaykin\' Bacon promoted map, based on Quake maps. The risks are higher when you\'re in space. Be careful not to fall off into the black void!', 'Sniper', 'pvpbattle', 0, 1249150914, 1249150914),
('gmt_pvp_pit01', 'The Pit', 'Take being gothic to a whole new level. This map is recommended for anyone who dresses exclusively in black.', 'Dustpup', 'pvpbattle', 0, 1283286092, 1283301811),
('gmt_pvp_shard01', 'Shard', 'This reminds me of a... reflective surface of some kind. Nah, must be a coincidence.', 'Matt', 'pvpbattle', 0, 1355168548, 1355168548),
('gmt_pvp_subway01', 'Subway', 'Several decades ago, the major world powers began building a secret underground subway system. It went largely unused until someone stumbled upon the entrance and posted about it on Twitter. Since then, it\'s been quarantined and denied by every government.', 'Lifeless', 'pvpbattle', 0, 1355168548, 1355168548),
('gmt_sk_island01', '', '', '', '', 0, 0, 0),
('gmt_sk_island02', 'Drift Island', 'This island is home of the famous loop, which is the most representative landmark of the mysterious Island.', 'Matt', 'sourcekarts', 0, 1345328453, 1345506617),
('gmt_sk_lifelessraceway01', 'Lifeless Raceway', 'A nostalgic raceway with turns and exciting jumps.', 'Lifeless', 'sourcekarts', 0, 1345328453, 1345506617),
('gmt_sk_rave', 'Rave', 'Someone build a racing course inside of a rave party, this better be fun!', 'Madmijk / Bumpy', 'sourcekarts', 0, 1345328453, 1345506617),
('gmt_uch_alpine01', 'Alpine', 'The Chimera has taken over the once peaceful town up in the mountains. Go stop it, just don\'t get hurt!', 'Shadowbounty', 'ultimatechimerahunt', 0, 1354507791, 1354507791),
('gmt_uch_camping01', 'Camping Grounds', 'Try not to sleep...', 'Batandy', 'ultimatechimerahunt', 0, 1285014233, 1285014233),
('gmt_uch_clubtitiboo04', 'Club Titiboo', 'All the Pigmasks come here to party hard, only to be stomped hard by the local Chimera. Drinks are also sold at extortionate prices, so speak easy.', 'Lifeless', 'ultimatechimerahunt', 0, 1285014233, 1285014233),
('gmt_uch_downtown04', 'Downtown', 'Stop in at your local Rocket Noodle, assuming they haven\'t changed the menu again.', 'Matt', 'ultimatechimerahunt', 0, 1345329515, 1347455325),
('gmt_uch_egypt01', 'Egypt', 'The Pigmasks have escaped to the far far Egyptic deserts, you wouldn\'t find the Chimera here... right?', 'Shadowbounty', 'ultimatechimerahunt', 0, 1354507791, 1354507791),
('gmt_uch_falloff01', 'Fall Off', 'Fall up, down, in, out, or on, but just don\'t fall off.', 'Matt', 'ultimatechimerahunt', 0, 1347798381, 1347798381),
('gmt_uch_headquarters03', 'Headquarters', 'The Pigmasks all thought they\'d be safe in their secret headquarters. The Chimera set out to prove them wrong.', 'Lifeless', 'ultimatechimerahunt', 0, 1294179714, 1345329515),
('gmt_uch_laboratory01', 'Laboratory', 'Situated inside a mad scientist\'s laboratory, this place doesn\'t have anything to do with the creation of the Ultimate Chimera. That we know of.', 'martyman3175', 'ultimatechimerahunt', 0, 1285014233, 1285014233),
('gmt_uch_mrsaturnvalley02', 'Mr. Saturn Valley', 'In a peaceful valley, the strange creatures known as Mr. Saturn live. Unfortunately, the Pigmasks and Chimera found the valley.', 'Lifeless', 'ultimatechimerahunt', 0, 1345329515, 1347187690),
('gmt_uch_newporkcity01', 'New Pork City', 'Welcomidos to New Pork City!', 'Jack', 'ultimatechimerahunt', 0, 1354507791, 1354507791),
('gmt_uch_shadyoaks03', 'Shady Oaks', 'On the outskirts of town, this small facility still stands. Watch out for the gate though, it doesn\'t look very strong...', 'DrStalin', 'ultimatechimerahunt', 0, 1285014233, 1285014233),
('gmt_uch_snowedin01', 'Snowed In', 'Cold pork? Sounds gross. Someone should probably heat that up or something. Wait, you\'re eating it raw?', 'Matt', 'ultimatechimerahunt', 0, 1354507791, 1354507791),
('gmt_uch_tazmily01', 'Tazmily Village', 'In the peaceful village of Tazmily, there are only three absolutes: Mr. Saturn will show up, the Chimera will try to eat Pigmasks, and the retail is hideously expensive.', 'Charles Wenzel', 'ultimatechimerahunt', 0, 1285014233, 1285014233),
('gmt_uch_woodland03', 'Woodlands', 'A chainlink fence won\'t keep the Chimera out, but it will keep the Pigmasks in.', 'Matt', 'ultimatechimerahunt', 0, 1345329515, 1347455325),
('gmt_virus_aztec01', 'Aztec', 'Set in an ancient ruin, Aztec is devoid of modern comforts. Due to being relatively unobstructed, Aztec is a sniper\'s paradise.', '', 'virus', 0, 1275258231, 1275343964),
('gmt_virus_derelict01', 'Derelict Station', 'In space, no one can hear you scream. Good thing screaming won\'t help you anyway.', 'Matt', 'virus', 0, 1354508003, 1354508003),
('gmt_virus_dust03', 'Dust', 'Inspired by Counter-Strike: Source\'s ever-popular Dust map, Dust strikes an interesting balance between long-range and short-range combat.', 'Lifeless', 'virus', 0, 1276903270, 1339252668),
('gmt_virus_facility202', 'Facility 2', 'Ripped straight out of Goldeneye 64, Facility offers twisting corridors and fast-paced combat.', 'Lifeless', 'virus', 0, 1275253872, 1275253872),
('gmt_virus_hospital204', 'Hospital', 'The last place you want to be is in a hospital filled with unknown viruses.', 'Lifeless', 'virus', 0, 1345329515, 1345506617),
('gmt_virus_metaldream05', 'Metal Dreams', 'Deep underground, in an abandoned secret base, Metal Dreams has lots of chokepoints. Watch out for infected falling out of the ceiling!', 'Zoki', 'virus', 0, 1294172505, 1294267401),
('gmt_virus_riposte01', 'Riposte', 'In this Unreal Tournament-inspired map, there are tons of nooks and crannies for both the survivors and infected to use.', 'Monarch', 'virus', 0, 1275253872, 1275253872),
('gmt_virus_sewage01', 'Sewage', 'For some reason, you\'re in some kind of toxic waste dump. Try not to fall in the water, it\'s incredibly unpleasant. And lethal.', 'Sentura', 'virus', 0, 1275258231, 1275253872),
('gmt_zm_arena_acrophobia01', 'Acrophobia', 'Are you afraid of heights? The zombies certainly aren\'t. The jury\'s still out on how they got on top of the building, though.', 'Lifeless', 'zombiemassacre', 0, 1345328453, 1345328453),
('gmt_zm_arena_foundation02', 'Foundation', 'The workers are on strike again. I think the bolter quit before he finished his job. Don\'t lose your balance on the scaffolding.', 'Matt', 'zombiemassacre', 0, 1345328453, 1345328453),
('gmt_zm_arena_foundation03', 'Foundation', 'The workers are on strike again. I think the bolter quit before he finished his job. Don\'t lose your balance on the scaffolding.', 'Matt', 'zombiemassacre', 0, 1345328453, 1345328453),
('gmt_zm_arena_gasoline01', 'Gasoline', 'After the apocalypse, gasoline was hideously expensive. Even the zombies thought it was outrageous.', 'Lifeless', 'zombiemassacre', 0, 1345328453, 1345328453),
('gmt_zm_arena_scrap01', 'Scrap', 'You\'d think that the first place you\'d want to go in a zombie apocalypse is a scrap yard, right? Wrong. You just have nowhere to run.', 'Matt', 'zombiemassacre', 0, 1345328453, 1345328453),
('gmt_zm_arena_thedocks01', 'The Docks', 'It turns out that zombies can actually swim. So, you\'re kind of screwed because this place is apparently an island.', 'Lifeless', 'zombiemassacre', 0, 1345328453, 1345328453),
('gmt_zm_arena_trainyard01', 'Trainyard', 'Trains run back and forth, escorting survivors out of infected areas. Too bad they don\'t discriminate between targets on the tracks.', 'Lifeless', 'zombiemassacre', 0, 1345328453, 1345328453),
('gmt_zm_arena_underpass02', 'Underpass', 'You\'ve somehow gotten trapped in one city block. There aren\'t even any good stores around to buy fashionable accessories from. What will you do!?', 'Matt', 'zombiemassacre', 0, 1345328453, 1345506617);

-- --------------------------------------------------------

--
-- Table structure for table `gm_name_suggestions`
--

CREATE TABLE `gm_name_suggestions` (
  `player` int(11) NOT NULL,
  `name` text NOT NULL,
  `suggestion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gm_servers`
--

CREATE TABLE `gm_servers` (
  `id` int(10) UNSIGNED NOT NULL,
  `ip` varchar(14) NOT NULL,
  `port` varchar(11) NOT NULL,
  `players` varchar(45) NOT NULL,
  `playerlist` varchar(45) NOT NULL,
  `msg` varchar(45) NOT NULL,
  `maxplayers` varchar(45) NOT NULL,
  `map` varchar(45) NOT NULL,
  `password` varchar(45) DEFAULT NULL,
  `gamemode` varchar(45) NOT NULL,
  `status` varchar(45) NOT NULL,
  `lastupdate` varchar(45) NOT NULL,
  `lastplayers` varchar(45) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `gm_servers`
--

INSERT INTO `gm_servers` (`id`, `ip`, `port`, `players`, `playerlist`, `msg`, `maxplayers`, `map`, `password`, `gamemode`, `status`, `lastupdate`, `lastplayers`) VALUES
(4, '24.18.106.235', '27017', '0', '\0', '#nogame', '12', 'gmt_ballracer_sandworld02', '', 'ballrace', '1', '1638773284', '\0'),
(5, '24.18.106.235', '27019', '0', '\0', '#nogame', '12', 'gmt_pvp_containership02', '', 'pvpbattle', '1', '1638702598', '\0'),
(6, '24.18.106.235', '27024', '0', '\0', '#nogame', '15', 'gmt_virus_riposte01', '', 'virus', '1', '1627446315', '\0'),
(7, '24.18.106.235', '27050', '1', '\0', '92||||5/15', '16', 'gmt_uch_camping01', '', 'ultimatechimerahunt', '2', '1627345382', '\0'),
(8, '24.18.106.235', '27060', '0', '\0', '#nogame', '12', 'gmt_zm_arena_foundation03', '', 'zombiemassacre', '1', '1628218206', '\0'),
(14, '24.18.106.235', '27018', '1', 'à‰c', '1/18||||4', '24', 'gmt_minigolf_forest04', '', 'minigolf', '3', '1638757067', '\0'),
(16, '24.18.106.235', '27025', '0', '\0', '#nogame', '12', 'gmt_sk_lifelessraceway01', '', 'sourcekarts', '1', '1628212015', '\0'),
(20, '24.18.106.235', '27070', '0', '\0', '#nogame', '8', 'gmt_gr_ruins', '', 'gourmetrace', '1', '1626072854', '\0'),
(99, '24.18.106.235', '27015', '2', 'à‰clcë', '', '64', 'gmt_lobby2_r3', '', 'gmtlobby', '1', '1638773289', '');

-- --------------------------------------------------------

--
-- Table structure for table `gm_users`
--

CREATE TABLE `gm_users` (
  `id` text NOT NULL,
  `name` text NOT NULL,
  `steamid` text NOT NULL,
  `betatest` varchar(45) NOT NULL,
  `CreatedTime` varchar(45) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `levels` text NOT NULL,
  `pvpweapons` text NOT NULL,
  `clisettings` text NOT NULL,
  `MaxItems` varchar(45) NOT NULL,
  `inventory` text NOT NULL,
  `BankLimit` text NOT NULL,
  `bank` text NOT NULL,
  `plysize` varchar(45) NOT NULL,
  `achivement` text NOT NULL,
  `Roomdata` text NOT NULL,
  `condodata` text NOT NULL,
  `money` int(10) NOT NULL,
  `LastOnline` varchar(45) NOT NULL,
  `hat` char(45) NOT NULL,
  `tetrisscore` varchar(45) NOT NULL,
  `time` varchar(45) NOT NULL,
  `ramk` int(11) NOT NULL,
  `ball` int(11) NOT NULL,
  `faceHat` int(11) NOT NULL,
  `pendingmoney` int(11) DEFAULT NULL,
  `chips` int(11) NOT NULL,
  `fakename` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gm_vip`
--

CREATE TABLE `gm_vip` (
  `steamid` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `gm_vip`
--

INSERT INTO `gm_vip` (`steamid`) VALUES
('STEAM_0:0:71992617');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `gm_gomap`
--
ALTER TABLE `gm_gomap`
  ADD PRIMARY KEY (`serverid`);

--
-- Indexes for table `gm_items`
--
ALTER TABLE `gm_items`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `gm_jeopardy`
--
ALTER TABLE `gm_jeopardy`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoryindex` (`cat`);

--
-- Indexes for table `gm_maps`
--
ALTER TABLE `gm_maps`
  ADD PRIMARY KEY (`map`(255));

--
-- Indexes for table `gm_servers`
--
ALTER TABLE `gm_servers`
  ADD PRIMARY KEY (`id`,`msg`);

--
-- Indexes for table `gm_users`
--
ALTER TABLE `gm_users`
  ADD PRIMARY KEY (`id`(16));

--
-- Indexes for table `gm_vip`
--
ALTER TABLE `gm_vip`
  ADD PRIMARY KEY (`steamid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `gm_gomap`
--
ALTER TABLE `gm_gomap`
  MODIFY `serverid` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `gm_jeopardy`
--
ALTER TABLE `gm_jeopardy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;

--
-- AUTO_INCREMENT for table `gm_servers`
--
ALTER TABLE `gm_servers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
