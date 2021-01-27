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
data = unite(data, "State_Type", c(3, 2))

itemcodes = read_excel("itemcodesUpdated.xls")
colnames(itemcodes) = c("item", "description")

data = right_join(itemcodes, data)

clean.data = data[,c(1, 2, 4, 6)]

all.states = spread(clean.data, "State_Type", amount)

write.table(all.states, "Killian.csv", sep="\t", row.names = F)
