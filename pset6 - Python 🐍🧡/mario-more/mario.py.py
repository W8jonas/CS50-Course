from cs50 import get_int

height = get_int("Height: ")

while True:
    if height > 0 and height <= 8:
        for i in range(1, height + 1):
            num_hashes = i
            num_spaces = height - num_hashes

            print(" " * num_spaces, end="")
            print("#" * num_hashes, end="")
            print("  ", end="")
            print("#" * num_hashes)
        break
    else:
        height = get_int("Height: ")

