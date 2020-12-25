1;

function ret = discrete_log (v, base, n)
    ret = 0;
    pr = 1;
    while (pr != v)
        ret++;
        pr = mod(pr*base, n);
    endwhile
endfunction

function ret = create_secret (pub, pri, n)
    if (pri == 0)
        ret = 1;
        return;
    endif

    sub = create_secret(pub, idivide(pri, 2), n);
    ret = mod(sub * sub, n);
    if (mod(pri, 2) == 1)
        ret = mod(ret * pub, n);
    endif
endfunction

N = 20201227;

pub_1 = uint64(scanf("%d", "C"));
pub_2 = uint64(scanf("%d", "C"));

pri_1 = discrete_log(pub_1, 7, N);
secret = create_secret(pub_2, pri_1, N);

printf("%d\n", secret);
