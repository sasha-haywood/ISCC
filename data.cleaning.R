library(dplyr)
library(tidyr)
library(stringr)
library(readxl)
library(xlsx)

data = read.delim("17statetypepu.txt", header = F, sep = "")
# IL=14, IN=15, MI=23, OH=36, WI=50
# 1=State and local government total
# 2=State, 3=Local, 4=County, 5=City/Municipality, 6=Township, 7=Special, 8=School
data = data[,1:3]
colnames(data) = c("a", "item", "amount")
data$a = str_pad(data$a, 3, pad = "0")
data = separate(data, a, c("ID", "type"), sep=2)

states = read_excel("government_ids.xls")
states = separate(states, `ID Code`, c("ID", "garbage"), sep = 2)
states = states[,1:2]

data = right_join(states, data)

govt = c("Total", "State", "Local", "County", "City", "Township", "Special", "School")

type = data.frame(type=c("1", "2", "3", "5", "6", "7", "8", "9"), govt=govt)

data = right_join(type, data)

itemcodes = read_excel("itemcodesUpdated.xls")
colnames(itemcodes) = c("item", "description")

data = right_join(itemcodes, data)

clean.data = data[,c(1, 2, 5, 4, 7)]

il = clean.data %>%
  filter(State == "Illinois")
il = il[,-3]
il = spread(il, govt, amount)
write.table(il, "IL.csv", sep="\t", row.names = F)

ind = clean.data %>%
  filter(State == "Indiana")
ind = ind[,-3]
ind = spread(ind, govt, amount)
write.table(ind, "IN.csv", sep="\t", row.names = F)

mi = clean.data %>%
  filter(State == "Michigan")
mi = mi[,-3]
mi = spread(mi, govt, amount)
write.table(mi, "MI.csv", sep="\t", row.names = F)

oh = clean.data %>%
  filter(State == "Ohio")
oh = oh[,-3]
oh = spread(oh, govt, amount)
write.table(oh, "OH.csv", sep="\t", row.names = F)

wi = clean.data %>%
  filter(State == "Wisconsin")
wi = wi[,-3]
wi = spread(wi, govt, amount)
write.table(wi, "WI.csv", sep="\t", row.names = F)
