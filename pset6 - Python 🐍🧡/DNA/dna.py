from sys import argv
import csv

while True:
    if (len(argv) != 2):
        print("Error. Usage: databases/?.csv sequences/?.txt ")
        break

    print(argv[1])

    with open(argv[1], 'r') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        for row in csv_reader:
            print(row)
        break

