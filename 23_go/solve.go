package main

import (
	"fmt"
	"os"
	"strconv"
)

type list []int

func (l list) turn(cur int) int {
	m1 := l[cur]
	m2 := l[m1]
	m3 := l[m2]

	removedVals := map[int]bool{m1: true, m2: true, m3: true}
	newTail := l[m3]

	dest := cur - 1
	for dest == 0 || removedVals[dest] {
		dest--
		if dest <= 0 {
			dest = len(l) - 1
		}
	}

	l[cur] = newTail
	l[m3] = l[dest]
	l[dest] = m1
	return l[cur]
}

func (l list) getN(i, n int) []int {
	result := make([]int, 0, n)
	for j := 0; j < n; j++ {
		result = append(result, i)
		i = l[i]
	}
	return result
}

func createList(seed []int, max int) list {
	if len(seed) > max {
		max = len(seed)
	}

	result := make([]int, max+1)
	var last int
	for i := 1; i < len(seed); i++ {
		result[seed[i-1]] = seed[i]
		last = seed[i]
	}

	for i := len(seed) + 1; i <= max; i++ {
		result[last] = i
		last = i
	}

	result[last] = seed[0]
	return result
}

func parseInput(s string) []int {
	var input []int
	for _, v := range s {
		i, _ := strconv.Atoi(string(v))
		input = append(input, i)
	}
	return input
}

func run(seed []int, max int, rounds int) list {
	state := createList(seed, max)
	cur := seed[0]
	for i := 0; i < rounds; i++ {
		cur = state.turn(cur)
	}
	return state
}

func solve1(seed []int) int {
	state := run(seed, 0, 100)
	res := 0
	for _, v := range state.getN(1, 9)[1:] {
		res = res*10 + v
	}
	return res
}

func solve2(seed []int) int64 {
	list := run(seed, 1_000_000, 10_000_000)
	cups := list.getN(1, 3)
	return int64(cups[1]) * int64(cups[2])
}

func main() {
	seed := parseInput(os.Args[1])
	fmt.Printf("%d %d\n", solve1(seed), solve2(seed))
}
