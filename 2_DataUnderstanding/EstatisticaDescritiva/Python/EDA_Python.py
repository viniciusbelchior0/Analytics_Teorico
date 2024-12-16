#AutoEDA - Python
pip install ydata-profiling

#carregando os pacotes
import pandas as pd
import numpy as np
from ydata_profiling import ProfileReport

#carregando os dados
dados = pd.read_csv("/content/eleicoes_jaboticabal.csv")

#verificação inicial dos dados
dados.info()

#gerando um relatório
profile = ProfileReport(dados)
profile.to_file("profile_python.html")

