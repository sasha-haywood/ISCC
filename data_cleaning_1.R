# ISCC Project 210004: Killian, Larita Local Govt Census Data
#1st revision January 26, 2021
#2nd revision January 27, 2021
#3rd revision January 29, 2021

#Primary consultants: Haywood, Sasha and Yoder, Jeff

#Client is interested in local government data for the NW Territory States
#(IL=Illinois, IN=Indiana, MI=Michigan, OH=Ohio, WI=Wisconsin)
#Needs help cleaning the data to put it in a readable spreadsheet table

library(dplyr)
library(tidyr)
library(stringr)
library(readxl)
#library(xlsx)

#State Codes:
# IL=14, IN=15, MI=23, OH=36, WI=50
#Government Codes
#0 Federal government
# 1=State and local government total
# 2=State, 3=Local total, 5=County, 6=City/Municipality, 7=Township, 
#8=Special, 9=School

old_directory = getwd()
setwd('I:\\Students\\Clients\\Killian, Larita\\210004_Census_Data_Local_Govt\\Working')

rev = read.delim("17statetypepu.txt", header = F, sep = "")

#select the columns of interest
rev = rev[,1:3]

#separate state and local gov IDs
colnames(rev) = c("a", "item", "amount")
rev$a = str_pad(rev$a, 3, pad = "0")
rev = separate(rev, a, c("ID", "type"), sep=2)

#get the state IDS
states = read_excel("government_ids.xls")
states = separate(states, `ID Code`, c("ID", "garbage"), sep = 2)
states = states[,1:2]


rev = right_join(states, rev, by = 'ID')

#get the government codes 
govt = c("Fed", "Total", "State", "Local", "County", "City", "Township", "Special", "School")
type = data.frame(type=c("0", "1", "2", "3", "5", "6", "7", "8", "9"), govt=govt)

rev = right_join(type, rev, by = 'type')
rev = unite(rev, "State_Type", c(3, 2))

#get revenue code descriptions
itemcodes = read_excel("itemcodesUpdated.xls")
colnames(itemcodes) = c("item", "description")
rev = right_join(itemcodes, rev, by = 'item')

#get columns without state ID
clean.rev = rev[,c(1, 2, 4, 6)]

all.states = spread(clean.rev, "State_Type", amount)

#Fill NA's with Blanks
all = as.data.frame(all.states)
all[is.na(all)] = ''

write.csv(all, "Killian.csv", sep = " ", row.names = F)
