from cs50 import get_float

cash = get_float("cash: ")

while True:
    if cash >= 0:

        cents = int(cash * 100)

        c25 = int(cents / 25)
        c10 = int((cents - (c25 * 25)) / 10)
        c5 = int((cents - (c25 * 25) - (c10 * 10)) / 5)
        c1 = int(cents - (c25 * 25) - (c10 * 10) - (c5 * 5))
        print(c25 + c10 + c5 + c1)

        break
    else:
        cash = get_float("cash: ")

