//Liam Eberhart
//Andrew Adler
//CS 303 Project 2
//This is loosely based on the "Kingdom" series, mostly just resouce management

#include <iostream>
using std::cout;
using std::endl;
#include <string>
using std::string;
using std::getline;

extern "C" void testingFunction();

extern "C" char * buildVillage();
extern "C" void printVillage(char *);

extern "C" void recruitVillager();
extern "C" int getVillagers();

extern "C" void moveTime();

int main () {
    char *villagePtr = buildVillage();
    printVillage(villagePtr);

    bool keepPlaying = true;
    while (keepPlaying) {
        cout << "Choose your action: " << endl;
        string input = getline();
        if (input = "exit") 
        {
            keepPlaying = false;
            break;
        }

        else if (input = "recruit") 
        {
            recruitVillager();
            cout << "Number of villagers: " << getVillagers() << endl;
        }

        printVillage();
        return 0;
    }
}