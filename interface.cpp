//Liam Eberhart
//Andrew Adler
//CS 303 Project 2
//This is loosely based on the "Kingdom" series, mostly just resouce management

#include <iostream>
using std::cout;
using std::endl;

extern "C" void testingFunction(void);

extern "C" char * buildVillage();
extern "C" void printVillage(char *);

extern "C" void recruitVillager();
extern "C" int getVillagers();

int main () {
    char *villagePtr = buildVillage();
    printVillage(villagePtr);

    recruitVillager();
    recruitVillager();
    cout << "Number of villagers: " << getVillagers() << endl;
    return 0;
}