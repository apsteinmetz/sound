# extract voice bits from file

library(tidyverse)
library(tuneR)
library(av)
library(soundgen)

load("data/lr_fit.rdata")

radio_file <- "data/bk_2021_01_02.wav"

segment_size = 5 #seconds
duration <- av_media_info(radio_file)$duration
segment_indices <- seq.int(1,duration,by= 5)
segment_types <- tibble(location = segment_indices,type = FALSE)

#for (n in 1:nrow(segment_types)){
for (n in 1:3){
      seg_loc <- segment_types$location[n]
   radio_data_segment <- tuneR::readWave(radio_file,
                                         from = seg_loc, 
                                         to = seg_loc+5,units = "seconds") %>% 
      tuneR::normalize(unit="32")
   seg_properties <- analyze(radio_data_segment@left,
                             radio_data_segment@samp.rate)
   voice_pred <- 
      predict(lr_fit, seg_properties,type = "prob")$.pred_voice %>% 
      mean(na.rm = TRUE)
   segment_types$type[n] <- (voice_pred > 0.5)
}

spec2cep()
