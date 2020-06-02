// Implements a dictionary's functionality

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <strings.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 26;

// Hash table
node *table[N];
int totalWords = 0;

// Returns true if word is in dictionary else false
bool check(const char *word)
{
    node *cursor = table[hash(word)];

    
    if (strcasecmp(cursor->word, word) == 0) //comparando palavras sem distinção de letras maiúsculas
    {
        return true;
    }

    // mantenha o loop enquanto não chegar no fim
    while (cursor->next != NULL)
    {
        cursor = cursor->next;
        if (strcasecmp(cursor->word, word) == 0)
        {
            return true;
        }
    }

    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO
    int n = (int) tolower(word[0]) - 97;
    return n;
}

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    FILE *file = fopen(dictionary, "r");  // abre o dicionario e armazena em file
    char *dictWord = malloc(LENGTH);
    if (dictWord == NULL)  // testa se conseguiu espaco na memoria para dictWord
    {
        return false;
    }
    
    while (fscanf(file, "%s", dictWord) != EOF) // leia o arquivo até o fim
    {
        node *n = malloc(sizeof(node)); // alocando ponteiro para nó
        if (n == NULL)
        {
            return false;
        }

        strcpy(n->word, dictWord); // copiando a palavra para o nó e contanto o total de palavras
        totalWords++;

        n->next = table[hash(dictWord)]; // colocando next apontando para o próximo nó

        table[hash(dictWord)] = n; // colocando array apontando para n
    }

    fclose(file);
    free(dictWord);
    return true;
}


// Returns number of words in dictionary if loaded else 0 if not yet loaded
unsigned int size(void)
{
    // TODO
    return totalWords;
}


// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    // TODO

    // Criando dois ponteiros para atravessar a trie
    node *tmp;
    node *cursor;

    // repetindo para cada index na tabela
    for (int i = 0; i < N; i++)
    {
        if (table[i] == NULL)
        {
            continue;
        }

        cursor = table[i];
        tmp = cursor;

        // limpando todos os nós até o fim da tabela
        while (cursor->next != NULL)
        {
            cursor = cursor->next;
            free(tmp);
            tmp = cursor;
        }
        free(cursor);
    }
    return true;
}
