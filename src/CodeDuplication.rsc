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

public void main() {

	//loc l = |project://smallsql|;
	loc l = |project://hellowereld|;
	//loc l = |project://hsqldb|;

	M3 project = createM3FromEclipseProject(l);
	iterateThroughProject(project);
	
}

public void iterateThroughProject(M3 project) {
	
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

public void checkStatementOccursTwice(map[Statement,map[str, list[int]]] dups) {
	
	for(dup <- dups) {
		if (isDuplicate(dups[dup])) 
			printInfoAboutDuplicates(dups[dup]);
	}
	
}

public void printInfoAboutDuplicates(map[str,list[int]] entries) {
	
	for (entry <- entries) {
		if( (getToLine(entries[entry]) - getFromLine(entries[entry])) >= threshold) {
			iprintln(entry);
		}
	}
	
}

public int getFromLine(list[int] lineList) {
	return lineList[0];
}

public int getToLine(list[int] lineList) {
	return lineList[1];
}

/**
 * Meaning: if the Statement occurs in the map, and it has
 * more than one entry, it is a duplicate.
 */
public bool isDuplicate(map[str, list[int]] entry) {
	return (size(entry) > 1);
}

public map[Statement,map[str, list[int]]] codeDuplicateMap(Declaration decl) {

	map[Statement,map[str, list[int]]] duplications = ();

	visit(decl) {

		//\enum(str name, list[Type] implements, list[Declaration] constants, list[Declaration] body)
	    //\enumConstant(str name, list[Expression] arguments, Declaration class)
	    //\enumConstant(str name, list[Expression] arguments)
	    //\class(str name, list[Type] extends, list[Type] implements, list[Declaration] body)
	    //\class(list[Declaration] body)
	    //\interface(str name, list[Type] extends, list[Type] implements, list[Declaration] body)
	    //\field(Type \type, list[Expression] fragments)
	    //\initializer(Statement initializerBody)
	    //\method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)
	    //\method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions)
	    //\constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)
	    //\import(str name)
	    //\package(str name)
	    //\package(Declaration parentPackage, str name)
	    //\variables(Type \type, list[Expression] \fragments)
	    //\typeParameter(str name, list[Type] extendsList)
	    //\annotationType(str name, list[Declaration] body)
	    //\annotationTypeMember(Type \type, str name)
	    //\annotationTypeMember(Type \type, str name, Expression defaultBlock)
	    //// initializers missing in parameter, is it needed in vararg?
	    //\parameter(Type \type, str name, int extraDimensions)
	    //\vararg(Type \type, str name)

	    // It only checks methods right now. If I add only the contstructor
	    // part, it results in a Stackoverflow error.

		case m : \method(Type \return,str name,list[Declaration] parameters, list[Expression] exceptions ,Statement impl): {

			loc sourceFile = impl@src;

			if(impl in duplications) {
				duplications[impl] += (name: [sourceFile.begin.line, sourceFile.end.line]);
			} else {
				duplications[impl] = (name: [sourceFile.begin.line, sourceFile.end.line]);
			}

		}

	}

	return duplications;
}
