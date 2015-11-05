module LineCounter

import lang::java::jdt::m3::Core;
import IO;
import Prelude;


/**
 * Function returns the lines of code. This function doesn't count the comment and blank lines. 
 * 
 * @param location 	e.g.: |java+method:///HelloWorld/main(java.lang.String%5B%5D)|
 * @return the lines of code (LOC)
 */
public int countNumbersMethod(loc location){
	str methodSrc = readFile(location);
	list[str] lines = split("\n", methodSrc);
	return size(removeCommentAndBlanks(lines));
}

public list[str] removeCommentAndBlanks(list[str] lines ){
	list[str] result = [];
	bool commentOn = false;
	str line = "";
	for(l <- lines) {
		//Filter out blank lines and comments like //,  /*, *
		line = l; 		
		if(contains(trim(line),"/*") && !contains(trim(line),"*/")){ 
			commentOn = true; 
		}
		
		if(commentOn) {
			commentOn = !contains(trim(line),"*/");	
		}
		if(!commentOn){
			if(trim(line) != "" && !startsWith(trim(line),"/") && !startsWith(trim(line),"*")){
				result = result + line;
			}
		}
	}
	return result;

}

public int getLOCbyModel(M3 projectModel){
	return size(removeCommentAndBlanks(getAllLinesOfProject(projectModel)));
}

public int getLOCbyString(str source){
	list[str] srcList = split("\n", source);
	return size(removeCommentAndBlanks(srcList));
}

public list[str] getAllLinesOfProject(M3 projectModel) {
	list[str] lines = [];
	for(f <- files(projectModel))
		lines += readFileLines(f);
	return lines;		
}

public list[int] getUnitSizesInProject(M3 projectModel){
	list[int] result = [];
	for(c <- classes(projectModel)){
		 for(method <- methods(projectModel, c)){
		 	int linesOfCode = getLOCbyString(readFile(method));
		 	result = result + linesOfCode;
		 }
	}
	return result;
}

public map[loc, int] getUnitSizesInProject(M3 projectModel){
	map[loc, int] result = ();
	for(c <- classes(projectModel)){
		 for(method <- methods(projectModel, c)){
		 	int linesOfCode = getLOCbyString(readFile(method));
		 	result = result + (method:linesOfCode);
		 }
	}
	return result;
}