library(tidyverse)
library(readxl)
library(dplyr)
library(writexl)
library(stringr)

#exportación
CUMPLIS <- read_xlsx("C:/Users/natva/OneDrive/Escritorio/AGC_DATOS/Exportaciones/Asignaciones161222.xlsx", sheet = "Cumplimientos")

#filtro y renombrado de columnas
CUMPLIS_avo <- CUMPLIS %>% select("Fecha", "DEN", "N Denuncia", "Tkt Área", "SGO a la que se planifica", "Motivo 2do tkt") %>%
  rename(NSUACI='N Denuncia') %>%
  rename(SGO='SGO a la que se planifica')%>%
  rename(MotivoReinspecc='Motivo 2do tkt')%>%
  filter(Fecha > '2022-10-01')

#conteo de DEN repetidos, filtro de los que aparecen una sola vez
n_occur <- data.frame(table(CUMPLIS_avo$DEN))
n_occur <-n_occur %>%
  rename ('DEN' = "Var1")
n_occur <-n_occur %>% filter ( Freq > 1)

#union de ambas planillas
DEN_avo <- left_join (n_occur, CUMPLIS_avo, BY=DEN)

#filtro para casos de AVO
DEN_avo <- DEN_avo %>%
  filter(SGO == "DGFYCO - AVO")



write_xlsx(x = DEN_avo ,path = 'C:/Users/natva/OneDrive/Escritorio/AGC_DATOS/RESULTADOS_CONTROLES/DEN_avo_OCTDIC.xlsx')
