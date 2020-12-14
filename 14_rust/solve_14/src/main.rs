#[macro_use]
extern crate lazy_static;
extern crate reduce;
extern crate regex;

use regex::Regex;
use std::collections::HashMap;
use std::io;
use std::io::BufRead;

struct Mask {
    or: u64,
    and: u64,
    float: u64,
}

impl Mask {
    fn empty() -> Mask {
        Mask {
            and: u64::MAX,
            or: 0,
            float: 0,
        }
    }

    fn apply(&self, value: u64) -> u64 {
        value & self.and | self.or
    }

    fn float(&self, value: u64) -> FloatingIterator {
        let mut float = self.float;
        let mut initial = 0;
        while float != 0 {
            if float & 1 != 0 {
                initial = (initial << 1) + 1;
            }
            float >>= 1;
        }

        FloatingIterator {
            base: value | self.or,
            float: self.float,
            cur: initial,
            end: false,
        }
    }
}

struct FloatingIterator {
    base: u64,
    float: u64,
    cur: u32,
    end: bool,
}

impl Iterator for FloatingIterator {
    type Item = u64;

    fn next(&mut self) -> Option<u64> {
        if self.end {
            None
        } else {
            let mut float_bit = 1 << 35;
            let mut cur = self.cur;
            let mut and = u64::MAX;
            let mut or = 0;

            while float_bit != 0 {
                let (and_upd, or_upd, shift) = match (float_bit & self.float, cur & 1) {
                    (0, _) => (1, 0, 0),
                    (_, 1) => (0, 0, 1),
                    (_, _) => (1, 1, 1),
                };
                and = (and << 1) | and_upd;
                or = (or << 1) | or_upd;
                cur >>= shift;
                float_bit >>= 1;
            }
            if self.cur == 0 {
                self.end = true;
            } else {
                self.cur -= 1;
            }
            Some(self.base & and | or)
        }
    }
}

struct Assignment {
    address: u64,
    value: u64,
}

enum Instruction {
    SetMask(Mask),
    Assign(Assignment),
}

use Instruction::*;

fn parse_mask(line: &String) -> Option<Instruction> {
    lazy_static! {
        static ref RE: Regex = Regex::new(r"mask = ([10X]+)").unwrap();
    }

    let cap = RE.captures(line.as_str())?;
    let mut and: u64 = 0xffffffffffff;
    let mut or: u64 = 0;
    let mut fluct: u64 = 0;

    for ch in cap[1].chars() {
        let (and_upd, or_upd, fluct_upd) = match ch {
            '1' => (1, 1, 0),
            '0' => (0, 0, 0),
            _ => (1, 0, 1),
        };
        and = (and << 1) | and_upd;
        or = (or << 1) | or_upd;
        fluct = (fluct << 1) | fluct_upd;
    }
    let mask = Mask {
        and: and,
        or: or,
        float: fluct,
    };
    Some(SetMask(mask))
}

fn parse_assignment(line: &String) -> Option<Instruction> {
    lazy_static! {
        static ref RE: Regex = Regex::new(r"mem\[(\d+)\] = (\d+)").unwrap();
    }

    let cap = RE.captures(line.as_str())?;
    let address = cap[1].parse().unwrap();
    let value = cap[2].parse().unwrap();
    Some(Assign(Assignment { address, value }))
}

fn read_input() -> Vec<Instruction> {
    let reader = io::BufReader::new(io::stdin());

    reader
        .lines()
        .map(|line| {
            let line = &line.unwrap();
            parse_mask(line).or_else(|| parse_assignment(line)).unwrap()
        })
        .collect()
}

fn main() {
    let program = read_input();
    let mut mem1: HashMap<u64, u64> = HashMap::new();
    let mut mem2: HashMap<u64, u64> = HashMap::new();
    let mut mask = Mask::empty();

    for command in program {
        match command {
            SetMask(m) => mask = m,
            Assign(a) => {
                mem1.insert(a.address, mask.apply(a.value));
                for addr in mask.float(a.address) {
                    mem2.insert(addr, a.value);
                }
            }
        }
    }

    let sum1: u64 = mem1.values().sum();
    let sum2: u64 = mem2.values().sum();
    println!("{} {}", sum1, sum2);
}
