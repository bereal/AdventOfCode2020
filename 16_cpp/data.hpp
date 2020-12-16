#include <algorithm>
#include <map>
#include <string>
#include <vector>

typedef unsigned int field_value;

typedef std::vector<field_value> series;

struct range {
    field_value min;
    field_value max;

    bool contains(field_value v) { return min <= v && v <= max; }
};

struct constraint {
    std::string field_name;
    std::vector<range> ranges;

    bool matches(field_value v) const {
        return std::any_of(ranges.begin(), ranges.end(),
                           [v](auto r) { return r.contains(v); });
    }
};

struct input {
    std::map<std::string, constraint> constraints;
    series my_ticket;
    std::vector<series> nearby_tickets;
};

input read_input();