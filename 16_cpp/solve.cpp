#include "data.hpp"
#include <algorithm>
#include <functional>
#include <iostream>
#include <set>
#include <vector>

unsigned int find_error(const std::map<std::string, constraint> &cs,
                        const series &ticket) {
    for (auto v : ticket) {
        if (!std::any_of(cs.begin(), cs.end(),
                         [v](auto &c) { return c.second.matches(v); })) {
            return v;
        }
    }
    return 0;
}

unsigned int solve1(input &inp) {
    unsigned int sum = 0;
    for (auto &ticket : inp.nearby_tickets) {
        sum += find_error(inp.constraints, ticket);
    }
    return sum;
}

std::vector<series> get_valid_tickets(const input &inp) {
    std::vector<series> result;
    std::copy_if(inp.nearby_tickets.begin(), inp.nearby_tickets.end(),
                 std::back_inserter(result), [&inp](const auto &ticket) {
                     return !find_error(inp.constraints, ticket);
                 });
    return result;
}

unsigned long solve2(const input &inp) {
    auto good_tickets = get_valid_tickets(inp);

    // transposed tickets, each row contains the same field's values
    std::vector<series> fields(inp.my_ticket.size());

    // candindate field names for each field
    std::vector<std::set<std::string>> candidates(inp.my_ticket.size());

    // we've found a unique match for the field
    // remove the field from other field's candidates
    // if we resolve anything on the way, procede recursively
    std::function<void(int)> found = [&](int i) {
        auto name = *candidates[i].begin();
        for (int j = 0; j < fields.size(); j++) {
            if (i != j && candidates[j].size() != 1) {
                candidates[j].erase(name);
                if (candidates[j].size() == 1)
                    found(j);
            }
        }
    };

    for (int i = 0; i < inp.my_ticket.size(); i++) {
        // transposing the tickets into fields
        std::transform(good_tickets.begin(), good_tickets.end(),
                       std::back_inserter(fields[i]),
                       [&i](auto &t) { return t[i]; });

        // pre-populating the candidate field names for each field
        std::transform(inp.constraints.begin(), inp.constraints.end(),
                       std::inserter(candidates[i], candidates[i].begin()),
                       [](auto &c) { return c.first; });
    }

    bool more = true;
    while (more) {
        more = false;
        for (int i = 0; i < fields.size(); i++) {
            auto &cur_cands = candidates[i];
            if (cur_cands.size() > 1) {
                std::vector<std::string> to_delete;
                more = true;
                for (auto cand : cur_cands) {
                    if (!std::all_of(
                            fields[i].begin(), fields[i].end(), [&](auto v) {
                                return inp.constraints.at(cand).matches(v);
                            })) {
                        to_delete.push_back(cand);
                    }
                }

                for (auto del : to_delete) {
                    cur_cands.erase(del);
                }

                if (cur_cands.size() == 1) {
                    found(i);
                }
            }
        }
    }

    unsigned long prod = 1;
    for (int i = 0; i < fields.size(); i++) {
        auto name = *candidates[i].begin();
        if (name.find("departure") == 0) {
            // std::cout << name << " = " << inp.my_ticket[i] << '\n';
            prod *= inp.my_ticket[i];
        }
    }

    return prod;
}

int main() {
    auto inp = read_input();
    std::cout << solve1(inp) << ' ' << solve2(inp) << '\n';
    return 0;
}