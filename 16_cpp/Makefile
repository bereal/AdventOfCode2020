SRC=data.cpp solve.cpp
OBJ=$(subst .cpp,.o, $(SRC))

solve: $(OBJ)
	g++ -g $(OBJ) -o $@

%.o: %.cpp
	gcc -c $<
