# badminton-courts
badminton-courts is a database that stores prices of renting a badminton court at any hour of the week.

## tables
courts: stores court details including name, address, phone no and coordinates

days: stores 7 days of a week

prices: stores prices posted on ads by the court managements

time: stores 24 hours of a day

types: stores the types of the courts, their prices usually vary

## stored procedures
FixDay: standardize price data

## views
price-per-hour: shows price of court for every opening hour 
