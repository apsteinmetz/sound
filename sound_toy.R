# play with sound files
# goal is to extract mic breaks in a recording of a radio show

library(tidyverse)
library(tuneR)
library(seewave)
library(av)
library(soundgen)

vf <- "data/bk_train_voice.mp3"
mf <- "data/bk_train_music.mp3"

train_voice_raw <- tuneR::readMP3(vf) %>% normalize()
voice_melfcc <- train_voice_raw %>% melfcc()

train_music_raw <- tuneR::readMP3("data/bk_train_music.mp3") %>% normalize()


seewave::spectro(train_music_raw, flim = c(0,2),fastdisp = TRUE)
seewave::spectro(train_voice_raw, flim = c(0,2),fastdisp = TRUE)

av_media_info(mf)
wonderland <- system.file('samples/Synapsis-Wonderland.mp3', package='av')
pcm_data <- read_audio_bin(vf, channels = 1, end_time = 2.0)
plot(pcm_data, type = 'l')
fft_data <- read_audio_fft(vf,end_time = 5.0)
fft_data_m <- read_audio_fft(mf,start_time = 200, end_time = 205)

readWave()

v_properties <-soundgen::analyze(vf)
save(v_properties,file="data/v_properties.rdata")
m_properties <-soundgen::analyze(mf)
save(m_properties,file="data/m_properties.rdata")


# Get 60 seconds of wave in 5 second blocks

get_wave_subset <- function(wave_obj,desired_secs = 60,segment_secs = 5){
   segment_count <- round(desired_secs,segment_secs)
   start_points <- seq.int(0, length(wave_obj),)
   for (n in 0:segment_count){
      segment <- wave_obj[]
   }
}