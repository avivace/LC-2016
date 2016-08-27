// ANTONIO VIVACE 793509
%{
  import java.io.*;
%}

%token NL XML DOCTYPE CLOSE_ANG CLOSE_ANG3 ATT_SEPARATOR ID REASON NAME VALUE TYPE TITLE CAPTION PATH TARGET MESSAGE_OPEN MESSAGE_CLOSE HEADER_OPEN HEADER_CLOSE TYPE_OPEN METADATA_OPEN FORMAT_OPEN FIGURE_OPEN 
%token SECTION_OPEN SECTION_CLOSE PARAGRAPH_OPEN PARAGRAPH_CLOSE TABLE_OPEN TABLE_CLOSE ROW_OPEN ROW_CLOSE CELL_OPEN CELL_CLOSE ANCHOR_OPEN ANCHOR_CLOSE LINK_OPEN LINK_CLOSE DATA_OPEN DATA_CLOSE
%token<sval> PCDATA CDATA_DBLQ TYPE_ID FORMAT_TYPE
%type<sval> message header type metadatas metadata format id name value data section sectionc 
%type<sval> title paragraph figure table row cell anchor path datas datac caption
%type<sval> dat

%%
begin : XML DOCTYPE message     { System.out.println($3); }
message : MESSAGE_OPEN id CLOSE_ANG header datac MESSAGE_CLOSE { $$ = "{\n\t\"tag\": \"message\","+ "\n\t\"@id\": " + $2 + ",\n\t\"content\": [\n" + $4 +","+ $5 + "\n\t]\n}"; }
header : HEADER_OPEN type metadatas format HEADER_CLOSE {$$="\t\t{\n\t\t\"tag\": \"header\","+ "\n\t\t\"content\": [\n" + $2 + "\n"+ $3 + $4 + "\t\t]\n\t\t}";}

type : TYPE_OPEN ID ATT_SEPARATOR TYPE_ID REASON ATT_SEPARATOR CDATA_DBLQ CLOSE_ANG3 {$$ = "\t\t\t{\n\t\t\t\t\"tag\": \"type\","+"\n\t\t\t\t\"@id\": " + $4 + ","+ "\n\t\t\t\t\"@reason\": " + $7 + "\n\t\t\t},";}
     | TYPE_OPEN ID ATT_SEPARATOR TYPE_ID CLOSE_ANG3; {$$ = "\t\t\t{\n\t\t\t\t\"tag\": \"type\","+"\n\t\t\t\t\"@id\": " + $4 + ","+ "\n\t\t\t\t\"@reason\": \"\",";} //reason default when not present
metadatas :
          | metadatas metadata { $$ = $1+$2;}
          | metadata; { $$ = $1;}
metadata : METADATA_OPEN id name value CLOSE_ANG3 {$$ = "\t\t\t{\n\t\t\t\t\"tag\": \"metadata\","+"\n\t\t\t\t\"@id\": " + $2 + ","+ "\n\t\t\t\t\"@name\": " + $3 + ",\n\t\t\t\t\"@value\": " + $4 + "\n\t\t\t},\n";} //SHOW VALUE, TOO!
         | METADATA_OPEN id name CLOSE_ANG3; {$$ = "\t\t\t{\n\t\t\t\t\"tag\": \"metadata\","+"\n\t\t\t\t\"@id\": " + $2 + ","+ "\n\t\t\t\t\"@name\": " + $3 + ",\n\t\t\t\t\"@value\": " + "\"\"" + "\n\t\t\t},";}
format : {$$ = "\t\t\t{\n\t\t\t\t\"tag\": \"format\","+"\n\t\t\t\t\"@type\": " + "\"plain\"" + "\n\t\t\t}\n";} //format default when not present
       | FORMAT_OPEN TYPE ATT_SEPARATOR FORMAT_TYPE CLOSE_ANG3; {$$ = "\t\t\t{\n\t\t\t\t\"tag\": \"format\","+"\n\t\t\t\t\"@type\": " + $4 + "\n\t\t\t}\n";}

/*datas : datas datac { $$ = $1+$2;}
      | datac; { $$ = $1;}*/
