#!/usr/bin/env ruby


class Point
    attr_reader :x
    attr_reader :y

    def initialize(x, y)
        @x = x
        @y = y
    end

    def rotate(angle)
        case angle % 360
            when 90  then @x, @y = @y, -@x
            when 180 then @x, @y = -@x, -@y
            when 270 then @x, @y = -@y, @x
        end
    end

    def move(dx, dy)
        @x += dx
        @y += dy
    end

    def move_towards(waypoint, distance)
        dx = distance * waypoint.x
        dy = distance * waypoint.y
        @x += dx
        @y += dy
    end

    def move_to_angle(angle, distance)
        dx = 0
        dy = 0
        case angle % 360
            when 0   then dx = distance
            when 90  then dy = distance
            when 180 then dx = -distance
            when 270 then dy = -distance
        end
        move(dx, dy)
    end

    def distance
        @x.abs + @y.abs
    end

    def to_s
        "(#{@x}, #{y})"
    end
end


class SimpleShip
    def initialize()
        @loc = Point.new(0, 0)
        @angle = 0
    end

    def rotate(angle)
        @angle = (@angle + angle) % 360
    end

    def command(name, arg)
        case name
            when 'F' then @loc.move_to_angle(@angle, arg)
            when 'B' then @loc.move_to_angle(@angle, -arg)

            when 'N' then @loc.move(0, -arg)
            when 'S' then @loc.move(0, arg)
            when 'W' then @loc.move(-arg, 0)
            when 'E' then @loc.move(arg, 0)

            when 'R' then rotate(arg)
            when 'L' then rotate(-arg)
        end
    end

    def distance
        @loc.distance
    end
end


class ShipWithWaypoint
    def initialize()
        @loc = Point.new(0, 0)
        @waypoint = Point.new(-1, 10)
    end

    def command(name, arg)
        case name
            when 'F' then @loc.move_towards(@waypoint, arg)
            when 'B' then @loc.move_towards(@waypoint, arg)

            when 'N' then @waypoint.move(-arg, 0)
            when 'S' then @waypoint.move(arg, 0)
            when 'W' then @waypoint.move(0, -arg)
            when 'E' then @waypoint.move(0, arg)

            when 'R' then @waypoint.rotate(arg)
            when 'L' then @waypoint.rotate(-arg)
        end
    end

    def distance
        @loc.distance
    end
end


ship1 = SimpleShip.new
ship2 = ShipWithWaypoint.new

ARGF.each_line do |line|
    cmd = line[0]
    arg = line[1...].to_i
    ship1.command(cmd, arg)
    ship2.command(cmd, arg)
end

puts "#{ship1.distance} #{ship2.distance}"
