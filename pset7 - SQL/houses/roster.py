from sys import exit, argv
from csv import reader, DictReader
from cs50 import SQL

if (len(argv) != 2):
    print("Error.  Usage: python roster.py Gryffindor ")
    exit()

db = SQL("sqlite:///students.db")

students = db.execute("SELECT * FROM students WHERE house = (?) ORDER BY last", argv[1])

for student in students:

    first = student['first']
    middle = student['middle']
    last = student['last']
    birth = student['birth']

    if(middle):
        print(f"{first} {middle} {last}, born {birth}")
    else:
        print(f"{first} {last}, born {birth}")
