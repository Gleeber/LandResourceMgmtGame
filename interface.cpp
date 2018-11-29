//Liam Eberhart
//Andrew Adler
//CS 303 Project 2
//This is loosely based on the "Kingdom" series, mostly just resouce management

#include <iostream>
using std::cin;
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
extern "C" void addFunds();
extern "C" int getFunds();

int main () {
    char *villagePtr = buildVillage();
    bool keepPlaying = true;
    while (keepPlaying) {
        cout << "Number of villagers: " << getVillagers() << endl;
        cout << "Coin: " << getFunds() << endl;
        cout << "Choose your action:\ne \t exits\nr \t recruit Villager\nf \t build a farm ("<<"#" << "//2)\nw \t walls\n>:";
	string input;
	getline(cin, input);
        if (input == "e") 
        {
            keepPlaying = false;
	    cout << "Farewell!" << endl;
            break;
        }

        else if (input == "r") 
        {
            recruitVillager();
	}
        
	else if (input == "f") 
        {
            //build a farm here, would give income limit farms?
	}

        else if (input == "w") 
        {
            //build walls here, maybe have upgrade table/cost of upgrades?
	}
	
	printVillage(villagePtr);
    }
    return 0;
}
