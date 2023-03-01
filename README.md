# RSV1_all.csv and RSV5_all.csv
`Year`: 2010 to 2023

`Month`: January "1" through December "12"

`IR`: Incidence Rate

# RSV_predict.R
This file plots the observed and forecasted monthly incidence rate of first-time medically attended RSV in young children (new cases per 1,000,000 person-day).

Change read file `read.csv("~/RSV/RSV1_all.csv")` (incidence rate in children ages 0 to 1) to `RSV5_all.csv` to plot the incidence rate in children ages 0 to 5.

Observed incidence rates are colored ![#f47983](https://placehold.co/15x15/f47983/f47983.png). The fitted values from 2010 January to 2019 December is a solid line colored ![#2c5d86](https://placehold.co/15x15/2c5d86/2c5d86.png). The forecasted values from 2020 January to 2023 January is a dashed line colored ![#1f415e](https://placehold.co/15x15/1f415e/1f415e.png).

## Technologies
Project is created with:
* R 4.2.2
* RStudio version 2022.12.0+353

## Sources
* Harrell, F. E. (2015). _Regression modeling strategies: With applications to linear models, logistic and ordinal regression, and survival analysis_ (2nd ed). Springer.
* Ord, J. K., Fildes, R., & Kourentzes, N. (2017). _Principles of business forecasting_ (2nd ed.). Wessex Press Publishing Co.
* Sheather, S. J. (2009). _A modern approach to regression with R._ Springer. 
