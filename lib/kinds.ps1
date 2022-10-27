$KindMap = @{
    "basic"  = @{
        "name"     = "basic"
        "p_in"     = 2
        "v_in"     = 1
        "p_out"    = 1
        "v_out"    = 1
        "vban_in"  = 4
        "vban_out" = 4
    };
    "banana" = @{
        "name"     = "banana"
        "p_in"     = 3
        "v_in"     = 2
        "p_out"    = 3
        "v_out"    = 2
        "vban_in"  = 8
        "vban_out" = 8
    };
    "potato" = @{
        "name"     = "potato"
        "p_in"     = 5
        "v_in"     = 3
        "p_out"    = 5
        "v_out"    = 3
        "vban_in"  = 8
        "vban_out" = 8
    };
}

function GetKind ([string]$kind_id) {
    $KindMap[$kind_id]
}
