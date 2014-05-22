library(ggplot2)

# Set the working directory
setwd("Z:/colin/github/study/ruby/withR/ch04")

data <- read.table("price_demand.csv", header=F, sep=",")

#pdf("price_demand.pdf")
ggplot(data = data) + scale_colour_grey(name="Legend", start=0, end=0.6) +
  geom_line(aes(x  = V1, y = V2, color = "price")) +
  geom_line(aes(x  = V1, y = log2(V3)-3, color = "demand")) +
    scale_y_continuous("amount") +
    scale_x_continuous("time")
ggsave("price_demand.pdf")    
#dev.off()