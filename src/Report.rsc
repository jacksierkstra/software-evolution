module Report
import LineCounter;
import lang::java::jdt::m3::Core;
import Prelude;
import vis::Render;
import vis::Figure;
import Sig;

public void main(){
	M3 model = createM3FromEclipseProject(|project://example-project|);
	str language = "Java";
	list[str] allLinesOfProject = getAllLinesOfProject(model);
	println("Volume (Lines of Code) is <getLOCbyModel(model)>");
	
		
	str volume = volumeRating(getLOCbyModel(model),language);
	
	println("volume: <volume>");
	
	//str methodSrc = readFile(|java+method:///HelloWorld/main(java.lang.String%5B%5D)|);
	//println(getLOCbyString(methodSrc));
	
	
	
	
	str compPerUnit = complexityPerUnitRating(getUnitSizesInProject(model), language);
	printComplexityPerUnitInfo();
	int duplication = 0;
	int unitSize = 3;
	int unitTesting = 0;
	
	
	showTerminalReport(volume, compPerUnit, duplication, unitSize, unitTesting);
	
	//showReport();
}

public str scoreToString(int score){
	str result = "?";
	visit (score){
		case 1: result = "--";
		case 2: result = "-";
		case 3: result = "0";
		case 4: result = "+";
		case 5: result = "++";
	}
	return result;
}


public void showReport(){
	b1 = box(fillColor("red"), hshrink(0.5));
	b2 = box(b1, fillColor("yellow"), size(200,100));
	render(b2);
}

public void showTerminalReport(str volume, str compPerUnit, int duplication, int unitSize, int unitTesting){
	str analysability = "++";
	str changebillity = "--";
	str stability = "o";
	str testability = "o";
	println("		Volume	Complexity per unit	Duplication	Unit Size	Unit testing");
	println("		  <volume>		<compPerUnit>		   <scoreToString(duplication)>		    <scoreToString(unitSize)>		     <scoreToString(unitTesting)>");
	println("Analysability	  X 		  	  	   X		    X		     X			<analysability>");
	println("Changeability	    		X 	  	   X		     		      			<changebillity>");
	println("Stability	    		  	  	    		     		     X			<stability>");
	println("Testability	    		X 	  	    		    X		     X			<testability>");
}