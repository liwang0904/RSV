# RSV_predict.R
This file plots the observed and forecasted monthly incidence rate of first-time medically attended RSV in young children (new cases per 1,000,000 person-day).

Change read file `read.csv("~/RSV/RSV1_all.csv")` (incidence rate in children ages 0 to 1) to `RSV5_all.csv` to plot the incidence rate in children ages 0 to 5.

Observed incidence rates are colored ![#f47983](https://placehold.co/15x15/f47983/f47983.png). The fitted values from 2010 January to 2019 December is a solid line colored ![#2c5d86](https://placehold.co/15x15/2c5d86/2c5d86.png). The forecasted values from 2020 January to 2023 January is a dashed line colored ![#1f415e](https://placehold.co/15x15/1f415e/1f415e.png).

## Technologies
Project is created with:
* R 4.2.2
* RStudio version 2022.12.0+353

## Installation
To run this project, install libraries from CRAN:
```
install.packages("tidyverse")
install.packages("fpp3")
install.packages("scales")
```

## Code
Incidence rates from 2010 through 2019 are used to train the model
```
rsv00 <- subset(rsv, Year >= 2010 & Year <= 2019)
rsvt <-as_tsibble(rsv00, index=M)
```
and predict forecasted values `fc_rsv <- forecast(fourier_rsv, h=37)` with an 80% confidence interval (upper bound `rsv_up`; lower bound `rsv_down`).

Vertical lines are drawn at the January of each year `jans` and at the start of the pandemic `m2020`.

## Sources
* https://otexts.com/fpp3/ Time series regression model
* https://r4ds.had.co.nz/ Tibbles
* https://www.dummies.com/article/academics-the-arts/math/statistics/how-to-calculate-a-confidence-interval-for-a-population-mean-when-you-know-its-standard-deviation-169722/ _z_* values for 80% Confidence Level
* https://stats.stackexchange.com/questions/154346/fitted-confidence-intervals-forecast-function-r mean prediction intervals for `geom_polygon`

# RSV1_all.csv and RSV5_all.csv
`Year`: 2010 to 2023

`Month`: January "1" through December "12"

`IR`: Incidence Rate
