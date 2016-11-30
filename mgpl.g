grammar mgpl;

options { backtrack=true; }

NUMBER	:	('0' | ('1'..'9') ('0'..'9')* );
IDF	:	('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
COMMENT	:	'//' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;};

prog 	:	'game' IDF '(' attrasslist? ')' decl* stmtblock block*;
decl	:	vardecl ';' | objdecl ';';
vardecl	:	('int' IDF init? | 'int' IDF '[' NUMBER ']');
init	:	'=' expr;
objdecl	:	objtype IDF '(' attrasslist? ')' | objtype IDF '[' NUMBER ']';
objtype	:	'rectangle' | 'triangle' | 'circle';
attrasslist	:	attrass ',' attrasslist | attrass;
attrass	:	IDF '=' expr;
block	:	animblock | eventblock;
animblock	:	'animation' IDF '(' objtype IDF ')' stmtblock;
eventblock	:	'on' keystroke stmtblock;
keystroke	:	'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarror';
stmtblock	:	'{' stmt* '}';
stmt	:	ifstmt | forstmt | assstmt;
ifstmt	:	'if' '(' expr ')' stmtblock ( 'else' stmtblock)?;
forstmt	:	'for' '(' assstmt ';' expr ';' assstmt ')' stmtblock;
assstmt	:	var '=' expr;
var	:	IDF | IDF '[' expr ']' | IDF '.' IDF | IDF '[' expr ']' '.' IDF;
expr	:	(NUMBER | var | var 'touches' var | '-' expr | '!' expr | '(' expr ')') (op expr)*;
op	:	'||' | '&&'| '==' | '<' | '<=' | '+' | '-' | '*' | '/';