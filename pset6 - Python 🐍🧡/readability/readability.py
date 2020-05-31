from cs50 import get_string

text = get_string("text: ")

counter_letter = 0
counter_words = 0
counter_sentendes = 0

text = text.lower()

counter_letter = len(text.replace(' ', '').replace('!', '').replace('?', '').replace("'", "").replace('.', '').replace(',', ''))
counter_words = len(text.split(' '))
counter_sentendes = len(text.replace('!', '.').replace('?', '.').split('.')) - 1

L = float(counter_letter) * 100 / float(counter_words)
S = float(counter_sentendes) * 100 / float(counter_words)
index = 0.0588 * L - 0.296 * S - 15.8

if (index >= 16):
    print("Grade 16+\n")

else:
    if (index <= 1):
        print("Before Grade 1\n")
    else:
        print(f"Grade {int(index + 0.5)}\n")
