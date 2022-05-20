#ifndef _PHILSPEL_H
#define _PHILSPEL_H

extern struct HashTable *dictionary;

extern unsigned int stringHash(void *s);

extern int stringEquals(void *s1, void *s2);

extern void readDictionary(char *dictName);

extern void processInput();

extern bool check_letter(char c);

#endif
