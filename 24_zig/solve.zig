const std = @import("std");
const Allocator = std.mem.Allocator;

// Axial coordinates
// https://www.redblobgames.com/grids/hexagons/#coordinates-axial
const Axial = struct {
    x: i32 = 0,
    y: i32 = 0,

    pub fn add(self: Axial, v: Axial) Axial {
        return self.addXY(v.x, v.y);
    }

    pub fn addXY(self: Axial, x: i32, y: i32) Axial {
        return Axial{.x=self.x + x, .y=self.y+y};
    }

    pub fn getAdjacent(self: Axial) [6]Axial {
        return .{
            self.addXY(0, 1),
            self.addXY(0, -1),
            self.addXY(1, 0),
            self.addXY(-1, 0),
            self.addXY(1, -1),
            self.addXY(-1, 1),
        };
    }
};

fn parseVectors(s: []const u8, a: *Allocator) ![]Axial {
    var v = std.ArrayList(Axial).init(a);
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
        try v.append(Axial{
            .x=if (we*ns>0) 0 else we,
            .y=ns
        });
    }

    return v.toOwnedSlice();
}

const hashVec = std.hash_map.getAutoHashFn(Axial);
const eqlVec = std.hash_map.getAutoEqlFn(Axial);
const Floor = std.HashMap(Axial, bool, hashVec, eqlVec, 80);

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

fn readInput(a: *Allocator) ![][]Axial {
    var list = std.ArrayList([]Axial).init(a);
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

fn followPath(path: []const Axial) Axial {
    var res = Axial{.x=0, .y=0};
    for (path) |v| {
        res = res.add(v);
    }
    return res;
}

fn solve_1(paths: [][]const Axial, floor: *Floor) !usize {
    for (paths) |path| {
        var dest = followPath(path);
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
        for (entry.key.getAdjacent()) |v| {
            try pending.put(v, floor.get(v) orelse false);
        }
    }

    it = pending.iterator();
    while (it.next()) |entry| {
        var count: u8 = 0;
        for (entry.key.getAdjacent()) |v| {
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
