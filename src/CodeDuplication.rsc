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

public void main() {

	//loc l = |project://smallsql|;
	//loc l = |project://hellowereld|;
	//loc l = |project://hsqldb|;
	set[Declaration] ast = iterateThroughProject();
	checkDuplicatedCode(ast);
	
	//M3 project1 = createM3FromEclipseProject(|project://hellowereld|);
	//list[str] allLinesOfProject = getAllLinesOfProject(project1);
	//checkDuplicatedCodeMap(allLinesOfProject);
	
	//iprintln();
}

public set[Declaration] iterateThroughProject() {
	set[Declaration] asts = {};
	M3 project1 = createM3FromEclipseProject(|project://hsqldb|);
	for (file <- files(project1))
		return asts += createAstFromFile(file, true);
}

public void checkDuplicatedCode(set[Declaration] decls) {
	
	// Check for each subtree that it is declared once in the code
	// by comparing the subtree with all other subtrees
	
	int cnt = 0;
	//map[Declaration,int] duplications = ();
	map[Statement,map[str, list[int]]] duplications = ();
	
	visit(decls) {
	
		//\compilationUnit(list[Declaration] imports, list[Declaration] types)
	    //\compilationUnit(Declaration package, list[Declaration] imports, list[Declaration] types)
	    
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
	
		//case \cast(_, _): cnt += 1;
		
		case m : \method(Type \return,str name,list[Declaration] parameters, list[Expression] exceptions ,Statement impl): {
			
			loc sourceFile = impl@src;
			
			if(impl in duplications) {
				duplications[impl] += (name: [sourceFile.begin.line, sourceFile.end.line]);
			} else {
				duplications[impl] = (name: [sourceFile.begin.line, sourceFile.end.line]);
			}
			
		}
		
	}
	
	for(duplication <- duplications) {
		if( size(duplications[duplication]) > 1) {
			for(dup <- duplications[duplication]) {
				list[int] line = duplications[duplication][dup];
				if(line[1] - line[0] >= 6) {
					println(duplication@src);
					println("Found duplicate for <dup>");
					println("From line <line[0]> to <line[1]>");
				}
			}
		}
	}
	
}

public void checkDuplicatedCodeMap(list[str] lines) {
		
		list[str] removedCommentsAndBlanks = removeCommentAndBlanks(lines);
		map[str,int] dictCodeLines = ();
		
		for(line <- removedCommentsAndBlanks) {
			// We have a match
			if(line in dictCodeLines) {
				dictCodeLines[line] = dictCodeLines[line] + 1;
			} else {
				dictCodeLines[line] = 1;
			}
		}
		
		for(entry <- dictCodeLines) {
			println("The key is: <entry>");
			println("Number of occurences <dictCodeLines[entry]>");
		}
		
}