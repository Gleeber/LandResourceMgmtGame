//Liam Eberhart
//Andrew Adler
//CS 303 Project 2
//This is loosely based on the "Kingdom" series, mostly just resouce management

#include <iostream>
using std::cout;
using std::endl;
#include <stdlib.h>

extern "C" char * buildVillage();
extern "C" void recruitVillager(void *);
extern "C" void printVillage(char *);

int main () {
    char *villagePtr = buildVillage();
    printVillage(villagePtr);
    return 0;
}