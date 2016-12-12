grammar mgpl;

options { backtrack=false; output=AST; }
tokens { THEN;ELSE;GAME;DECLARATIONS;STMTBLOCK;BLOCKS;VAR;VARARRAY;OBJ;ATTRIBUTELIST;ATTRIBUTE;HEADER;DO;CONDITION;ASSIGNMENT;AFTERTHOUGHT;OBJECT;OBJECTARRAY;VALUE;INIT;INDEX;}


NUMBER	:	('0' | ('1'..'9') ('0'..'9')* );
IDF	:	('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
COMMENT	:	'//' ~('\n'|'\r')* '\r'? '\n' {skip();};

prog 	:	'game' IDF '(' attrasslist? ')' decl* stmtblock block*
		-> ^(GAME ^(DECLARATIONS decl*) ^(STMTBLOCK stmtblock) ^(BLOCKS block*));
decl	:	vardecl ';'! | objdecl ';'!;
vardecl	:	'int' IDF init? -> ^(VAR IDF ^(INIT init)?) 
		| 'int' IDF '[' NUMBER ']' -> ^(VARARRAY IDF);
init	:	'=' expr;
objdecl	:	objtype IDF '(' attrasslist? ')' -> ^(OBJECT objtype IDF attrasslist?)
		| objtype IDF '[' NUMBER ']' -> ^(OBJECTARRAY objtype IDF);
objtype	:	'rectangle' | 'triangle' | 'circle';

attrasslist :	attrass (',' attrass)*
		->^(ATTRIBUTELIST attrass attrass*);
attrass	:	IDF '=' expr
		->^(ATTRIBUTE IDF '=' expr);

block	:	animblock | eventblock;
animblock	:	'animation'^ IDF '('! objtype IDF ')'! stmtblock;
eventblock	:	'on' keystroke^ stmtblock;
keystroke	:	'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow';
stmtblock	:	'{'! stmt* '}'!;
stmt	:	ifstmt | forstmt | assstmt ';'!;
ifstmt	:	'if' '(' expr ')' s1=stmtblock ('else' s2=stmtblock)?
		-> ^('if' ^(CONDITION expr) ^(THEN $s1) ^(ELSE $s2)?);
forstmt	:	'for' '(' assstmt ';' expr ';' assstmt ')' stmtblock
		-> ^('for' ^(HEADER ^(INIT assstmt) ^(CONDITION expr) ^(AFTERTHOUGHT assstmt)) ^(DO stmtblock));
assstmt	:	var '=' expr -> ^(ASSIGNMENT var ^(VALUE expr));

//var	:	IDF | IDF '[' expr ']' | IDF '.' IDF | IDF '[' expr ']' '.' IDF;
var	:	IDF var2? -> ^(VAR IDF var2?);
var2	:	'.' IDF |'[' expr ']' var3? -> ^(INDEX expr) var3? ;
var3	:	'.' IDF;

//expr	:	(NUMBER | var | var 'touches' var | '-' expr | '!' expr | '(' expr ')') (op expr)*;
expr	:	orexpr;
orexpr	:	andexpr ('||'^ andexpr)*;
andexpr	:	relexpr ('&&'^ relexpr)*;
relexpr	:	addexpr (relop^ addexpr)*;
addexpr	:	multexpr (addop^ multexpr)*;
multexpr:	unexpr (multop^ unexpr)*;
unexpr	:	unop? atomexpr;
//atomexpr:	NUMBER | var | var 'touches' var | '(' expr ')';
atomexpr:	NUMBER | '('!expr')'! |var atomexpr2;
atomexpr2
	:	| 'touches' var;


relop	:	'==' | '<' | '<=';
addop	:	'+' | '-' ;
multop	:	'*' | '/';
unop	:	'!' | '-';