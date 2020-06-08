from sys import argv
import csv

def getTotalSTRs(STR):
    if(STR == 'name'):
        return 0

    with open(argv[2], 'r') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        for row in csv_reader:
            print(row[0].find(STR))

    return 1 + 1


while True:
    if (len(argv) != 2):
        print("Error. Usage: databases/?.csv sequences/?.txt ")
        break

    with open(argv[1], 'r') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        counter = 0
        params = []
        data = []

        for row in csv_reader:
            counter += 1
            if counter == 1:
                params = row
            else:
                data.append(row)

        print(params)
        print(data)

        # passando todos os elementos, exceto o primeiro, à função getTotalSTRs
        total_STR = list(map(getTotalSTRs, params[1:]))

        break

