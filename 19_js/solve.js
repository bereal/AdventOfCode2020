const fs = require('fs');

function char(ch) { return () => ch; }

function ref(id) {
    return (rules) => `${rules[id](rules)}`;
}

function seq(subs) {
    return subs.length == 1 ? subs[0] :
        (rules) => subs.map(v => v(rules)).join('');
}

function or(opts) {
    return opts.length == 1 ? opts[0] :
        (rules) => '(' + opts
            .map(v => v(rules)).join('|') + ')';
}

function repeat(sub, n) {
    return (rules) => n == 1 ? sub(rules) : `(${sub(rules)}){${n}}`;
}

function parseTerm(term) {
    const m = term.match(/"([a-z])"|(\d+)/);
    return m[1] ? char(m[1]) : ref(parseInt(m[2]));
}

function parseRule(line) {
    const [id, rule] = line.split(/:\s*/);
    const root = or(
        rule.split(/\s*\|\s*/)
            .map(opt => seq(opt.split(/\s+/).map(parseTerm)))
    );
    return [parseInt(id), root];
}

function main() {
    const content = fs.readFileSync(process.stdin.fd, { encoding: 'ascii' });
    const lines = content.split('\n');

    const rules = {};
    let sum1 = 0, sum2 = 0;
    let regex1, regex2;

    const createRE = (id) => new RegExp(`^${rules[id](rules)}$`);

    for (const line of lines) {
        if (regex1) {
            sum1 += !!line.match(regex1);
            sum2 += !!line.match(regex2);
        } else if (line) {
            const [id, rule] = parseRule(line);
            rules[id] = rule;
        } else {
            regex1 = createRE(0);

            rules[8] = repeat(ref(42), '1,');
            pattern_11 = (n) => seq([repeat(ref(42), n), repeat(ref(31), n)]);
            rules[11] = or([...Array(4).keys()].map(n => pattern_11(n + 1)));

            regex2 = createRE(0);
        }
    }

    console.log(sum1, sum2);
}

main();