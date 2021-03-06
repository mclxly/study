library(ggplot2)

# Set the working directory
setwd("Z:/colin/github/study/ruby/withR/ch04")

data <- read.table("demand_supply.csv", header=F, sep=",")

#pdf("demand_supply.pdf")
ggplot(data = data) + scale_colour_grey(name="Legend", start=0, end=0.6) +
  geom_line(aes(x  = V1, y = V2, color = "demand")) +
  geom_line(aes(x  = V1, y = V3, color = "supply")) +
  scale_y_continuous("amount") +
  scale_x_continuous("time")
ggsave("demand_supply.pdf")  
#dev.off()
