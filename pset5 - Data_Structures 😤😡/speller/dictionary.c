// Implements a dictionary's functionality

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 1;

// Hash table
node *table[N];
node *root;

// Returns true if word is in dictionary else false
bool check(const char *word)
{
    // TODO
    char word[strlen(word1)];
    strcpy(word, word1);

    // ponteiro temporario
    node* current = root;
    unsigned int index;

    for (int i = 0; i < strlen(word); i++)
    {
        // standardize the letters so they're easier to index to
        word[i] = toupper(word[i]);

        // se for caractere coloca index como valor da letra o valor representado por ela no alfabeto
        if (isalpha(word[i]))
        {
            index = word[i] - 65;
        }
        // se for \ coloca index = 26
        else if (word[i] == '\'')
        {
            index = 26;
        }

        // se não existir a palavra retorne false, se não retorne is_word que é true
        if (current -> children[index] == NULL)
        {
            return false;
        }
        else
        {
            current = current -> children[index];
        }
    }

    return current -> is_word;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO
    return 0;
}

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    // TODO
    FILE *dictionaryFile = fopen(dictionary, "r");
    if (dictionaryFile == NULL)
    {
        fprintf(stderr, "Could not open dictionary.\n");
        return false;
    }

    unsigned int index = 0;

    node *new_node;

    node *current = root;  // ponteiro temporario

    root = malloc(sizeof(node))   // criado o primeiro no

    for (char c = fgetc(dictionary1); c != EOF; c = fgetc(dictionary1))
    {
        
        c = toupper(c); // coloca letra em maiúsculo

        // if it is an alphabetic character or a comma
        // go to the correct index, check if there's
        // already a node & if not, create a new one
        // if there's already a node, move to that node
    
        // Se for um caractere ou o fim de um, vá para o 
        // index correto e, se não existir um nó, crie-o. 
        // Ao final, conte mais uma palavra e volte ao início .
        if (isalpha(c) || c == '\'')
        {
            if (c == '\'')
            {
                index = 26;   // numero 26 será a '\'
            }
            else
            {
                index = c - 65;   // numero de 0 a 25 como as letras do alfabeto
            }

            // se nesse index existir um ponteiro nulo, crie um novo
            // existirá um ponteiro nulo para cada NOVA letra encontrada de cada NOVA palavra
            if (current -> children[index] == NULL) 
            {
                new_node = malloc(sizeof(node));
                if (!new_node)
                {
                    fprintf(stderr, "Couldn't create new node.\n");
                    return false;
                }

                current -> children[index] = new_node;  // current recebe o novo nó
                current = current -> children[index];   // mova para o novo nó
            }
            else
            {
                current = current -> children[index];  // vá para o próximo nó
            }
        }

        else if (c == '\n') // chegou no final da palavra?
        {
            current -> is_word = true;  // indicando que chegou no fim de uma palavra valida
            wordcounter++; // conte o total de palavras validas para a funcao size
            current = root; // volte para o começo do trie
        }
    }
    fclose(dictionary1);
    return true;
}


// Returns number of words in dictionary if loaded else 0 if not yet loaded
unsigned int size(void)
{
    // TODO
    return wordcounter;
}

// A função se chamará recursivamente até chegar no fim do trie, onde o 
// ponteiro para o próximo nó é nulo. Nesse momento irá limpar o nó
bool freeTrie(node* ptr)
{
    node* trav = ptr;

    for (int index = 0; index < 27; index++)
    {
        if (trav -> children[index] != NULL) // if there is a valid node at that index
        {
            freeTrie(trav -> children[index]); // call freeTrie
        }

    }
    free(ptr);
    return true;
}

// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    // TODO
    return freeTrie(root);
}





