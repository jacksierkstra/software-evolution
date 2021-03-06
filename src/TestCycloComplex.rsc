module TestCycloComplex
import lang::java::m3::AST;
import Prelude;
import CycloComplex;
import FindComplexFiles;
import util::Math;

public void a(){
	//lrel[int cc, loc method] relations = findAllComplexFiles(|project://smallsql0.21_src/src/|);
	//real c = 0/0;
	lrel[int cc, loc method] relations = findAllComplexFiles(|project://hsqldb-2.3.1/hsqldb/src/|);
	int i = size(relations);
	iprintln(i);
	real re = toReal(size(relations));
	iprintln(re);
	
	real b = 0/re*100;
	iprintln(b);
	
	//for(r <- relations){
	//	iprintln("<r[0]>   <r[1]>");
	//}
}



public test void testIf(){
	str string = "public class HelloWorld{
	
		public void klasse(){
			if(true){
			
			}
		}
	}";
	loc l = |project://example-project/src/HelloWorld.java|;
	Declaration ast =  createAstFromString(l, string, true);	
	assert(calcCyclomaticComplexity(ast)[0] == 2);

}

public test void testIfElse(){
	str string = "public class HelloWorld{
	
		public void klasse(){
			if(true){
			
			} else {
			
			}
		}
	}";
	loc l = |project://example-project/src/HelloWorld.java|;
	Declaration ast =  createAstFromString(l, string, true);
	assert(calcCyclomaticComplexity(ast)[0] == 2);

}


public test void testIfElse2(){
	str string = "public class HelloWorld{
	
		public void klasse(){
			if (1 == a && 1 == 2) {
				if (a == 1) {
					if (a == 2) {
						if(true){
						
						}
					}
				}
			} else if (a == 2){
			
			} else if (a == 3){
			
			}
		}
	}";
	loc l = |project://example-project/src/HelloWorld.java|;
	Declaration ast =  createAstFromString(l, string, true);
	assert(calcCyclomaticComplexity(ast)[0] == 7);

}