module CodeDuplication

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::m3::AST;
import IO;
import List;
import Map;
import Prelude;
import LineCounter;


int threshold = 6;
bool collectBindings = false;

/*
 * creates a M3 model from the given project location.
 * then it calls subsequent methods in this file to 
 * gather information about that project.
*/
public void checkDuplicates(loc projectLocation) {
	M3 project = createM3FromEclipseProject(projectLocation);
	iterateThroughProject(project);
}

/*
 * Goes over all the files in the M3 model and creates Abstract Syntax Trees from them.
 * Then it gives the results over to the next methods which will check for duplicates.
*/
private void iterateThroughProject(M3 project) {
	
	set[Declaration] declarations = { createAstFromFile(file, collectBindings) |  file <- files(project) };
	
	map[Statement,map[str, list[int]]] dups = ();
	
	for(decl <- declarations) {
		
		map[Statement,map[str, list[int]]] duplicatemap = codeDuplicateMap(decl);
		
		for(dup <- duplicatemap) {

            if(dup in dups) {
                dups[dup] += duplicatemap[dup];
            } else {
            	dups[dup] = duplicatemap[dup];
            }

        }
        
	}

    checkStatementOccursTwice(dups);

}

/*
 * We only do something with the result if the implementation key occurs more than
 * once. The reason is that if it does, it is a duplicate.
*/
private void checkStatementOccursTwice(map[Statement,map[str, list[int]]] dups) {
	for(dup <- dups) {
		if (isDuplicate(dups[dup])) 
			printInfoAboutDuplicates(dups[dup]);
	}
}

/*
 * Goes over the gathered map and prints info about the entries that
 * are compliant with the given threshold.
*/
private void printInfoAboutDuplicates(map[str,list[int]] entries) {
	
	println();
	println("The following methods are duplicates:");
	for (entry <- entries) {
		if( (getToLine(entries[entry]) - getFromLine(entries[entry])) >= threshold) {
			iprintln(entry);
		}
	}	
	
}

/*
 * this is kind of a dirty way to get the from line
 * in the provided list, but I don't really care.
*/
private int getFromLine(list[int] lineList) {
	return lineList[0];
}

/*
 * this is kind of a dirty way to get the to line
 * in the provided list, but I don't really care.
*/
private int getToLine(list[int] lineList) {
	return lineList[1];
}


/**
 * Meaning: if the Statement occurs in the map, and it has
 * more than one entry, it is a duplicate.
 */
private bool isDuplicate(map[str, list[int]] entry) {
	return (size(entry) > 1);
}

/*
 * Goes over the declaration and add each implementation of a method and 
 * a constructor to a map. The implementation is the key of the map.
*/
private map[Statement,map[str, list[int]]] codeDuplicateMap(Declaration decl) {

	map[Statement,map[str, list[int]]] duplications = ();
	
	visit(decl) {

		case c : \constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl):{
			
			loc sourceFile = impl@src;

			if(impl in duplications) {
				duplications[impl] += ( "<sourceFile> : <name>" : [sourceFile.begin.line, sourceFile.end.line]);
			} else {
				duplications[impl] = ("<sourceFile> : <name>": [sourceFile.begin.line, sourceFile.end.line]);
			}
			
		}
		case m : \method(Type \return,str name,list[Declaration] parameters, list[Expression] exceptions ,Statement impl): {

			loc sourceFile = impl@src;

			if(impl in duplications) {
				duplications[impl] += ( "<sourceFile> : <name>" : [sourceFile.begin.line, sourceFile.end.line]);
			} else {
				duplications[impl] = ("<sourceFile> : <name>": [sourceFile.begin.line, sourceFile.end.line]);
			}

		}

	}

	return duplications;
}
