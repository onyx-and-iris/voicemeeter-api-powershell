BeforeAll { 
    . ..\lib\base.ps1
}

Describe -Tag 'lower', -TestName 'All Lower Tests' {
    Describe 'Macrobutton Tests' -ForEach @(
        @{ Value = 1; Expected = 1 }
        @{ Value = 0; Expected = 0 }
    ){
        Context 'buttons 0, 69' -ForEach @(
            @{ Index = 0 }, @{ Index = 69 }
        ){
            Context 'state, stateonly and trigger' -ForEach @(
                @{ Mode = 1 }, @{ Mode = 2 }, @{ Mode = 3 }
            ){
                It "Should set and get macrobutton[$index] State" {
                    MB_Set -ID $index -SET $value -MODE $mode
                    MB_Get -ID $index -MODE $mode | Should -Be $expected 
                }
            }
        }
    }

    Describe 'Set and Get Param Float Tests' -ForEach @(
        @{ Value = 1; Expected = 1 }
        @{ Value = 0; Expected = 0 }
    ){
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = 0 }, @{ Index = 4 }
        ){
            Context 'mute, mono, A1, B2' -ForEach @(
                @{ param = "mute" }, @{ param = "A1" }
            ){
                It "Should set Strip[0].$param to 1" {
                    Param_Set -PARAM "Strip[$index].$param" -VALUE $value
                    Param_Get -PARAM "Strip[$index].$param" | Should -Be $value
                }
            }
        }
    }

    Describe 'Set and Get Param String Tests' -ForEach @(
        @{ Value = 'test0'; Expected = 'test0' }
        @{ Value = 'test1'; Expected = 'test1' }
    ){
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = 0 }, @{ Index = 4 }
        ){
            It "Should set Strip[$index].Label to $value" {
                Param_Set -PARAM "Strip[$index].Label" -VALUE $value
                Param_Get -PARAM "Strip[$index].Label" -IS_STRING $true | Should -Be $value
            }
        }
    }
}
