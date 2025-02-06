# Genetyka Ewolucyjna i Populacyjna, ćwiczenia 2
# stwórz wykresy na podstawie plików .bcf:
  # 1) quality
  # 2) mapping quality
  # 3) depth of coverage

stats <- read.table("Stats_QualMQDP.txt", 
                    col.names = c("QUAL", "MQ", "DP")) # nadaj nazwy kolumnom

# wersja podstawowa: base R graphics:
hist(stats$QUAL)
hist(stats$MQ)
hist(stats$DP)

# przedstaw 3 zmienne na jednym wykresie:
  # stwórz nowy zestaw danych w formacie długim (long format): pierwsza kolumna zawiera wartość, a druga nazwę zmiennej

library(tidyr) # wczytaj paczkę do manipulacji danymi. Jesli jest taka potrzeba, zainstaluj ją komendą install.packages("tidyr")

pivot_longer(stats, # pod nazwą stats_longer,
             cols = c("QUAL", "MQ", "DP"), # wybierz zmienne do długiego formatu (u nas- wszystkie) 
             names_to = "zmienna",  # nazwa kolumny z nazwą zmiennej
             values_to = "wartość") # nazwa kolumny z wartością zmiennej

# zapisz output jako stats_longer
stats_longer <- pivot_longer(stats, # pod nazwą stats_longer,
                             cols = c("QUAL", "MQ", "DP"), # wybierz zmienne do długiego formatu (u nas- wszystkie) 
                             names_to = "zmienna",  # nazwa kolumny z nazwą zmiennej
                             values_to = "wartość") # nazwa kolumny z wartością zmiennej

# użyjemy biblioteki ggplot2 do generowania wykresu. Jesli jest taka potrzeba, zainstaluj ją komendą install.packages("ggplot2")
library(ggplot2) 

ggplot(stats_longer, # nazwa danych
        aes(wartość)) + # na wykresie naniesiemy tylko zmienną wartość
  geom_histogram() + # rysowanie histogramu
  facet_wrap(~zmienna, # na osobnych panelach przedstaw osobno wartości z kolumny "zmienna"
             nrow = 3) # użyj 3 osobnych wierszy
             
# zauważ, że dla wszystkich paneli wartość na osi X jest taka sama, co utrudnia odczytanie informacji. Zmienimy to dodając parametr scales = "free_x"
ggplot(stats_longer,
       aes(wartość)) + 
  geom_histogram() + 
  facet_wrap(~zmienna, 
             nrow = 3, 
             scales = "free_x") # oś X może przyjmować różne wartości dla każdego panelu

# upiększ wykres
ggplot(stats_longer,
       aes(wartość)) + 
  geom_histogram() + 
  facet_wrap(~zmienna, 
             nrow = 3, 
             scales = "free_x") +
  theme_bw() + # zmiana parametrów graficznych
  ggtitle("BCF file, individual A")

# zapisz wykres jako my_plot
my_plot < ggplot(stats_longer,
                 aes(wartość)) + 
  geom_histogram() + 
  facet_wrap(~zmienna, 
             nrow = 3, 
             scales = "free_x") +
  theme_bw() + # zmiana parametrów graficznych
  ggtitle("BCF file, individual A")

ggsave("Stats_QualMQDP_INDV_NAME.png", 
       width = 5, # szerokość (domyślnie w calach, możesz zmienić na cm dodając opcję units = "cm")
       height = 4) # wysokość
