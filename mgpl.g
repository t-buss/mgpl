grammar mgpl;

options { backtrack=true; }

number 	:	('0' | ('1'..'9') ('0'..'9')* );
idf	:	('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
comment	:	'//' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;};

prog 	:	'game' idf '(' attrasslist? ')' decl* stmtblock block*;
decl	:	vardecl ';' | objdecl ';';
vardecl	:	'int' idf init? | 'int' idf '[' number ']';
init	:	'=' expr;
objdecl	:	objtype idf '(' attrasslist? ')' | objtype idf '[' number ']';
objtype	:	'rectangle' | 'triangle' | 'circle';
attrasslist	:	attrass ',' attrasslist | attrass;
attrass	:	idf '=' expr;
block	:	animblock | eventblock;
animblock	:	'animation' idf '(' objtype idf ')' stmtblock;
eventblock	:	'on' keystroke stmtblock;
keystroke	:	'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarror';
stmtblock	:	'{' stmt* '}';
stmt	:	ifstmt | forstmt | assstmt;
ifstmt	:	'if' '(' expr ')' stmtblock ( 'else' stmtblock)?;
forstmt	:	'for' '(' assstmt ';' expr ';' assstmt ')' stmtblock;
assstmt	:	var '=' expr;
var	:	idf | idf '[' expr ']' | idf '.' idf | idf '[' expr ']' '.' idf;
expr	:	number | var | var 'touches' var | '-' expr | '!' expr | '(' expr ')' | expr op expr;
op	:	'||' | '&&'| '==' | '<' | '<=' | '+' | '-' | '*' | '/';