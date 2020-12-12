#!/usr/bin/env ruby


class Position
    def initialize()
        @x = 0
        @y = 0
        @angle = 0
    end

    def move(dx, dy)
        @x += dx
        @y += dy
    end

    def move_relative(dist)
        case @angle
        when 0 then
            move(dist, 0)
        when 90
            move(0, dist)
        when 180
            move(-dist, 0)
        when 270
            move(0, -dist)
        end
    end

    def rotate(angle)
        @angle = (@angle + angle) % 360
    end

    def command(name, arg)
        case name
            when 'F' then move_relative(arg)
            when 'B' then move_relative(-arg)
            when 'N' then move(0, -arg)
            when 'S' then move(0, arg)
            when 'W' then move(-arg, 0)
            when 'E' then move(arg, 0)
            when 'R' then rotate(arg)
            when 'L' then rotate(-arg)
        end
    end

    def distance
        @x.abs + @y.abs
    end
end

pos = Position.new

ARGF.each_line do |line|
    cmd = line[0]
    arg = line[1...].to_i
    pos.command(cmd, arg)
end

puts pos.distance

