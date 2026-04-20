-- Flashcard UI facade — delegates to submodules under ui/
local study = require("config.flashcards.ui.study")
local create = require("config.flashcards.ui.create")
local dashboard = require("config.flashcards.ui.dashboard")
local browse = require("config.flashcards.ui.browse")

return {
  study = study.study,
  study_deck = study.study_deck,
  create_card = create.create_card,
  dashboard = dashboard.dashboard,
  browse = browse.browse,
  list_decks = browse.list_decks,
}
