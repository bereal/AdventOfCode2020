#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

// A shortcut here:
// '(' is also an OP, because it goes to the operator stack
// ')' and end of expression are the same token type with different args
enum token_type { NUMBER = 0, OP = 1, CLOSE = 2 };

typedef unsigned long long num_t;

struct token {
    enum token_type type;
    union {
        num_t number;
        char op;
        bool end_of_stream;
    };
};

struct lexer {
    const char *input;
    size_t offset;
};

void init_lexer(struct lexer *lex, const char *input) {
    lex->input = input;
    lex->offset = 0;
}

void reset_lexer(struct lexer *lex) { lex->offset = 0; }

struct token next_token(struct lexer *lex) {
    char cur;
    num_t num;
    int delta_offset;

    while ((cur = lex->input[lex->offset]) == ' ') {
        lex->offset++;
    }

    if (!cur || cur == '\n') {
        return (struct token){.type = CLOSE, .end_of_stream = true};
    }

    switch (cur) {
    case '+':
    case '*':
    case '(':
        lex->offset++;
        return (struct token){.type = OP, .op = cur};
    case ')':
        lex->offset++;
        return (struct token){.type = CLOSE, .end_of_stream = false};
    default:
        sscanf(lex->input + lex->offset, "%llu%n", &num, &delta_offset);
        lex->offset += delta_offset;
        return (struct token){.type = NUMBER, .number = num};
    }
}

typedef int (*precedence_func)(char);

struct shunting_yard {
    precedence_func precedence;
    num_t num_stack[50];
    char op_stack[50];
    int op_top;
    int num_top;
};

void init_shunting_yard(struct shunting_yard *sy, precedence_func precedence) {
    sy->precedence = precedence;
    sy->op_top = 0;
    sy->num_top = 0;
}

bool reduce(struct shunting_yard *);

void push_num(struct shunting_yard *sy, num_t num) {
    sy->num_stack[sy->num_top++] = num;
}

void push_op(struct shunting_yard *sy, char op) {
    if (op != '(') {
        int preced = sy->precedence(op);

        while (sy->op_top) {
            char top = sy->op_stack[sy->op_top - 1];
            if (top == '(' || sy->precedence(top) > preced || reduce(sy)) {
                break;
            }
        }
    }

    sy->op_stack[sy->op_top++] = op;
}

num_t pop_num(struct shunting_yard *sy) { return sy->num_stack[--sy->num_top]; }

char pop_op(struct shunting_yard *sy) {
    return sy->op_top > 0 ? sy->op_stack[--sy->op_top] : '(';
}

bool reduce(struct shunting_yard *sy) {
    char op = pop_op(sy);
    switch (op) {
    case '(':
        return true;
    case '+':
        push_num(sy, pop_num(sy) + pop_num(sy));
        return false;
    case '*':
        push_num(sy, pop_num(sy) * pop_num(sy));
        return false;
    }
}

num_t eval(struct lexer *lex, precedence_func precedence) {
    struct shunting_yard sy;
    init_shunting_yard(&sy, precedence);

    for (;;) {
        struct token t = next_token(lex);
        switch (t.type) {
        case NUMBER:
            push_num(&sy, t.number);
            break;
        case OP:
            push_op(&sy, t.op);
            break;
        case CLOSE:
            while (!reduce(&sy))
                ;
            if (t.end_of_stream) {
                return pop_num(&sy);
            }
        }
    }
}

int precedence_1(char c) {
    switch (c) {
    case '+':
        return 1;
    case '*':
        return 1;
    }
}

int precedence_2(char c) {
    switch (c) {
    case '+':
        return 1;
    case '*':
        return 2;
    }
}

int main() {
    struct lexer lex;
    char line[256];
    num_t sum1 = 0;
    num_t sum2 = 0;
    while (fgets(line, 256, stdin)) {
        init_lexer(&lex, line);
        sum1 += eval(&lex, precedence_1);

        reset_lexer(&lex);
        sum2 += eval(&lex, precedence_2);
    }
    printf("%llu %llu\n", sum1, sum2);
}