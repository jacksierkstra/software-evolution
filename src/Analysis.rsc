module Analysis

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import IO;
import List;
import Prelude;




public void analyzeProject() {
	
	M3 project1 = createM3FromEclipseProject(|project://example-project|);
	list[str] allLinesOfProject = getAllLinesOfProject("Java", project1);
	list[Declaration] asts = getAllASTsOfProject(project1);

	/* 
	Code to go just one file instead of alle
	Declaration ast2 = createAstFromFile(toList(files(project1))[2], true);
	println(ast2);
	printVisitInfo(ast2);
	*/
	
	printVisitInfo(asts);


	
	
	list[str] adjustedLines = removeCommentAndBlanks(allLinesOfProject);
	//println(adjustedLines);
	println("Total lines of code in Java files for project [example-project] is: ");
	println(countLines(adjustedLines));
	
	
	
	
	/*M3 project2 = createM3FromEclipseProject(|project://hsqldb|);	
	println("Total lines of code in Java files for project [hsqldb] is: ");
	println(countLines("Java", project2));*/
	
}


public void printVisitInfo(list[Declaration] asts){
	for(ast <- asts) {
		printVisitInfo(ast);
	}	
}

public void printVisitInfo(Declaration ast){
	iprintln("--------------------------------");
	iprintln("Start with visiting a new file: ");
	visit(ast){
		

		case \class(name, extends, implements, body):{
			iprintln("class name: "+ name);
		}
		
		case \interface(name, extends, implements, body):{
			iprintln("interface name: "+ name);
		}
		
		case \import(i): {
			iprintln("Found an import: "+ i);
		}
		
		case \method(u, name, param, exceptions, impl): {			
			visit(impl){
				case \block(lijst): {
					int numStatements = size(lijst);
					println("The method <name> has <numStatements> statement(s)");
				}	
			}
			
		}
		
	
	}
}


public list[Declaration] getAllASTsOfProject(M3 projectModel) {
	list[Declaration] asts = [];
	for(f <- files(projectModel)) {
		asts =  asts + createAstFromFile(f,true);
	}	
	return asts;
}

public list[str] getAllLinesOfProject(str fileType, M3 projectModel) {
	list[str] lines = [];
	for(f <- files(projectModel))
		lines += readFileLines(f);
	return lines;		
}

public list[str] getAllLinesOfProject(str fileType, M3 projectModel) {
	list[str] lines = [];
	for(f <- files(projectModel))
		lines += readFileLines(f);
	return lines;		
}




public list[str] removeCommentAndBlanks(list[str] lines ){
	list[str] result = [];
	for(line <- lines)
		//Filter out blank lines and comments like //,  /*, *
		
		//TODO: This doesn't work yet
				/* 
		 		int b;
		 		*/
		if(trim(line) != "" && !startsWith(trim(line),"/") && !startsWith(trim(line),"*"))
			result = result + line;
	
	return result;

}

/*
  The following method will count the lines for a whole project.
  TODO: the type of files still need to be defined.
*/
public int countLines(list[str] lines) {
	return size(lines);
}

/*
  The following method will count comments in a given project.
  This includes comment blocks and commentedLines. 
*/
public int countCommentedLines(list[str] lines) {
	return 0;
}
