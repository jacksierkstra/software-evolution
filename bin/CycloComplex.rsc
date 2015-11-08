module CycloComplex
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import IO;
import List;
import Prelude;


public void mainTest(){
	
	//M3 model = createM3FromEclipseProject(|project://example-project|);
	//loc l = toList(files(model))[2];
	loc l = |java+compilationUnit:///Users/alexvanmanen/Documents/rascal_workspace/example-project/src/HelloWorld.java|;
	
	Declaration ast = createAstFromFile(l, true);
	//println(ast);
	calcCyclomaticComplexity(ast);

}

public void calcCyclomaticComplexity(Declaration ast){
	/*
	if statement
	while statement
	for statement
	case statement
	catch statement
	&& and || boolean operations
	?: ternary operator and ?: Elvis operator.
	?. null-check operator
	
	*/
	
	visit(ast){
		
		
	//	case m: \method(_, _, _, _, Statement impl): 
	//		println(countIfNesting(impl));
 //
		
		case m: \method(u, name, param, exceptions, impl): {			
		println("The method <name> has the cyclomatic complexity: <countIfNesting(impl)+1>");
			
			
			//cyclomaticComplexityPerMethod(createAstFromFile(impl@src, true));
			//visit(impl){
			//	case \block(lijst): {
			//		int numStatements = size(lijst);
			//		println("The method <name> has <numStatements> statement(s)");
			//	}	
			//}
			
		}
		
		
	}
}

public int countIfNesting(Statement stat){
	top-down-break visit(stat){
		case \if(_, Statement thenBranch):{
			println("called 1");
			return 1 + countIfNesting(thenBranch);
		}
		case \if(_, Statement thenBranch, Statement elseBranch):{
			println("called 2");
			return 1 + max(countIfNesting(thenBranch),countIfNesting(elseBranch));
		}
		//case \foreach(Declaration parameter, Expression collection, Statement body):{
		//	println("called 3");
		//	return 1 + countIfNesting(body);
		//}
		//case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body):{
		//	println("called 4");
		//	return 1 + countIfNesting(body);
		//}
		//case \for(list[Expression] initializers, list[Expression] updaters, Statement body):{
		//	println("called 5");
		//	return 1 + countIfNesting(body);
		//}
		
	 
	}
	
	
	return 0;
}

public int cyclomaticComplexityPerMethod(Declaration ast){
	println(ast);
	visit(ast){
		case \if(condition, thenBranch):{
			iprintln("condition if");
			iprintln("condition: <condition>");
			iprintln("thenBranch: <thenBranch>");
			
		}
		case \if(condition, thenBranch, elseBranch):{
			iprintln("condition else if");
		}

		case \for(initializers, condition, updaters, body):{
			iprintln("condition for 1");
		}
		
		case \for(initializers, updaters, body):{
			iprintln("condition for 2");
		}	
	}
	return 0;
}