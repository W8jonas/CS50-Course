from sys import argv, exit
import csv

indexDNA = ''


def getTotalSTRs(STR):
    if(STR == 'name'):
        return 0

    repeats = [0] * (len(indexDNA)+1)

    for i in range(len(indexDNA)-len(STR), -1, -1):
        if indexDNA[i:i+len(STR)] == STR:
            repeats[i] = 1 + repeats[i+len(STR)]

    return(max(repeats))


if (len(argv) != 3):
    print("Error. Usage: databases/???.csv sequences/???.txt ")
    exit()

with open(argv[2], 'r') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    for row in csv_reader:
        indexDNA = row[0]

with open(argv[1], 'r') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    counter = 0
    params = []
    data = []

    # Separando a primeira linha como parametro e o restando como dados
    for row in csv_reader:
        counter += 1
        if counter == 1:
            params = row
        else:
            data.append(row)

    # passando todos os elementos, exceto o primeiro, à função getTotalSTRs
    total_STR = list(map(getTotalSTRs, params[1:]))

    #Percorrendo array de dados e encontrando o nome correspondente
    for array in data:
        int_array = [int(value) for value in array[1:]]

        if(total_STR == int_array):
            print(array[0])
            exit()

    print('No match')
    exit()
