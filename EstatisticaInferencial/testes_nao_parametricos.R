library(haven)
library(tidyverse)
library(BSDA)
library(nonpar)

SignTest_one <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-10/Sign_Test_One_Sample.dta")
SignTest_two <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-10/Sign_Test_Two_Paired_Samples.dta")
McNemar <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-10/McNemar_Test.dta")
Wilcoxon <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-10/Wilcoxon_Test.dta")
ChiSquared <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-10/Chi-Square_k_Independent_Samples.dta")
MannWhitney <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-10/Mann-Whitney_Test.dta")
CochranQ <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-10/Cochran_Q_Test.dta")
Friedman <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-10/Friedman_Test.dta")
KruskallWallis <- read_dta("C:/Users/NOTEBOOK CASA/Downloads/Dados_Favero/Chapter-10/Kruskal-Wallis_Test.dta")

# Teste dos sinais
SIGN.test(SignTest_one$age, md = 65) #pacote BSDA

# Teste dos sinais emparelhados
SIGN.test(SignTest_two$before, SignTest_two$after, md = 0, alternative = "two.sided")

# Teste de McNemar
mcnemar.test(McNemar$before, McNemar$after)

# Teste de Wilcoxon
wilcox.test(Wilcoxon$before, Wilcoxon$after, correct = FALSE, alternative = "two.sided", paired = TRUE)

# Teste de Mann-Whitney
wilcox.test(diameter ~ machine, data = MannWhitney, exact = FALSE)

# Teste Q de Cochran
CochranQ_st <- cbind(CochranQ$a, CochranQ$b, CochranQ$c)

cochrans.q(CochranQ)

# Teste de Friedman
Friedman$N <- c(1:15)
Friedman_st <- pivot_longer(Friedman, cols = c(1,2,3), names_to = "Treatment", values_to = "Weight")

friedman.test(Friedman_st$Weight, groups = Friedman_st$Treatment, blocks = Friedman_st$N)

# Teste Qui-Quadrado para multiplas amostras independentes
chisq.test(ChiSquared$shift, ChiSquared$productivity)

# Teste de Kruskal-Wallis
kruskal.test(result ~ treatment, data = KruskallWallis)
