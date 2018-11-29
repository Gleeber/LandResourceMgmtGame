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

extern "C" void addFunds();
extern "C" int getFunds();

int main () {
    char *villagePtr = buildVillage();
    //do{
	cout << "Coin: " << getFunds() << endl;
	cout << "Number of villagers: " << getVillagers() << endl;

	printVillage(villagePtr);
	recruitVillager();
	recruitVillager();

   // }while(input != "exit")	
	return 0;
}
