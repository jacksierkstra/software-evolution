module FindComplexFiles

import List;
import Exception;
import ParseTree;
import util::FileSystem;
import lang::java::\syntax::Disambiguate;
import lang::java::\syntax::Java15;

import CalculateCC;

lrel[int cc, loc method] findComplexFiles(loc project, int limit = 10) {
  findComplexFiles(project, limit);
}

lrel[int cc, loc method] findComplexFiles(loc project, int limit) {
  return head(findAllComplexFiles(project), limit);
}

lrel[int cc, loc method] findAllComplexFiles(loc project) {
  result = [*maxCC(f) | /file(f) <- crawl(project), f.extension == "java"];	
  result = sort(result, bool (<int a, loc _>, <int b, loc _>) { return a < b; });
  return reverse(result);
}

set[MethodDec] allMethods(loc file) 
  = {m | /MethodDec m := parse(#start[CompilationUnit], file)};

lrel[int cc, loc method] maxCC(loc file) 
  = [<cyclomaticComplexity(m), m@\loc> | m <- allMethods(file)];