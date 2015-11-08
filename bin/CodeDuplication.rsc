module CodeDuplication

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::m3::AST;
import IO;
import List;
import Prelude;

public void main() {
	loc l = |project://hellowereld|;
	set[Declaration] ast = createAstsFromEclipseProject(l, true);
	checkDuplicatedCode(ast);
}

public void checkDuplicatedCode(set[Declaration] asts) {
	
	// Check for each subtree that it is declared once in the code
	// by comparing the subtree with all other subtrees
	for(ast <- asts) 
	{
		for(astSub <- asts) {
			// Not sure about this one. It will probably hold true for itself
			// so that is not covered yet. Maybe make a map with a certain key
			// that we increment on each occurence?
			if(ast == astSub) {
				println(ast);
				println("Found duplicated code.");
			}	
		}
	}
		
}