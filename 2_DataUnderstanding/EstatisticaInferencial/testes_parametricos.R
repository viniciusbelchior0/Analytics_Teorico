library(haven)
library(car)

Production_Farming <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-09/Production_FarmingEquipment.dta")
CustomerServices <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-09/CustomerServices_Store.dta")
CustomerServices$store <- as.factor(CustomerServices$store)

Ttest_two_ind <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-09/T_test_Two_Independent_Samples.dta")
Ttest_two_ind$supplier <- as.factor(Ttest_two_ind$supplier)

Ttest_two_pair <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-09/T_test_Two_Paired_Samples.dta")

Anova_oneway <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-09/One_Way_ANOVA.dta")
Anova_oneway$supplier <- as.factor(Anova_oneway$supplier)

Anova_twoway <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-09/Two_Way_ANOVA.dta")
Anova_twoway$companie <- as.factor(Anova_twoway$companie)
Anova_twoway$day_of_the_week <- as.factor(Anova_twoway$day_of_the_week)

# TESTES DE NORMALIDADE E HOMOGENEIDADE DE VARIANCIAS####
# O principal teste de normalidade e o de Shapiro-Wilk
# KS
hist(Production_Farming$production)
ks.test(Production_Farming$production, "pnorm", mean(Production_Farming$production),sd(Production_Farming$production))

# SW
shapiro.test(Production_Farming$production)

# SF
sf.test(Production_Farming$production) #pacote nortest


# TEstes de Variancia

# Histograma
ggplot(CustomerServices) +
 aes(x = customer_services, fill = store) +
 geom_density(adjust = 1L) +
 scale_fill_hue(direction = 1) +
 theme_gray()

# Violin Plot
ggplot(CustomerServices) +
 aes(x = "", y = customer_services, fill = store) +
 geom_violin(adjust = 1L, 
 scale = "area") +
 scale_fill_hue(direction = 1) +
 theme_gray()

# teste f compara apenas dois grupos

#Bartlett
bartlett.test(customer_services ~ store, data = CustomerServices)

#Levene
leveneTest(customer_services ~ store, data = CustomerServices)

# TESTES PARAMETRICOS####

#1. Teste-T para amostras independentes

ggplot(Ttest_two_ind) +
 aes(x = "", y = time, fill = supplier) +
 geom_boxplot() +
 scale_fill_hue(direction = 1) +
 theme_gray()

ggplot(Ttest_two_ind) +
 aes(x = time, fill = supplier) +
 geom_density(adjust = 1L) +
 scale_fill_hue(direction = 1) +
 theme_gray()

# Verificando a normalidade e a homogeneidade = os dados respeitam ambas condicoes    
shapiro.test(Ttest_two_ind$time)
leveneTest(time ~ supplier, data = Ttest_two_ind)

t.test(time ~ supplier, data = Ttest_two_ind, var.equal = TRUE)


#2. Teste-T para amostras dependentes
t.test(Ttest_two_pair$before, Ttest_two_pair$after, paired = TRUE)


#3. ANOVA One-Way

library(ggplot2)

ggplot(Anova_oneway) +
 aes(x = "", y = sucrose, fill = supplier) +
 geom_boxplot() +
 scale_fill_hue(direction = 1) +
 theme_gray()

ggplot(Anova_oneway) +
 aes(x = sucrose, fill = supplier) +
 geom_density(adjust = 1L) +
 scale_fill_hue(direction = 1) +
 theme_gray()

model <- aov(sucrose ~ supplier, data = Anova_oneway)
model
summary(model)

#Testando as premissas
plot(model, 1)
leveneTest(sucrose ~ supplier, data = Anova_oneway)
plot(model,2)
shapiro.test(resid(model))

#Teste de Tukey para avaliar quais medias sao diferentes
#pelo exemplo: nao ha diferenca entre as medias de 3-2
#h0: nao ha diferenca entre medias
TukeyHSD(model)

#4. Anova Two-way
# Additive model (two factor variables are independent)
model2 <- aov(time ~ companie + day_of_the_week, data = Anova_twoway)
model2
summary(model2)

# Multiplicative model
model3 <- aov(time ~ companie * day_of_the_week, data = Anova_twoway)
model3
summary(model3)

# avaliando o modelo aditivo
TukeyHSD(model2)

#Testando as premissas
plot(model2, 1)
leveneTest(time ~ companie * day_of_the_week, data = Anova_twoway)
plot(model2,2)
shapiro.test(resid(model2))
