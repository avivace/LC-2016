echo -e "\e[34mJFLEX\e[39m"
./jf.sh
echo -e "\e[34mJFLEX out:\e[39m"
cat flexout.txt
echo -e "\e[34mBYACCJ\e[39m"
byaccj -J project.y
echo -e "\e[34mJAVAC\e[39m"
javac *.java
echo -e "\e[34mRunning Parser..\e[39m"
java -cp . Parser input.txt > output.txt
echo -e "\n\e[34mInput:\e[39m"
cat input.txt
echo -e "\n\e[34mOutput:\e[39m"
cat output.txt
echo -e "\n"

