module Report
import lang::java::jdt::m3::Core;
import Prelude;
import vis::Render;
import vis::Figure;
import Sig;
import LineCounter;
import FindComplexFiles;
import CodeDuplication;


public void main(){
	//loc project = |project://example-project/src/|;
	loc project = |project://hsqldb-2.3.1/hsqldb/src/|;
	//loc project = |project://smallsql0.21_src/src/|;
	
	M3 model = createM3FromEclipseProject(project);
	str language = "Java";
	list[str] allLinesOfProject = getAllLinesOfProject(model);
	int totalLinesOfCode = getLOCbyModel(model);
	str volume = volumeRating(totalLinesOfCode,language);
	
	
	/* counting duplicates */
	reset();
	checkDuplicates(model);
	str duplication =  duplicateRating(totalNumOfLinesDuplicated,totalLinesOfCode);
	
	str unitSize = unitSizeRating(getUnitSizesInProject(model), language);
	
	str compPerUnit = complexityPerUnitRating(findAllComplexFiles(project));
	str unitTesting = "?";
	
	
	showTerminalReport(volume, compPerUnit, duplication, unitSize, unitTesting);
}


public void showReport(){
	b1 = box(fillColor("red"), hshrink(0.5));
	b2 = box(b1, fillColor("yellow"), size(200,100));
	render(b2);
}

public void showTerminalReport(str volume, str compPerUnit, str duplication, str unitSize, str unitTesting){
	str stability = "?";
	println("		Volume	Complexity per unit	Duplication	Unit Size	Unit testing");
	println("		  <volume>		<compPerUnit>		   <duplication>		    <unitSize>		     <unitTesting>");
	println("Analysability	  X 		  	  	   X		    X		     X			<getAverage([volume,duplication,unitSize])>");
	println("Changeability	    		X 	  	   X		     		      			<getAverage([compPerUnit,duplication])>");
	println("Stability	    		  	  	    		     		     X			<stability>");
	println("Testability	    		X 	  	    		    X		     X			<getAverage([compPerUnit,unitSize])>");
}