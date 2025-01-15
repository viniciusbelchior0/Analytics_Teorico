# abrindo varios arquivos no python e juntando eles (append/ bindrows)

import pandas as pd
import numpy as np
import glob

#funcao para fazer isso
path = r'Users\data'
all_files = glob.glob(path + "/*.csv")

li = []

for filename in all_files:
    df = pd.read_csv(filename, index_col =None, header=0)
    li.append(df)

frame = pd.concat(li, axis = 0, ignore_index=True)

#conferindo o resultado
frame.info()
frame = frame.round(decimals=2) # se necessario arredondar casas decimais, para nao ter problema na hora de converter para csv
frame.to_csv(r'=Users\dados_agregados_virgula.csv', index=False, sep = ";",decimal = ",")
