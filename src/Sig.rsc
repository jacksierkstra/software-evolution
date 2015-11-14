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
	println();
	println("Volume: <linesOfCode> lines of code");
	println();
	return result;	
}


// Not based on the SIG Model, but based on experience
public int unitSize(int linesOfCode, str language){
	int result = SIZE_UNKNOWN;
	visit(language){
		case "Java" : {
			if(linesOfCode >= 0 && linesOfCode <= 20){
				result = SIZE_SIMPLE;
			} else if (linesOfCode > 20 && linesOfCode <= 50){
				result = SIZE_MORE_COMPLEX;
			} else if (linesOfCode > 50 && linesOfCode <= 100){
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

public map[int,int] unitSizeMap(list[int] unitSizeList,  str language){
	int simple = 0;
	int moreComplex = 0;
	int complex = 0;
	int toComplex = 0;
	for(codeSize <- unitSizeList){
		complexity = unitSize(codeSize, language);
		if (complexity == SIZE_SIMPLE) simple = simple+1;
		else if (complexity == SIZE_MORE_COMPLEX) moreComplex = moreComplex + 1;
		else if (complexity == SIZE_COMPLEX) complex = complex + 1;
		else if (complexity == SIZE_TO_COMPLEX) toComplex = toComplex + 1;
	}
	return (SIZE_SIMPLE: simple, SIZE_MORE_COMPLEX: moreComplex, 
			SIZE_COMPLEX: complex, SIZE_TO_COMPLEX : toComplex);
}

public str unitSizeRating(list[int] unitSizeList, str language){
	str result = ratingUnknown;
	
	map[int,int] mapUnitSizes = unitSizeMap(unitSizeList, language);
	
	int numOfUnits = size(unitSizeList);
	real percCPUSimple = (toReal(mapUnitSizes[SIZE_SIMPLE]) / numOfUnits) * 100;;
	real percCPUMoreComplex = (toReal(mapUnitSizes[SIZE_MORE_COMPLEX]) / numOfUnits) * 100;;
	real percCPUComplex =  (toReal(mapUnitSizes[SIZE_COMPLEX]) / numOfUnits) * 100;
	real percCPUToComplex =  (toReal(mapUnitSizes[SIZE_TO_COMPLEX]) / numOfUnits) * 100;
	
	println("Unit size report:");
	println("number of simple units (0-20 lines): 				<mapUnitSizes[SIZE_SIMPLE]> (<percCPUSimple>%)"); 
	println("number of more complex units (20-50 lines): 			<mapUnitSizes[SIZE_MORE_COMPLEX]> (<percCPUMoreComplex>%)"); 
	println("number of complex units: (50-100 lines): 			<mapUnitSizes[SIZE_COMPLEX]> (<percCPUComplex>%)"); 
	println("number of to complex units (more than 100 lines):	 	<mapUnitSizes[SIZE_TO_COMPLEX]> (<percCPUToComplex>%)"); 
	println();
	return getRatingMaximumRelativeLOC(percCPUMoreComplex, percCPUComplex, percCPUToComplex);
}


public map[str, int] complexityPerUnitMap(lrel[int cc, loc method] relations){
	int withoutMuchRisk = 0;
	int moderateRisk = 0;
	int highRisk = 0;
	int veryHighRisk = 0;
	//Goes through the list with all the units (methods) and determines in which category it falls
	for(r <- relations) {
		//r[0] is the cyclomatic complexity
		if(r[0] >= 1 && r[0] <= 10) { withoutMuchRisk +=1;}
		if(r[0] >= 11 && r[0] <= 20) { moderateRisk +=1;}
		if(r[0] >= 21 && r[0] <= 50) { highRisk +=1;}
		if(r[0] >= 51) { veryHighRisk +=1;}
	}
	return ("WITHOUT_MUCH_RISK": withoutMuchRisk, "MODERATE_RISK" : moderateRisk, 
			"HIGH_RISK" : highRisk, "VERY_HIGH_RISK" :veryHighRisk);
}

public str complexityPerUnitRating(lrel[int cc, loc method] relations){
	str result = ratingUnknown;
	map[str, int] counted = complexityPerUnitMap(relations);
	real numberOfUnits = toReal(size(relations));
	real percWithoutMuchRisk = counted["WITHOUT_MUCH_RISK"]/numberOfUnits * 100;
	real percModerateRisk = counted["MODERATE_RISK"]/numberOfUnits * 100;
	real percHighRisk = counted["HIGH_RISK"]/numberOfUnits * 100;
	real percVeryHighRisk = counted["VERY_HIGH_RISK"]/numberOfUnits * 100;
	
	println("Cyclomatic Complexity per unit report:");
	println("number of methods without much risk (CC is 1-10): 		<counted["WITHOUT_MUCH_RISK"]> (<percWithoutMuchRisk>%)");
	println("number of methods with moderate risk (CC is 11-20): 		<counted["MODERATE_RISK"]> (<percModerateRisk>%)");
	println("number of methods with high risk (CC is 21-50): 		<counted["HIGH_RISK"]> (<percHighRisk>%)");
	println("number of methods with very high risk (CC is higer than 50): 	<counted["VERY_HIGH_RISK"]> (<percVeryHighRisk>%)");
	println();
	
	return getRatingMaximumRelativeLOC(percModerateRisk, percHighRisk, percVeryHighRisk);
}

public str getRatingMaximumRelativeLOC(real percModerate, real percHigh, real percVeryHigh){
	str result = ratingUnknown;
	if(percModerate <= 25 && percHigh <= 0 && percVeryHigh <= 0) { 
		result = ratingDoublePlus;
	} else if(percModerate <= 30 && percHigh <= 5 && percVeryHigh <= 0) {
		result = ratingPlus;
	} else if(percModerate <= 40 && percHigh <= 10 && percVeryHigh <= 0) {
		result = ratingNeutral;
	} else if(percModerate <= 50 && percHigh <= 15 && percVeryHigh <= 5) {
		result = ratingMin;
	} else {
		result = ratingDoubleMin;
	} 
	return result;
}

public str duplicateRating(int totalNumOfLinesDuplicated, int totalLinesOfCode){
	str result = ratingUnknown;
	real perc = toReal(totalNumOfLinesDuplicated) / totalLinesOfCode * 100;
	println("Duplication: <totalNumOfLinesDuplicated> lines of code (<perc>%)");
	println();
	if(perc >= 0 && perc <= 3){
		result = ratingDoublePlus;
	} else if(perc > 3 && perc <= 5){
		result = ratingPlus;
	} else if(perc > 5 && perc <= 10){
		result = ratingNeutral;
	} else if(perc > 10 && perc <= 20){
		result = ratingMin;
	} else if(perc > 20 && perc <= 100){
		result = ratingDoubleMin;
	}
	return result;
}


public str getAverage(list[str] ratings){
	int total = 0;
	for(rating <- ratings){
		total = total + convertRating(rating);
	}
	int average = total/size(ratings);
	return convertRating(average);
}

private int convertRating(str rating){
	switch(rating){
		case "--": return 1;
		case "-": return 2;
		case "o": return 3;
		case "+": return 4;
		case "++": return 5;
	}
	return 0;
}

private str convertRating(int rating){
	switch(rating){
		case 1: return "--";
		case 2: return "-";
		case 3: return "o";
		case 4: return "+";
		case 5: return "++";
	}
	return "?";
}



