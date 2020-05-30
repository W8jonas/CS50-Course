
/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/

#include <stdio.h>
#include <cs50.h>
#include <math.h>
#include <string.h>


int main()
{
    int counter_letter = 0;
    int counter_words = 0;
    int counter_sentendes = 0;

    string text = get_string("Text: ");

    // printf("valores, %lu ", sizeof(text));

    for (int i = 0; i < strlen(text); i++)
    {
        if ((text[i] >= 'a' && text[i] <= 'z') || (text[i] >= 'A' && text[i] <= 'Z'))
        {
            counter_letter++;
        }

        // counter_letter = text[i] != ' '
        //                 ? counter_letter + 1
        //                 : counter_letter;

        counter_words = text[i] == ' ' ? counter_words + 1 : counter_words;
                        
        counter_sentendes = (text[i] == '.' || text[i] == '!' || text[i] == '?') ? counter_sentendes + 1 : counter_sentendes;

        // printf ("\nvalores in loop: , %c %i %i %i", text[i], counter_letter, counter_words, counter_sentendes);
    }

    // In my younger and more vulnerable years my father gave me some advice that I've been turning over in my mind ever since.

    counter_words++;

    float L = (float)counter_letter * 100 / (float) counter_words;
    float S = (float) counter_sentendes * 100 / (float) counter_words;
    float index = 0.0588 * L - 0.296 * S - 15.8;

    // printf ("\n\nvalores: , %i %i %i %f\n\n", counter_letter, counter_words, counter_sentendes, index);

    if (index >= 16)
    {
        printf("Grade 16+\n");
    }
    else
    {
        if (index <= 1)
        {
            printf("Before Grade 1\n");
        }
        else
        {
            printf("Grade %i\n", (int)round(index));
        }
    }
    return 0;
}

