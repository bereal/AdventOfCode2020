#include "data.hpp"
#include <iostream>
#include <regex>
#include <string>

std::map<std::string, constraint> read_constraints() {
    std::regex re("([^:]+): (\\d+)-(\\d+) or (\\d+)-(\\d+)$");
    std::map<std::string, constraint> result;
    std::string line;
    for (;;) {
        std::getline(std::cin, line);
        if (!line.length()) {
            return result;
        }
        std::cmatch m;
        std::regex_match(line.c_str(), m, re);

        auto val = [&m](int i) { return (field_value)std::stoi(m[i].str()); };

        std::vector<range> ranges = {
            {.min = val(2), .max = val(3)},
            {.min = val(4), .max = val(5)},
        };

        auto name = m[1].str();
        result[name] = {.field_name = name, .ranges = ranges};
    }
    return result;
}

bool read_ticket(series &out) {
    std::string line;
    std::string part;
    if (!std::getline(std::cin, line)) {
        return false;
    };
    std::istringstream s(line);
    while (std::getline(s, part, ',')) {
        out.push_back(std::stoi(part));
    }
    return true;
}

void skip_line() {
    std::string line;
    std::getline(std::cin, line);
}

input read_input() {
    auto constraints = read_constraints();
    skip_line();
    series my_ticket;
    read_ticket(my_ticket);

    skip_line();
    skip_line();

    std::vector<series> nearby;
    for (;;) {
        nearby.push_back({});
        if (!read_ticket(nearby.back())) {
            nearby.pop_back();
            break;
        }
    }
    return input{.constraints = constraints,
                 .my_ticket = my_ticket,
                 .nearby_tickets = nearby};
}
