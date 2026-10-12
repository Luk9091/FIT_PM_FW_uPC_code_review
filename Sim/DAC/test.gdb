define init
    target remote :1234
    layout src
    break main
    break dac_send_value
    continue
end

define show
    printf "R16: %u, R17: %u\n", $r16, $r17
    printf "R16,R17: %lu\n", ((unsigned int)($r16 << 8) | $r17)
end


define test
    commands 2
        silent
    end

    set $i = (unsigned long)0
    set logging enabled on
    printf "index,R16:R17,R16,R17\n"
    while $i < 65536
        continue
        printf "%ld,%llu,%u,%u\n", $i, ((unsigned int)($r17 << 8) | $r16), $r16, $r17
        set $i = $i + 1
    end
    set logging enabled off
end

