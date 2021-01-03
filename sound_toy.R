# play with sound files
# goal is to extract mic breaks in a recording of a radio show

library(tidyverse)
library(tuneR)
library(seewave)

train_voice_raw <- tuneR::readMP3("data/bk_train_voice.mp3") %>% normalize()
voice_melfcc <- train_voice_raw %>% melfcc()

train_music_raw <- tuneR::readMP3("data/bk_train_music.mp3") %>% normalize()


seewave::spectro(train_music_raw, flim = c(0,2),fastdisp = TRUE)
seewave::spectro(train_voice_raw, flim = c(0,2),fastdisp = TRUE)
