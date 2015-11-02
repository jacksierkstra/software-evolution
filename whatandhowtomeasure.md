# What do we need to measure?

### Volume
Lines of code (without blank lines and comments)

### Cyclomatic complexity
Cyclomatic complexity is computed using the control flow graph of the program: the nodes of the graph correspond to indivisible groups of commands of a program, and a directed edge connects two nodes if the second command might be executed immediately after the first command. Cyclomatic complexity may also be applied to individual functions, modules, methods or classes within a program.

* We do need to do this on methods.

### Duplication of code
6 lines of duplicated code

Todo:
Define a good strategy of calculating those 6 lines of duplicated code across the project.

##### Strategy #1
Nagedacht over code duplication algoritme
Ook heb ik nagedacht over de duplication. Dit is volgens mij heel erg resource intensive. Hiervoor moeten we volgens mij elke regel opslaan in een aparte lijst (hashtable bijvoorbeeld) en dan bij elke regel na gaan of deze regel al in deze lijst staat. Als dezelfde regel al in de lijst staat, dan moeten we dit in een aparte lijst met tuples zetten met daarbij welke regelnummers in welke bestanden met elkaar overeen komen. Daarna moet het algoritme kijken of de volgende regelnummer in het ene bestand en de volgende regelnummer in het andere bestand ook identiek zijn. Het klinkt misschien nog een beetje vaag, maar ik zal het maandag uitleggen. Misschien heb jij een beter idee, dan hoor ik het graag.

##### Resources
http://www.bauhaus-stuttgart.de/clones/CloneDR_ICSM98_IEEE_Copyright.pdf

### Unit Size
Lines of code per method.

## Optional:

### Unit testing
Measure code coverage that are covered by unit tests. Hence: there must be `assert's` in the code.

There need to be asserts in the code to actually test the coverage of the tests. Otherwise you can cheat this method by getting a high coverage by just calling functions.

# Results:
After all of this, we can plot these values of the outcomes to the following table:

| | Volume | Complexity per unit | Duplication | Unit Size | Unit testing  |
|--:|--:|------------- |:-------------:| -----:|---:|
| Analysability | X |  | X | X | X | 
| Changeability |  | X | X |  |
| Stability	   |  |  |  |  | X |
| Testability   |  | X |  | X | X |