datac : DATA_OPEN data DATA_CLOSE {$$="\n\t\t{\n\t\t\"tag\": \"data\","+ "\n\t\t\"content\": [\n\t\t\t" + $2 + "\t\t]\n\t\t}";}
data : PCDATA section {$$ = "\t\t\t\t\""+$1+"\"\n"+$2;}
     | PCDATA {$$ = "\t\t\t\t\""+$1+"\"\n";}
     | section
section : SECTION_OPEN id title CLOSE_ANG sectionc SECTION_CLOSE {$$ = "\t\t\t{\n\t\t\t\t\"tag\": \"section\","+"\n\t\t\t\t\"@id\": " + $2 + ","+ "\n\t\t\t\t\"@title\": " + $3 + "\n\t\t\t\t\"content\": [\n\t\t\t" + $5 + "\n\t\t\t\t]\n\t\t\t},\n";}
sectionc : 
         | paragraph sectionc {$$="\t\t\t{\n\t\t\t\t\t\t\"tag\": \"paragraph\"," + "\n\t\t\t\t\t\t\"content\": [\n\t\t\t\t\t" + $1 + "\n\t\t\t\t\t\t]\n\t\t\t\t},\n"+$2;}
         | figure sectionc; {$$=$1;}
figure : FIGURE_OPEN ID ATT_SEPARATOR CDATA_DBLQ path CLOSE_ANG3 {$$="\t\t\t\t\t\t{\n\t\t\t\t\t\t\"tag\": \"figure\","+"\t\t\t\n\t\t\t\t\t\t\"id\":"+$4+","+"\t\t\t\n\t\t\t\t\t\t\"path\":"+ $5+"\n\t\t\t\t\t\t}";}
paragraph : PARAGRAPH_OPEN PCDATA PARAGRAPH_CLOSE {$$ = "\t\t"+$2;}

id : ID ATT_SEPARATOR CDATA_DBLQ { $$ = $3;}
name : NAME ATT_SEPARATOR CDATA_DBLQ { $$ = $3;}
value : VALUE ATT_SEPARATOR CDATA_DBLQ { $$ = $3;}
title : TITLE ATT_SEPARATOR CDATA_DBLQ { $$ = $3;}
path : { $$ = "placeholder.jpg";}
     | PATH ATT_SEPARATOR CDATA_DBLQ; { $$ = $3;}
caption :
        | CAPTION ATT_SEPARATOR CDATA_DBLQ;

/*
metadata : METADATA_OPEN id name value CLOSE_ANG3
id : ID ATT_SEPARATOR CDATA_DBLQ
name : NAME ATT_SEPARATOR CDATA_DBLQ
value : VALUE ATT_SEPARATOR CDATA_DBLQ
path : PATH ATT_SEPARATOR CDATA_DBLQ
caption : CAPTION ATT_SEPARATOR CDATA_DBLQ
target : todo
title : todo

format : FORMAT_OPEN TYPE ATT_SEPARATOR FORMAT_TYPES CLOSE_ANG3
datas: DATA_OPEN data DATA_CLOSE
data : data PCDATA
     | data section
     | PCDATA
     | section
     | ;
sections : SECTION_OPEN section SECTION_CLOSE
section : section PCDATA
        | section paragraph
        | section figure
        | section table
        | section anchor
        | section link
        | PCDATA
        | paragraph
        | figure
        | table
        | anchor
        | link
        | section
        | ;

paragraph : PARAGRAPH_OPEN PCDATA PARAGRAPH_CLOSE
figure : FIGURE_OPEN id caption path CLOSE_ANG3
table : TABLE_OPEN id caption CLOSE_ANG rows TABLE_CLOSE
rows : rows row
     | row;
row : OPEN_ROW cells CLOSE_ROW
cells : cells cell
      | cell;
cell : PCDATA
anchor : OPEN_ANCHOR id CLOSE_ANG PCDATA CLOSE_ANCHOR
link : OPEN_LINK target title CLOSE_ANG PCDATA CLOSE_LINK
*/

%%
  private Yylex lexer;


  private int yylex () { // used by the parser to get the lexer tokens
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


  public void yyerror (String error) { // catch errors
    System.err.println ("Error: " + error);
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }

  public static void main(String args[]) throws IOException {
    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
      yyparser.yyparse();
    }
    else {
      System.out.println("ERROR: Provide an input file as Parser argument");
    }
  }
