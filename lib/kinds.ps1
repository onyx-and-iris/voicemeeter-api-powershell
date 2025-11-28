$KindMap = @{
    'basic'  = @{
        'name'      = 'basic'
        'p_in'      = 2
        'v_in'      = 1
        'p_out'     = 1
        'v_out'     = 1
        'asio_in'   = 4
        'asio_out'  = 8
        'composite' = 0
        'insert'    = 0
        'vban_in'   = 4
        'vban_out'  = 4
        'eq_ch'     = @{ 'strip' = 0; 'bus' = 0 }
        'cells'     = 0
    };
    'banana' = @{
        'name'      = 'banana'
        'p_in'      = 3
        'v_in'      = 2
        'p_out'     = 3
        'v_out'     = 2
        'asio_in'   = 6
        'asio_out'  = 8
        'composite' = 8
        'insert'    = 22
        'vban_in'   = 8
        'vban_out'  = 8
        'eq_ch'     = @{ 'strip' = 0; 'bus' = 8 }
        'cells'     = 6
    };
    'potato' = @{
        'name'      = 'potato'
        'p_in'      = 5
        'v_in'      = 3
        'p_out'     = 5
        'v_out'     = 3
        'asio_in'   = 10
        'asio_out'  = 8
        'composite' = 8
        'insert'    = 34
        'vban_in'   = 8
        'vban_out'  = 8
        'eq_ch'     = @{ 'strip' = 2; 'bus' = 8 }
        'cells'     = 6
    };
}

function GetKind ([string]$kindId) {
    $KindMap[$kindId]
}