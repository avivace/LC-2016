del *.java~
del *.java
del *.class
yacc -J pzero.y
start jflex pzero.flex 
javac *.java
java -cp . Parser input.txt > output.txt
@echo off
echo finished