module Analysis

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import List;

public void analyzeProject() {
	
	M3 project1 = createM3FromEclipseProject(|project://hellowereld|);
	
	println("Total lines of code in Java files for project [hellowereld] is: ");
	println(countLines("Java", project1));
	
	M3 project2 = createM3FromEclipseProject(|project://hsqldb|);
	
	println("Total lines of code in Java files for project [hsqldb] is: ");
	println(countLines("Java", project2));
	
}

public int countLines(str fileType, M3 projectModel) {
	int numberOfLines = 0;
	for(f <- files(projectModel))
		numberOfLines += size(readFileLines(f));
	return numberOfLines;
}

// Actual output :
// rascal>analyzeProject();
// Total lines of code in Java files for project [hellowereld] is: 
// 9
// Total lines of code in Java files for project [hsqldb] is: 
// 298084
// -----------------------------------------------------------------
// Please note that the analysis for the hsqldb project is not
// only done on Java files, but on all types of files.
