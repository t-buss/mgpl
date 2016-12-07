grammar mgpl;

options { backtrack=false; output=AST; }

NUMBER	:	('0' | ('1'..'9') ('0'..'9')* );
IDF	:	('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
COMMENT	:	'//' ~('\n'|'\r')* '\r'? '\n' {skip();};

prog 	:	'game' IDF '('! attrasslist? ')'! decl* stmtblock block*;
decl	:	vardecl ';'! | objdecl ';'!;
vardecl	:	('int' IDF init? | 'int' IDF '[' NUMBER ']');
init	:	'=' expr;
objdecl	:	objtype IDF '('! attrasslist? ')'! | objtype IDF '[' NUMBER ']';
objtype	:	'rectangle' | 'triangle' | 'circle';

//attrasslist	:	attrass ',' attrasslist | attrass;
attrasslist
	:	attrass attrasslist2;
attrasslist2
	:	| ',' attrasslist;
attrass	:	IDF '=' expr;

block	:	animblock | eventblock;
animblock	:	'animation' IDF '('! objtype IDF ')'! stmtblock;
eventblock	:	'on' keystroke stmtblock;
keystroke	:	'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow';
stmtblock	:	'{'! stmt* '}'!;
stmt	:	ifstmt | forstmt | assstmt ';'!;
ifstmt	:	'if' '('! expr ')'! stmtblock ( 'else' stmtblock)?;
forstmt	:	'for' '('! assstmt ';' expr ';' assstmt ')'! stmtblock;
assstmt	:	var '=' expr;

//var	:	IDF | IDF '[' expr ']' | IDF '.' IDF | IDF '[' expr ']' '.' IDF;
var	:	IDF var2;
var2	:	| '.' IDF |'[' expr ']' var3 ;
var3	:	| '.' IDF;

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