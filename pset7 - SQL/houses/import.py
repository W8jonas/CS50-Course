from sys import exit, argv
from csv import reader, DictReader
from cs50 import SQL

if (len(argv) != 2):
    print("Error. Usage: characters.csv ")
    exit()

db = SQL("sqlite:///students.db")

with open(argv[1]) as csv_file:
    csv_rows = DictReader(csv_file)
    for row in csv_rows:

        name = row['name'].split()

        if(len(name) == 2):
            first = name[0]
            middle = None
            last = name[1]
        else:
            first = name[0]
            middle = name[1]
            last = name[2]

        house = row['house']
        birth = row['birth']

        db.execute('INSERT INTO students (first, middle, last, house, birth) VALUES(?, ?, ?, ?, ?)', first, middle, last, house, birth)
