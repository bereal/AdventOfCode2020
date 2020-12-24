const std = @import("std");
const Allocator = std.mem.Allocator;

const Vec = struct { x: i32, y: i32 };

fn addVec(v1: Vec, v2: Vec) Vec {
    return Vec{.x=v1.x + v2.x, .y=v1.y+v2.y};
}

fn followPath(path: []const Vec) Vec {
    var res = Vec{.x=0, .y=0};
    for (path) |v| {
        res = addVec(res, v);
    }
    return res;
}

fn getAdjacent(v: Vec) [6]Vec {
    const x = v.x;
    const y = v.y;
    return .{
        Vec{.x=x+1, .y=y-1},
        Vec{.x=x+1, .y=y},
        Vec{.x=x, .y=y-1},
        Vec{.x=x-1, .y=y+1},
        Vec{.x=x-1, .y=y},
        Vec{.x=x, .y=y+1},
    };
}

fn parseVectors(s: []const u8, a: *Allocator) ![]Vec {
    var v = std.ArrayList(Vec).init(a);
    defer v.deinit();

    var i: usize = 0;
    while (i < s.len) {
        var we: i32  = 0;
        var ns: i32 = 0;
        while (we == 0): (i+=1) {
            switch (s[i]) {
                'w' => we = -1,
                'e' => we = 1,
                'n' => ns = -1,
                's' => ns = 1,
                else => {},
            }
        }
        try v.append(Vec{
            .x=if (we*ns>0) 0 else we,
            .y=ns
        });
    }

    return v.toOwnedSlice();
}

const hashVec = std.hash_map.getAutoHashFn(Vec);
const eqlVec = std.hash_map.getAutoEqlFn(Vec);
const Floor = std.HashMap(Vec, bool, hashVec, eqlVec, 80);

// remove white tiles
fn cleanup(floor: *Floor) void {
    var it = floor.iterator();
    while (it.next()) |entry| {
        if (!entry.value) {
            // not sure if this is safe, but seems to work
            _ = floor.remove(entry.key);
        }
    }
}

fn readInput(a: *Allocator) ![][]Vec {
    var list = std.ArrayList([]Vec).init(a);
    defer list.deinit();

    var input = try std.io.getStdIn().readToEndAlloc(a, 1 << 20);
    var it = std.mem.split(input, "\n");
    while (it.next()) |line| {
        if (line.len > 0) {
            try list.append(try parseVectors(line, a));
        }
    }
    return list.toOwnedSlice();
}

fn solve_1(in: [][]const Vec, floor: *Floor) !usize {
    for (in) |route| {
        var dest = followPath(route);
        var cur = try floor.getOrPut(dest);
        cur.entry.value = if (cur.found_existing) !cur.entry.value else true;
    }

    cleanup(floor);
    return floor.count();
}

fn lifeTurn(floor: *Floor, a: *Allocator) !void {
    var pending = Floor.init(a);
    defer pending.deinit();

    var it = floor.iterator();
    while (it.next()) |entry| {
        try pending.put(entry.key, entry.value);
        for (getAdjacent(entry.key)) |v| {
            try pending.put(v, floor.get(v) orelse false);
        }
    }

    it = pending.iterator();
    while (it.next()) |entry| {
        var count: u8 = 0;
        for (getAdjacent(entry.key)) |v| {
            if (pending.get(v) orelse false) { count += 1; }
        }
        if ((entry.value and (count == 0 or count > 2)) or (!entry.value and count == 2)) {
            try floor.put(entry.key, !entry.value);
        }
    }

    cleanup(floor);
}

fn solve_2(floor: *Floor, a: *Allocator) !usize {
    var i: u8 = 0;
    while (i < 100): (i+=1) { try lifeTurn(floor, a); }
    return floor.count();
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var mem = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer mem.deinit();

    var input = try readInput(&mem.allocator);
    var floor = Floor.init(&mem.allocator);

    const s1 = try solve_1(input, &floor);
    const s2 = try solve_2(&floor, &mem.allocator);
    try stdout.print("{} {}\n", .{s1, s2});
}
