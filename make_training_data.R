# play with sound files
# goal is to extract mic breaks in a recording of a radio show

library(tidyverse)
library(tuneR)
library(seewave)
library(av)
library(soundgen)

# load audio files -----------------------------------------------------------------------
vf <- "data/bk_train_voice.mp3"
mf <- "data/bk_train_music.mp3"

train_voice_raw <- tuneR::readMP3(vf) %>% tuneR::normalize(unit="32")
play(train_voice_raw)
train_music_raw <- tuneR::readMP3("data/bk_train_music.mp3") %>% tuneR::normalize(unit="32")
tuneR::play(train_music_raw)

# function to make subset of wave object ------------------------------------------------
# shrink by taking 60 seconds total of wave equally spaced in 5 second blocks
# assume mono or take left channel only
get_wave_subset <- function(wave_obj,desired_secs = 60,segment_secs = 5){
   segment_count <- round(desired_secs/segment_secs)
   segment_size <- segment_secs*wave_obj@samp.rate
   segment_starts <- length(wave_obj)/segment_count
   start_points <- seq.int(1, length(wave_obj),segment_starts)
   segments <- unlist(map2(start_points,start_points+segment_size,seq))
   wave_obj@left <- wave_obj@left[segments]
   return(wave_obj)
}

# get voice properties -----------------------------------------------------------
train_voice <- get_wave_subset(train_voice_raw)
v_properites <- analyze(train_voice@left,train_voice@samp.rate,plot = TRUE,savePath = "./data")
v_properties <- v_properties %>% 
   as_tibble() %>% 
   mutate(type="voice") %>% 
   select(type,everything())

save(v_properties,file="data/v_properties.rdata")
file.rename("data/sound.png","data/voice.png")

# get music properties -----------------------------------------------------------
train_music <- get_wave_subset(train_music_raw)
m_properties <- analyze(train_music@left,train_music@samp.rate,plot = TRUE,savePath = "./data")
m_properties <- m_properties %>% 
   as_tibble() %>% 
   mutate(type="music") %>% 
   select(type,everything())

save(m_properties,file="data/m_properties.rdata")
file.rename("data/sound.png","data/music.png")

# put it all together ------------------------------------------------------------
training_data <- bind_rows(m_properties,v_properites) %>% 
   mutate(type = as.factor(type))
save(training_data,file="data/training_data.rdata")
