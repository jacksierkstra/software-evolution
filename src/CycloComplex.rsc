module CycloComplex
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import IO;
import List;
import Prelude;
import util::Math;
import lang::java::jdt::Project;



public void mainTest(){
	
	//M3 model = createM3FromEclipseProject(|project://example-project|);
	//loc l = toList(files(model))[2];
	//loc l = |java+compilationUnit:///Users/alexvanmanen/Documents/rascal_workspace/example-project/src/HelloWorld.java|;
	loc l = |project://example-project/src/HelloWorld.java|;
	//loc dir = |project://smallsql0.21_src|;
	
	Declaration ast = createAstFromFile(l, true);

	
	iprintln(ast);
	//println(ast);
	calcCyclomaticComplexity(ast);
	println(bla(5,5));
	readFiles();
	

}

public void readFiles(){
	
	
	//loc dir = |project://example-project/src/|;
	//loc dir = |project://smallsql0.21_src|;
	loc dir = |project://hsqldb-2.3.1|;
	
	
	set[loc] locations = sourceFilesForProject(dir);
	Declaration ast;
	for(location <- locations){
		iprintln("location: <location>");
		ast = createAstFromFile(location, true);
		//iprintln(ast);
	}

}

public list[int] calcCyclomaticComplexity(Declaration ast){
	list[int] result = [];
	/*
	
	&& and || boolean operations
	?: ternary operator and ?: Elvis operator.
	?. null-check operator
	*/

	visit(ast){
		//	case m: \method(_, _, _, _, Statement impl): 
		//		println(countIfNesting(impl));
		case m: \method(u, name, param, exceptions, impl): {		
		println("The method <name> has the cyclomatic complexity: <countIfNesting(impl)>");
		result = result + [countIfNesting(impl)];	
		//cyclomaticComplexityPerMethod(createAstFromFile(impl@src, true));
		//visit(impl){
		//	case \block(lijst): {
		//		int numStatements = size(lijst);
		//		println("The method <name> has <numStatements> statement(s)");
		//	}	
		//}			
		}
		
		
	}
	return result;
}


public int bla(int i, int deep){
	int result = 0;
	if(deep > 0) {
		println(result);
		result = bla(i, deep-1);
		result = result + 1;
	}
	return result;

}




public int countIfNesting(Statement stat){
	int result = 1;

	top-down visit(stat){
		
		case \if(Expression condition, Statement thenBranch):{
			result += 1;
			countIfNesting(thenBranch);
		}
		case \if(Expression condition, Statement thenBranch, Statement elseBranch):{
			result += 1;
			countIfNesting(thenBranch);
			countIfNesting(elseBranch);
		}
		case \foreach(Declaration parameter, Expression collection, Statement body):{
			result += 1;
			countIfNesting(body);
		}
		case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body):{
			countIfNesting(body);
			result += 1;	
		}
		case \for(list[Expression] initializers, list[Expression] updaters, Statement body):{
			result += 1;
			countIfNesting(body);
		}
		case \do(Statement body, Expression condition):{
			result += 1;
			countIfNesting(body);
		}
		case \while(Expression condition, Statement body):{
			result += 1;
			countIfNesting(body);
		}
		case \switch(Expression expression, list[Statement] statements):{
			result += 1;
			for(s <- statements){
				countIfNesting(s);
			}			
		}
		case \catch(Declaration exception, Statement body):{
			result += 1;
			countIfNesting(body);
		}
	}

	return result;
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