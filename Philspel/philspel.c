/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philspel.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string) and is already done for you here 
 * for convenience.
 */
unsigned int stringHash(void *s) {
  char *string = (char *)s;
  unsigned int hash_value = 1;
  int index = 0;
  while (string[index] != 0) {
    hash_value = (hash_value * (string[index])) - 10;
    hash_value = hash_value % 1000000000;
    index++;
  }
  return hash_value;
}

/*
 * This should return a nonzero value if the two strings are identical 
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2) {
  char *string1 = (char *)s1;
  char *string2 = (char *)s2;
  if (string1 == NULL || string2 == NULL) {
    return 0;
  }
  int index1 = 0;
  int index2 = 0;
  while (string1[index1] != 0 && string2[index2] != 0) {
    if (string1[index1] != string2[index2]) {
      return 0;
    }
    index1++;
    index2++;
  }
  if (string1[index1] != 0 || string2[index2] != 0) {
    return 0;
  }
  return 1;
}

/*
 * This function should read in every word from the dictionary and
 * store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final 20% of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(1)
 * to cleanly exit the program.
 *
 * Since the format is one word at a time, with new lines in between,
 * you can safely use fscanf() to read in the strings until you want to handle
 * arbitrarily long dictionary chacaters.
 */
void readDictionary(char *dictName) {
  FILE *fp = fopen(dictName, "r");
  if (!fp) {
    fprintf(stderr, "can't open file %s\n", dictName);
    exit(1);
  }
  int max_line = 100;
  char *string_pointer = (char *)calloc(1, max_line);
  while (fgets(string_pointer, max_line, fp) != NULL) {
    size_t len = strlen(string_pointer);
    string_pointer[len - 1] = '\0'; // repace '\n' with '\0'
    char *data_pointer = (char *)malloc(len);
    strcpy(data_pointer, string_pointer);
    insertData(dictionary, (void *)data_pointer, (void *)data_pointer);
  }
  fclose(fp); 
}

/*
 * This should process standard input (stdin) and copy it to standard
 * output (stdout) as specified in the spec (e.g., if a standard 
 * dictionary was used and the string "this is a taest of  this-proGram" 
 * was given to stdin, the output to stdout should be 
 * "this is a teast [sic] of  this-proGram").  All words should be checked
 * against the dictionary as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the dictionary should it
 * be reported as not found by appending " [sic]" after the error.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final 20% of your grade, you cannot assume words have a bounded length.
 */
void processInput() {
  char c;
  int size = 60;
  char *read_buffer = (char *)calloc(1, size);
  int count = 0;
  bool prev_is_letter = false;
  bool reach_end = false;
  while (!reach_end) {
    c = getchar();
    if (c == EOF) {
      reach_end = true;
      if (!prev_is_letter) {
        break;
      }
    }
    if (!check_letter(c)) {
      if (!prev_is_letter) {
        fprintf(stdout, "%c", c);
	continue;
      }
      prev_is_letter = false;
      read_buffer[count] = '\0';
      //fprintf(stderr, "a word: %s", read_buffer);
      char *find_data = findData(dictionary, read_buffer);
      if (find_data) {
        //fprintf(stderr, "in dictionary: %s", find_data);
        fprintf(stdout, "%s", find_data);
	fprintf(stdout, "%c", c);
	count = 0;
	continue;
      }
      size_t len = strlen(read_buffer);
      char *low_letter_buffer = (char *)calloc(1, len + 1);
      low_letter_buffer[0] = read_buffer[0];
      for (size_t i = 1; i < len; ++i) {
        if (read_buffer[i] < 97) {
	  low_letter_buffer[i] = read_buffer[i] + 32;
	} else {
	  low_letter_buffer[i] = read_buffer[i];
	}
      }
      low_letter_buffer[len] = '\0';
      find_data = findData(dictionary, low_letter_buffer);
      if (find_data) {
        fprintf(stdout, "%s", read_buffer);
	fprintf(stdout, "%c", c);
	count = 0;
	continue;
      }
      if (read_buffer[0] < 97) {
        low_letter_buffer[0] += 32;
        find_data = findData(dictionary, low_letter_buffer);
        if (find_data) {
          fprintf(stdout, "%s", find_data);
          fprintf(stdout, "%c", c);
          count = 0;
          continue;
        }
      }
      fprintf(stdout, "%s", read_buffer);
      fprintf(stdout, " [sic]");
      if (!reach_end) {
        fprintf(stdout, "%c", c);
      }
      count = 0;
    } else {
      read_buffer[count] = c;
      count++;
      if (count >= size) {
	int new_size = size * 2;
        char *new_read_buffer = (char *)calloc(1, new_size);
	strcpy(new_read_buffer, read_buffer);
	free(read_buffer);
	read_buffer = new_read_buffer;
	size = new_size;
      }
      prev_is_letter = true;
    }
  } 
}


bool check_letter(char c) {
  if (((c >= 'a') && (c <= 'z')) || ((c >= 'A') && (c <= 'Z'))) {
    return true;
  }
  return false;
}
