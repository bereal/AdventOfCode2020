#[macro_use]
extern crate lazy_static;
extern crate reduce;
extern crate regex;

use regex::Regex;
use std::io;
use std::io::BufRead;

struct Mask {
    or: u64,
    and: u64,
}

impl Mask {
    fn new(and: u64, or: u64) -> Mask {
        Mask { or: or, and: and }
    }

    fn apply(&self, value: u64) -> u64 {
        value & self.and | self.or
    }
}

struct Assignment {
    address: usize,
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

    RE.captures(line.as_str()).and_then(|cap| {
        let mut and: u64 = 0xffffffffffff;
        let mut or: u64 = 0;

        for ch in cap[0].chars() {
            let (and_upd, or_upd) = match ch {
                '1' => (1, 1),
                '0' => (0, 0),
                _ => (1, 0),
            };
            and = (and << 1) | and_upd;
            or = (or << 1) | or_upd;
        }
        let mask = Mask::new(and, or);
        Some(SetMask(mask))
    })
}

fn parse_assignment(line: &String) -> Option<Instruction> {
    lazy_static! {
        static ref RE: Regex = Regex::new(r"mem\[(\d+)\] = (\d+)").unwrap();
    }

    RE.captures(line.as_str()).and_then(|cap| {
        let address = cap[1].parse().unwrap();
        let value = cap[2].parse().unwrap();
        Some(Assign(Assignment { address, value }))
    })
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
    let mut mem: [u64; 0xffff] = [0; 0xffff];
    let mut mask = Mask::new(0, 0);

    for command in program {
        match command {
            SetMask(m) => mask = m,
            Assign(a) => mem[a.address] = mask.apply(a.value),
        }
    }

    let sum: u64 = mem.iter().sum();
    println!("{}", sum);
}
