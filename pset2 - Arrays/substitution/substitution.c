#include <stdio.h>
#include <cs50.h>
#include <math.h>
#include <string.h>
#include <ctype.h>

// VCHPRZGJNTLSKFBDQWAXEUYMOI
// VCHPRZGJNTLSKFBDQWAXEUYMOI
// VCHPRZGJNTLSKFBDQWAXEUYMOI
// VCHPRZGJNTLSKFBDQWAXEUYMOI

int testKey(string key)
{
    // printf("\n\nHI\n\n");
    for (int i = 0; i < strlen(key); i++)
    {
        // printf("key %c \n", key[i]);
        if (!((key[i] >= 'a' && key[i] <= 'z') || (key[i] >= 'A' && key[i] <= 'Z')))
        {
            // printf("key pasou no if %c \n", key[i]);
            return 1;
        }
        
        for (int k = 0; k < strlen(key); k++)
        {
            for (int j = 0; j < strlen(key); j++)
            {
                if (key[k] == key[j] && k != j)
                {
                    // printf("____________________key pasou no if %c \n", key[k]);
                    return 1;
                }
            }
        }

    }
    return 0;
}

// VCHPRZGJNTLSKFBDQWAXEUYMOI
int main(int argc, string argv[])
{
    string text = "VCHPRZGJNTLSKFBDQWAXEUYMOI";

    if (argc != 2)
    {
        printf("Usage: ./substitution key");
        return 1;
    }
    else 
    {
        if (strlen(argv[1]) != 26)
        {
            return 1;
        }

        text = argv[1];

        for (int i = 0; i < strlen(text); i++)
        {
            text[i] = toupper(text[i]);
        }

        if (testKey(text))
        {
            printf("Key must contain 26 characters.\n");
            return 1;
        }
    }

    string plaintext = get_string("plaintext: "); 
    string ciphertext = plaintext;

    int j = 0;


    for (int i = 0; i < strlen(plaintext); i++)
    {
        j = (int)plaintext[i];


        if (plaintext[i] >= 'a' && plaintext[i] <= 'z')
        {
            // printf("antes no ELSE %c %c \n", text[j-97], text[j-97]+32);
            ciphertext[i] = text[j - 97];
            ciphertext[i] = ciphertext[i] + 32;;
        }
        else
            // printf("antes no ELSE %c %c \n", text[j-97], text[j-97]+32);
            // printf("antes no ELSE %c %c \n", text[j-97], text[j-97]+32);
        {
            if (plaintext[i] >= 'A' && plaintext[i] <= 'Z')
            {
                ciphertext[i] = text[j - 65];
            }
            else
            {
                ciphertext[i] = plaintext[i];
            }
        }
        // printf("antes no ELSE %c %c \n", text[j-97], text[j-97]+32);
        // printf("antes no ELSE %c %c \n", text[j-97], text[j-97]+32);
        // printf("%i, %c, %c \n", j-65, plaintext[i], ciphertext[i]);
    }
    
    printf("ciphertext: %s\n", ciphertext);
    
    return 0;
}

