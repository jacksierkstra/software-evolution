module Sig
import Prelude;
import util::Math;

public str ratingDoublePlus = "++";
public str ratingPlus = "+";
public str ratingNeutral = "o";
public str ratingMin = "-";
public str ratingDoubleMin = "--";
public str ratingUnknown = "?";


public int SIZE_SIMPLE = 1;
public int SIZE_MORE_COMPLEX = 2;
public int SIZE_COMPLEX = 3;
public int SIZE_TO_COMPLEX = 4;
public int SIZE_UNKNOWN = 0;

public real percCPUSimple = 0.0;
public real percCPUMoreComplex = 0.0;
public real percCPUComplex = 0.0;
public real percCPUToComplex = 0.0;


// Bases on the SIG Model
public str volumeRating(int linesOfCode, str language){
	str result = ratingUnknown;
	visit(language){
		case "Java" : {
			if(linesOfCode >= 0 && linesOfCode <= 66000){
				result = ratingDoublePlus;
			} else if (linesOfCode > 66000 && linesOfCode <= 246000){
				result = ratingPlus;
			} else if (linesOfCode > 246000 && linesOfCode <= 665000){
				result = ratingNeutral;
			} else if (linesOfCode > 665000 && linesOfCode <= 1310000){
				result = ratingMin;
			} else if (linesOfCode > 1310000){
				result = ratingDoubleMin;
			}
		}
		case "Cobol" : {;}
		case "PL/SQL" : {;}
	}
	
	return result;	
}


// Not based on the SIG Model, but based on experience
public int complexityPerUnit(int linesOfCode, str language){
	int result = SIZE_UNKNOWN;
	visit(language){
		case "Java" : {
			if(linesOfCode >= 0 && linesOfCode <= 20){
				result = SIZE_SIMPLE;
			} else if (linesOfCode > 20 && linesOfCode <= 40){
				result = SIZE_MORE_COMPLEX;
			} else if (linesOfCode > 40 && linesOfCode <= 100){
				result = SIZE_COMPLEX;
			} else if (linesOfCode > 100){
				result = SIZE_TO_COMPLEX;
			} 
		}
		case "Cobol" : {;}
		case "PL/SQL" : {;}
	}
	
	return result;	
}

public str complexityPerUnitRating(list[int] unitSizeList, str language){
	str result = ratingUnknown;
	
	int simple = 0;
	int moreComplex = 0;
	int complex = 0;
	int toComplex = 0;
	for(codeSize <- unitSizeList){
		println("codeSize: <codeSize>");
		complexity = complexityPerUnit(codeSize, language);
		if (complexity == SIZE_SIMPLE) simple = simple+1;
		else if (complexity == SIZE_MORE_COMPLEX) moreComplex = moreComplex + 1;
		else if (complexity == SIZE_COMPLEX) complex = complex + 1;
		else if (complexity == SIZE_TO_COMPLEX) toComplex = toComplex + 1;
	}
	int numOfUnits = size(unitSizeList);
	println(simple);
	println(numOfUnits);

	
	percCPUSimple = (toReal(simple) / numOfUnits) * 100;
	percCPUMoreComplex = (toReal(moreComplex) / numOfUnits) * 100;
	percCPUComplex = (toReal(complex) / numOfUnits) * 100;
	percCPUToComplex = (toReal(toComplex) / numOfUnits) * 100;
	
	//TODO: Check if this is right. 
	if(percCPUToComplex >= 5 || percCPUComplex >= 15 || percCPUSimple >= 50){
		result = ratingPlus;
	} else if(percCPUToComplex >= 0 || percCPUComplex >= 10 || percCPUSimple >= 40){
		result = ratingNeutral;
	} else if(percCPUToComplex >= 0 || percCPUComplex >= 5 || percCPUSimple >= 30){
		result = ratingMin;
	} else if(percCPUToComplex >= 0 || percCPUComplex >= 0 || percCPUSimple >= 25){
		result = ratingDoubleMin;
	}
	return result;
}

public void printComplexityPerUnitInfo(){
	println("percentage simple: <percCPUSimple>"); 
	println("percentage more complex: <percCPUMoreComplex>"); 
	println("percentage complex: <percCPUComplex>"); 
	println("percentage to complex: <percCPUToComplex>"); 
}

