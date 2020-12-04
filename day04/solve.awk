BEGIN {
    count_1 = 0
    count_2 = 0;
    split("byr iyr eyr hgt hcl ecl pid", required)
}

function validate_1() {
    for (f in required) {
        if (!(required[f] in cur)) {
            return 0;
        };
    }
    return 1;
}

function validate_2() {
    if (cur["byr"] > 2020 || cur["byr"] < 1920 \
        || cur["eyr"] > 2030 || cur["eyr"] < 2020 \
        || cur["iyr"] > 2020 || cur["iyr"] < 2010 \
        || cur["hcl"] !~ /#[0-9a-f]{6}$/ \
        || cur["ecl"] !~ /(amb|blu|brn|gry|grn|hzl|oth)$/ \
        || cur["pid"] !~ /[0-9]{9}$/) return 0;

    h = cur["hgt"];
    if (h ~ /[1-9][0-9]in/) return h >= 59 && h <= 76;
    if (h ~ /1[0-9]{2}cm/)  return h >= 150 && h <= 193;
}

function validate() {
    count_1 += validate_1();
    count_2 += validate_2();
    split("", cur);
}

/^$/ { validate(); }

/.+/ {
    for (i=1; i<=NF; i++) {
        split($(i), p, ":");
        cur[p[1]] = p[2];
    }
}

END {
    validate();
    print count_1 " " count_2
}