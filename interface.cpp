//Liam Eberhart
//Andrew Adler
//CS 303 Project 2
//This is loosely based on the "Kingdom" series, mostly just resouce management

#include <iostream>
using std::cout;
using std::cin;
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
extern "C" void addFunds();
extern "C" int getFunds();

int main () {
    char *villagePtr = buildVillage();
    bool keepPlaying = true;
    while (keepPlaying) {
        cout << "Choose your action: " << endl;
        string input = "";
	getline(cin, input);
        if (input == "exit") 
        {
            keepPlaying == false;
            break;
        }

        else if (input == "recruit") 
        {
            recruitVillager();
            cout << "Number of villagers: " << getVillagers() << endl;
        }

        printVillage();
    }
    return 0;
}
