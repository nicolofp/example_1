# Prova di applicazioni con il pacchetto dplyr
# Carico le librerie utili alla spiegazione
library(dplyr)
library(timeSeries)
library(data.table)

# Creiamo un dataset di prova e trasformiamolo in tibble
# formato digeribile da dplyr
x <- data.frame(nome=replicate(200,paste0(sample(LETTERS,5,replace = T),collapse = "")),
                id_letters=sample(letters,200,replace = T),
                value1=rnorm(200,12,4),
                value2=rnorm(200,12,4))
x <- rbind(x,x)
x <- as_tibble(x)

# Proviamo a vedere come funziona la distinct [elimino i duplicati delle righe selezionate]
# nel caso volessi tutta la base dati metterei ".keep_all = T" come primo argomento 
# del distinct
x %>%
  distinct(.keep_all = T)

# Aggiungere una colonna valorizzata solo per alcuni campi [il ":=" del data.table]
x %>%
  mutate(selezione = ifelse(id_letters=='g',1,NA)) 

# A differenza del data.table qui si può applicare una funzione per riga e colonna
# Colonna
x %>% mutate(sum_value1 = cumsum(value1))
# Riga
x %>% mutate(sum_row = rowSums(.[3:4]))

# Per effettuare operazioni sui gruppi si deve dapprima creare il gruppo e poi 
# eliminarlo
x %>%
  group_by(id_letters) %>%
  mutate(selezione = ifelse(value1==min(value1) | value1==max(value1),
                            1,0)) %>%
  ungroup(id_letters) %>%
  arrange(id_letters) %>% # per riordinare una variabile
  print(n = 50)           # per vedere le prime 50 righe

# Per eliminare le colonne che non desidero basta selezionarle con 
# una select con il meno davanti
x %>% 
  select(-c(2,4)) %>%
  arrange(value1)  %>%
  pull(value1)







