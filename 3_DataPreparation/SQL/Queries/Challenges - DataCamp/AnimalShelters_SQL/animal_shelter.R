library(tidyverse)


age_costs <- read.csv("C:\\Users\\NOTEBOOK CASA\\Desktop\\Data Analyst Certification\\SQL Certifications\\AnimalShelters_SQL\\Animal Shelters_ SQL Certification\\datasets\\age_costs.csv")
location_costs <- read.csv("C:\\Users\\NOTEBOOK CASA\\Desktop\\Data Analyst Certification\\SQL Certifications\\AnimalShelters_SQL\\Animal Shelters_ SQL Certification\\datasets\\location_costs.csv")
size_costs <- read.csv("C:\\Users\\NOTEBOOK CASA\\Desktop\\Data Analyst Certification\\SQL Certifications\\AnimalShelters_SQL\\Animal Shelters_ SQL Certification\\datasets\\size_costs.csv")
sponsored_animals <- read.csv("C:\\Users\\NOTEBOOK CASA\\Desktop\\Data Analyst Certification\\SQL Certifications\\AnimalShelters_SQL\\Animal Shelters_ SQL Certification\\datasets\\sponsored_pets.csv")
animals <- read.csv("C:\\Users\\NOTEBOOK CASA\\Desktop\\Data Analyst Certification\\SQL Certifications\\AnimalShelters_SQL\\Animal Shelters_ SQL Certification\\datasets\\animal_data.csv")

location_costs <- location_costs %>% rename(location_costs = costs)
size_costs <- size_costs %>% select(1,3,4) %>% rename(size_costs = costs)
animals$birthdate <- as.Date(animals$birthdate, format = "%m/%d/%Y")
age_costs <- age_costs %>% rename(age_costs = costs)

# Unindo as tabelas e obtendo variáveis
df <- anti_join(animals, sponsored_animals, by = c("animalid" = "sponsorid"))
df <- left_join(df, location_costs, by = "location")

df <- df %>% mutate(age = difftime(as.Date("12/31/2021", format = "%m/%d/%Y"),birthdate, unit = "days"),
                    sizeid = case_when(animaltype == "Dog" & weight <= 10.0 ~ "DS",
                                       animaltype == "Dog" & weight >10.0 & weight <= 30.0 ~ "DM",
                                       animaltype == "Dog" & weight > 30.0 ~ "DL",
                                       animaltype == "Cat" & weight <= 5.0 ~ "CS",
                                       animaltype == "Cat" & weight > 5.0 & weight <= 7.0 ~ "CM",
                                       animaltype == "Cat" & weight > 7.0 ~ "CL",
                                       animaltype == "Bird" & weight <= 0.7 ~ "BS",
                                       animaltype == "Bird" & weight > 0.7 & weight <= 1.1 ~ "BM",
                                       animaltype == "Bird" & weight > 1.1 ~ "BL",
                                       TRUE ~ "Other"))

df$age <- round(as.numeric(df$age)/360, digits = 0)

df <- left_join(df, age_costs, by = "age")
df <- left_join(df, size_costs, by = "sizeid")

# Obtendo as agregações

tabela_final <- df %>% group_by(animaltype, size) %>%
  summarise(count = n(),
            total = sum(location_costs + age_costs + size_costs)) %>%
  ungroup() %>%
  mutate(percentage = round((total/sum(total)) * 100,2)) %>%
  arrange(animaltype, desc(size))



