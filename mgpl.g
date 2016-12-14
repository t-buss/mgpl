grammar mgpl;

options { backtrack=false; output=AST; k=3; }
tokens { 
	GAME;
	DECLARATIONS;
	BLOCKS;
	STMTBLOCK;
	VAR;
	VARARRAY;
	ATTRIBUTELIST;
	ATTRIBUTE;
	HEADER;
	INIT;
	CONDITION;
	AFTERTHOUGHT;
	DO;
	OBJECT;
	OBJECTARRAY;
	TYPE;
	VALUE;
	INDEX;
	THEN;
	ELSE;
	ASSIGNMENT;
	LEER;
	EVENT;
}


NUMBER	:	('0' | ('1'..'9') ('0'..'9')* );
IDF	:	('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
COMMENT	:	'//' ~('\n'|'\r')* '\r'? '\n' {skip();};

prog 	:	'game' IDF '(' attrasslist? ')' decl* stmtblock block*
		-> ^(GAME ^(DECLARATIONS decl*) stmtblock ^(BLOCKS block*));
decl	:	vardecl ';'! | objdecl ';'!;
vardecl	:	'int' IDF init? -> ^(VAR IDF init?) 
		| 'int' IDF '[' NUMBER ']' -> ^(VARARRAY IDF);
init	:	'=' expr -> ^(INIT expr);
objdecl	:	objtype IDF '(' attrasslist? ')' -> ^(OBJECT objtype IDF attrasslist?)
		| objtype IDF '[' NUMBER ']' -> ^(OBJECTARRAY objtype IDF);
objtype	:	'rectangle' | 'triangle' | 'circle';

attrasslist :	attrass (',' attrass)*
		->^(ATTRIBUTELIST attrass+);
attrass	:	IDF '=' expr
		->^(ATTRIBUTE IDF ^(VALUE expr));

block	:	animblock | eventblock;
animblock:	'animation' IDF '(' objtype IDF ')' stmtblock
		-> ^('animation' IDF ^(OBJECT ^(TYPE objtype) IDF) stmtblock);
eventblock	:	'on' keystroke stmtblock -> ^(EVENT ^('on' keystroke) stmtblock);
keystroke	:	'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow';
stmtblock	:	'{' stmt* '}' -> ^(STMTBLOCK stmt*);
stmt	:	ifstmt | forstmt | assstmt ';'!;
ifstmt	:	'if' '(' expr ')' s1=stmtblock ('else' s2=stmtblock)?
		-> ^('if' ^(CONDITION expr) ^(THEN $s1) ^(ELSE $s2)?);
forstmt	:	'for' '(' assstmt ';' expr ';' assstmt ')' stmtblock
		-> ^('for' ^(HEADER ^(INIT assstmt) ^(CONDITION expr) ^(AFTERTHOUGHT assstmt)) ^(DO stmtblock));
assstmt	:	var '=' expr -> ^(ASSIGNMENT var ^(VALUE expr));

var	:	IDF var2? -> ^(VAR IDF var2?);
var2	:	'.' IDF |'[' expr ']' var3? -> ^(INDEX expr) var3? ;
var3	:	'.' IDF;

expr	:	orexpr;
orexpr	:	andexpr ('||'^ andexpr)*;
andexpr	:	relexpr ('&&'^ relexpr)*;
relexpr	:	addexpr (relop^ addexpr)*;
addexpr	:	multexpr (addop^ multexpr)*;
multexpr:	unexpr (multop^ unexpr)*;
unexpr	:	unop? atomexpr;
atomexpr:	NUMBER | '('!expr')'! |var atomexpr2;
atomexpr2:	| 'touches' var;


relop	:	'==' | '<' | '<=';
addop	:	'+' | '-' ;
multop	:	'*' | '/';
unop	:	'!' | '-';