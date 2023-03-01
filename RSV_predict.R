library(tidyverse)
library(fpp3)
library(scales)

rsv <-read.csv("~/RSV/RSV1_all.csv")

rsv$M  <- make_yearmonth(year=rsv$Year, month=rsv$Month)
rsv$date <-as.Date(with(rsv,paste(Year,Month,"01",sep="-")),"%Y-%m-%d")

# Data not used for training
rsv2 <- subset(rsv, Year >= 2020 )

# Training data
rsv00 <- subset(rsv, Year >= 2010 & Year <= 2019)
rsvt <-as_tsibble(rsv00, index=M)

# All the first months in a year
loga <- rsv$Month == 1
jans = rsv$date[loga]

fourier_rsv <- rsvt |>
  model(TSLM(IR ~ trend() * fourier(K = 6)))

report(fourier_rsv)

# Augmented fitted value etc
aug_frsv = augment(fourier_rsv)

# Forecasted value
fc_rsv <- forecast(fourier_rsv, h=37)

# Calculate polygon shade
xxx <-rapply(fc_rsv$IR, function(x) head(x, 1))
zzz = xxx[seq_along(xxx) %% 2 > 0]
zzz2 = xxx[seq_along(xxx) %% 2 == 0]

# 80% confidence interval
rsv_up <-  fc_rsv$.mean + 1.28 * zzz2
rsv_down <- fc_rsv$.mean - 1.28 * zzz2
poly_shade=data.frame(x=c(fc_rsv$M,rev(fc_rsv$M)), y=c(rsv_up,rev(rsv_down)) )

# Start of the pandemic (2020 January)
mth2020=make_yearmonth(year=2020, month=1)
m2020 = ymd("2020 Jan", truncated = 1)

augment(fourier_rsv) |>
  ggplot(aes(x = as.Date(M))) +
  geom_vline(xintercept=jans, size = 0.7, linetype ='dotted', color='gray')+
  geom_vline(xintercept=as.Date(m2020), size = 1, linetype ='solid', color='#70f3ff')  +
  geom_polygon(data=poly_shade, mapping=aes(x=as.Date(x), y=y * 1000000), alpha=0.2, fill = "#1f4365") +
  geom_line(data=rsv2, aes(y = IR * 1000000, colour = "Observed", linetype="Observed"), size = .75) +
  geom_line(aes(y = .fitted * 1000000, colour = "Fitted", linetype="Fitted"), size = .75) +
  geom_line(data=fc_rsv, aes(y = .mean * 1000000, colour = "Expected", linetype="Expected"), size = .75) +
  geom_point(aes(y = IR * 1000000, colour = "Observed"), size=1.5) +
  geom_point(data=rsv2, aes(y = IR * 1000000, colour = "Observed"), size = 1.5) +
  
  scale_colour_manual(
    name = "Guide1",
    values = c(Observed = "#f47983", Fitted = "#2c5d86", Expected = "#1f415e")
  ) +
  scale_linetype_manual(
    name = "Guide1",
    values = c(Observed = "dotted", Fitted = "solid", Expected = "longdash")
  ) +
  
  labs(y = "New cases per 1,000,000 person-day",
       x = "\n\nDate",
       title = "Observed and expected monthly incidence rate of first-time\nmedically attended RSV infection in young children aged 0-1: 2010-2022") +
  
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    
    panel.background = element_rect(fill = "white"),
    panel.grid.major = element_line(size = 0.7, linetype = 'solid', colour = "#EEEEEE"),
    axis.line = element_line(colour = "gray"),
    
    legend.position = "bottom",
    legend.background = element_rect(size=0.7, linetype="solid", colour ="gray"),
    legend.title=element_blank(),
    legend.key.width = unit(1.9, 'cm'),
    
    plot.title = element_text(size=26),
    axis.text.y = element_text(size=12),
    axis.text.x = element_text(size=12),
    axis.title = element_text(size=18),
    legend.text = element_text(size=20)
  ) +
  
  scale_shape_manual("", values=c(17,17,16,16)) +
  scale_x_date(limits = c(as.Date("2009-11-01"), as.Date("2023-03-01")), date_breaks = "3 months", date_labels = "%b", expand = c(0.0001, 0.0001))
