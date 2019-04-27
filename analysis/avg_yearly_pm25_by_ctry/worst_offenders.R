# don't do this
# setwd("~/git/hub/openaq-april2019-datadive/analysis/avg_yearly_pm25_by_ctry")

library(readr)
library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)

worst <- read_csv('./worst_offenders.csv')
worst

worst_rank <- worst %>%
    tidyr::gather('year', 'country', -rank) %>%
    dplyr::mutate(year = stringr::str_remove(year, 'y'),
                  flag = ifelse(country %in% c('BD-Bangladesh', 'MN-Mongolia', 'IN-India', 'NP-Nepal', 'BH-Bahrain'),
                                TRUE, FALSE),
                  country_col = if_else(flag == TRUE, country, "zzz")
                  )

# bump chart: https://www.r-bloggers.com/bump-chart/
ggplot(data = worst_rank, aes(x = as.numeric(year), y = rank, group = country)) +
    theme_minimal() +
    coord_cartesian(clip = "off", xlim = c(2015.9, 2020)) + # make the x axis wider so text does not clip
    geom_line(aes(color = country_col), alpha = 1, size = 2) +
    geom_point(aes(color = country_col), alpha = 1, size = 4) +
    # text on the right
    geom_text(data = worst_rank %>% filter(year == "2019"),
              aes(label = country, x = 2019.1) ,
              hjust = 0, fontface = "bold", color = "#888888", size = 4) +
    # text on the left
    geom_text(data = worst_rank %>% filter(year == 2016),
              aes(label = stringr::str_remove(country, '-.*'), x = 2015.9) ,
              hjust = 1, fontface = "bold", color = "#888888", size = 4) +

    scale_y_continuous(breaks = 1:nrow(worst_rank)) +
    scale_color_manual(values = c("#F70020","#191A1A","#FB9701","#1A7D00","#072C8F","grey")) +
    labs(x = "Year",
       y = "Airquality Rankings (10 is the worst)",
       title = "Top 10 Worst PM2.5 Countries",
       subtitle = "Average yearly pm2.5 values") +
    theme(legend.position = "none"
          ) +
    NULL

ggsave('top_10_pm25.png', height = 8, width = 13)
