module Analysis

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import List;

public void analyzeProject() {
	
	M3 project1 = createM3FromEclipseProject(|project://hellowereld|);
	list[str] allLinesOfProject = getAllLinesOfProject("Java", project1);
	
	println(allLinesOfProject);
	println("Total lines of code in Java files for project [hellowereld] is: ");
	println(countLines(allLinesOfProject));
	
	
	/*M3 project2 = createM3FromEclipseProject(|project://hsqldb|);	
	println("Total lines of code in Java files for project [hsqldb] is: ");
	println(countLines("Java", project2));*/
	
}

public list[str] getAllLinesOfProject(str fileType, M3 projectModel) {
	list[str] lines = [];
	for(f <- files(projectModel))
		lines += readFileLines(f);
	return lines;		
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
public int countCommentedLines(str fileType, M3 projectModel) {
	return 0;
}