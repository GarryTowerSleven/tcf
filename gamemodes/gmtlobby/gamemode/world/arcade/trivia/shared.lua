module( "trivia", package.seeall )

plynet.Register( "Entity", "TriviaPodium" )

ERROR_UNKNOWN = 0
ERROR_TOKEN = 1
ERROR_QUESTION = 2
ERROR_HTTP = 3

ErrorStrings = {
    [0] = "ERROR_UNKNOWN",
    [1] = "ERROR_TOKEN",
    [2] = "ERROR_QUESTION",
    [3] = "ERROR_HTTP",
}

STATE_IDLE = 0
STATE_WAITING = 1
STATE_PLAY = 2
STATE_INTERMISSION = 3
STATE_END = 4

DIFFICULTY_ANY = 0
DIFFICULTY_EASY = "easy"
DIFFICULTY_MEDIUM = "medium"
DIFFICULTY_HARD = "hard"

Categories = {
    [0] = "Any",
    [9] = "General Knowledge",
    [10] = "Books",
    [11] = "Film",
    [12] = "Music",
    [13] = "Musicals & Theatres",
    [14] = "Television",
    [15] = "Video Games",
    [16] = "Board Games",
    [17] = "Science & Nature",
    [18] = "Computers",
    [19] = "Mathematics",
    [20] = "Mythology",
    [21] = "Sports",
    [22] = "Geography",
    [23] = "History",
    [24] = "Politics",
    [25] = "Art",
    [26] = "Celebrities",
    [27] = "Animals",
    [28] = "Vehicles",
    [29] = "Comics",
    [30] = "Gadgets",
    [31] = "Japanese Anime & Manga",
    [32] = "Cartoon & Animations",
}