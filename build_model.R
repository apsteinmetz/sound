# build model
library(tidyverse)
library(tidymodels)
library(dotwhisker)

load("data/training_data.rdata")

# clean up data
dataset <- training_data %>% 
   # not relevant
   select(-duration,-duration_noSilence) %>%
   # redundant
   select(-contains("voiced"))



set.seed(666)
# Put 3/4 of the data into the training set 
data_split <- initial_split(dataset, prop = 3/4)

# Create data frames for the two sets:
train_data <- training(data_split)
test_data  <- testing(data_split)

lr <-logistic_reg() %>% 
   set_engine("glm") %>% 
   set_mode("classification") %>% 
   translate()

data_rec <- recipe(type ~ .,data = train_data)

data_wf <- workflow() %>% 
   add_model(lr) %>% 
   add_recipe(data_rec)
   

lr_fit <- data_wf %>% 
   fit(data = train_data)

#View(tidy(lr_fit))

#tidy(lr_fit) %>% 
#   dwplot(dot_args = list(size = 2, color = "black"),
#          whisker_args = list(color = "black"),
#          vline = geom_vline(xintercept = 0, colour = "grey50", linetype = 2))

voice_pred <- 
   predict(lr_fit, test_data, type = "prob") %>% 
   bind_cols(test_data %>% select(type))

voice_pred %>% 
   roc_auc(truth = type, .pred_music)

voice_pred %>% 
   roc_curve(truth = type, .pred_music) %>% 
   autoplot()
