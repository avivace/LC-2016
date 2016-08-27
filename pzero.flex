// ANTONIO VIVACE - 793509
%%

%byaccj

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

%x WAITING_CDATA_DBLQ WAITING_CDATA_DBLQ2 WAITING_PCDATA IN_ATTRIBUTE 

NL = [\r\n\t ]*		// Absorb tabs and spaces
XML = {NL}"<?xml"[^>]*">"{NL}
DOCTYPE = {NL}"<!DOCTYPE"[^>]*">"{NL}
CLOSE_ANG = {NL}">"{NL}
CLOSE_ANG2 = {NL}">"{NL}
CLOSE_ANG3 = {NL}\/>{NL} 	//	INLINE CLOSE (empty elements)
ATT_SEPARATOR = {NL}"="{NL}		

// Property names
ID = {NL}"id"{NL}
REASON = {NL}"reason"{NL}
NAME =  {NL}"name"{NL}
VALUE =  {NL}"value"{NL}
TYPE =  {NL}"type"{NL}
TITLE = {NL}"title"{NL}
CAPTION = {NL}"caption"{NL}
PATH = {NL}"path"{NL}
TARGET = {NL}"target"{NL}

MESSAGE_OPEN = {NL}"<message"{NL}
MESSAGE_CLOSE = {NL}"</message>"{NL}

HEADER_OPEN = {NL}"<header>"{NL}	// 0P
HEADER_CLOSE = {NL}"</header>"{NL}

// Inline
TYPE_OPEN = {NL}"<type"{NL}
METADATA_OPEN = {NL}"<metadata"{NL}
FORMAT_OPEN = {NL}"<format"{NL}
FIGURE_OPEN = {NL}"<figure"{NL}

DATA_OPEN = {NL}"<data>"{NL} // 0P
DATA_CLOSE ={NL}"</data>"{NL}

SECTION_OPEN = {NL}"<section"{NL}
SECTION_CLOSE = {NL}"</section>"{NL}

PARAGRAPH_OPEN = {NL}"<paragraph>"{NL} //0P
PARAGRAPH_CLOSE = {NL}"</paragraph>"{NL}

TABLE_OPEN = {NL}"<table"{NL}
TABLE_CLOSE = {NL}"</table>"{NL}

ROW_OPEN = {NL}"<row"{NL}
ROW_CLOSE = {NL}"</row>"{NL}

CELL_OPEN = {NL}"<cell>"{NL}	// 0P
CELL_CLOSE = {NL}"</cell>"{NL}

ANCHOR_OPEN = {NL}"<anchor"{NL}
ANCHOR_CLOSE = {NL}"</anchor>"{NL}

LINK_OPEN = {NL}"<link"{NL}
LINK_CLOSE = {NL}"</link>"{NL}


TYPE_ID = {NL}\"(normal|forward|reply)\"{NL}
FORMAT_TYPE = {NL}\"(plain|structured)\"{NL}
PCDATA = [^<>]*
CDATA_DBLQ = \"([^\"]*)\"



%%

{NL}	{ return Parser.NL; }
{XML}	{ return Parser.XML; }
{DOCTYPE} { return Parser.DOCTYPE; }
{ID} { return Parser.ID; }
{NAME} { return Parser.NAME; }
{VALUE} { return Parser.VALUE; }
{REASON} { return Parser.REASON; }
{TYPE} { return Parser.TYPE; }
{TITLE} { return Parser.TITLE; }
{PATH} { return Parser.PATH; }
{CAPTION} { return Parser.CAPTION; }

{CLOSE_ANG}    { return Parser.CLOSE_ANG; }
{CLOSE_ANG2}    { return Parser.CLOSE_ANG2; }
{CLOSE_ANG3}    { return Parser.CLOSE_ANG3; }

{ATT_SEPARATOR}    { yybegin(WAITING_CDATA_DBLQ);
					 return Parser.ATT_SEPARATOR; }

{MESSAGE_OPEN}    { return Parser.MESSAGE_OPEN; }
{MESSAGE_CLOSE}    { return Parser.MESSAGE_CLOSE; }
{HEADER_OPEN} { return Parser.HEADER_OPEN; }
{HEADER_CLOSE} { return Parser.HEADER_CLOSE; }
{DATA_OPEN} { yybegin(WAITING_PCDATA);
			  return Parser.DATA_OPEN; }
{PARAGRAPH_OPEN} { yybegin(WAITING_PCDATA);
	return Parser.PARAGRAPH_OPEN; }
{DATA_CLOSE} { return Parser.DATA_CLOSE; }
{PARAGRAPH_CLOSE} { return Parser.PARAGRAPH_CLOSE; }
{SECTION_OPEN}	{ return Parser.SECTION_OPEN; }
{SECTION_CLOSE} { return Parser.SECTION_CLOSE; }
<WAITING_PCDATA>{SECTION_CLOSE} { return Parser.SECTION_CLOSE; }
{TYPE_OPEN} { return Parser.TYPE_OPEN; }
{METADATA_OPEN} { return Parser.METADATA_OPEN; }
{FORMAT_OPEN} { return Parser.FORMAT_OPEN; }
{FIGURE_OPEN} { return Parser.FIGURE_OPEN; }


<WAITING_CDATA_DBLQ>{TYPE_ID}		{ yyparser.yylval = new ParserVal(yytext());
									  yybegin(YYINITIAL);
									  return Parser.TYPE_ID; }
<WAITING_CDATA_DBLQ>{FORMAT_TYPE}		{ yyparser.yylval = new ParserVal(yytext());
									  yybegin(YYINITIAL);
									  return Parser.FORMAT_TYPE; }
<WAITING_CDATA_DBLQ>{CDATA_DBLQ}	{ yyparser.yylval = new ParserVal(yytext());
									  yybegin(YYINITIAL);
									  return Parser.CDATA_DBLQ; }
<WAITING_PCDATA>{PCDATA}	{ yyparser.yylval = new ParserVal(yytext());
						      yybegin(YYINITIAL);
			  				  return Parser.PCDATA; }
<WAITING_PCDATA>{SECTION_OPEN}	{ return Parser.SECTION_OPEN; }