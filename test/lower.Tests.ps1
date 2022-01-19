Describe -Tag 'lower', -TestName 'All Tests' {
    Describe 'Macrobutton Tests' {
        Context 'mode = State' {
            It 'Should set macrobutton[0] State to 1' {
                MB_Set -ID 0 -SET 1 -MODE 1
                MB_Get -ID 0 -MODE 1 | Should -Be 1
            }

            It 'Should set macrobutton[0] State to 0' {
                MB_Set -ID 0 -SET 0 -MODE 1
                MB_Get -ID 0 -MODE 1 | Should -Be 0
            }

            It 'Should set macrobutton[1] State to 1' {
                MB_Set -ID 1 -SET 1 -MODE 1
                MB_Get -ID 1 -MODE 1 | Should -Be 1
            }

            It 'Should set macrobutton[1] State to 0' {
                MB_Set -ID 1 -SET 0 -MODE 1
                MB_Get -ID 1 -MODE 1 | Should -Be 0
            }

            It 'Should set macrobutton[2] State to 1' {
                MB_Set -ID 2 -SET 1 -MODE 1
                MB_Get -ID 2 -MODE 1 | Should -Be 1
            }

            It 'Should set macrobutton[2] State to 0' {
                MB_Set -ID 2 -SET 0 -MODE 1
                MB_Get -ID 2 -MODE 1 | Should -Be 0
            }
        }

        Context 'mode = StateOnly' {
            It 'Should set macrobutton[0] StateOnly to 1' {
                MB_Set -ID 0 -SET 1 -MODE 2
                MB_Get -ID 0 -MODE 2 | Should -Be 1
            }

            It 'Should set macrobutton[0] StateOnly to 0' {
                MB_Set -ID 0 -SET 0 -MODE 2
                MB_Get -ID 0 -MODE 2 | Should -Be 0
            }

            It 'Should set macrobutton[1] StateOnly to 1' {
                MB_Set -ID 1 -SET 1 -MODE 2
                MB_Get -ID 1 -MODE 2 | Should -Be 1
            }

            It 'Should set macrobutton[1] StateOnly to 0' {
                MB_Set -ID 1 -SET 0 -MODE 2
                MB_Get -ID 1 -MODE 2 | Should -Be 0
            }

            It 'Should set macrobutton[2] StateOnly to 1' {
                MB_Set -ID 2 -SET 1 -MODE 2
                MB_Get -ID 2 -MODE 2 | Should -Be 1
            }

            It 'Should set macrobutton[2] StateOnly to 0' {
                MB_Set -ID 2 -SET 0 -MODE 2
                MB_Get -ID 2 -MODE 2 | Should -Be 0
            }
        }

        Context 'mode = Trigger' {
            It 'Should set macrobutton[0] Trigger to 1' {
                MB_Set -ID 0 -SET 1 -MODE 3
                MB_Get -ID 0 -MODE 3 | Should -Be 1
            }

            It 'Should set macrobutton[0] Trigger to 0' {
                MB_Set -ID 0 -SET 0 -MODE 3
                MB_Get -ID 0 -MODE 3 | Should -Be 0
            }

            It 'Should set macrobutton[1] Trigger to 1' {
                MB_Set -ID 1 -SET 1 -MODE 3
                MB_Get -ID 1 -MODE 3 | Should -Be 1
            }

            It 'Should set macrobutton[1] Trigger to 0' {
                MB_Set -ID 1 -SET 0 -MODE 3
                MB_Get -ID 1 -MODE 3 | Should -Be 0
            }

            It 'Should set macrobutton[2] Trigger to 1' {
                MB_Set -ID 2 -SET 1 -MODE 3
                MB_Get -ID 2 -MODE 3 | Should -Be 1
            }

            It 'Should set macrobutton[2] Trigger to 0' {
                MB_Set -ID 2 -SET 0 -MODE 3
                MB_Get -ID 2 -MODE 3 | Should -Be 0
            }
        }
    }

    Describe 'Set and Get Param Float Tests' {
        Context 'Strip[i].Mute' {
            It 'Should set Strip[0].Mute to 1' {
                Param_Set -PARAM "Strip[0].Mute" -VALUE 1
                Param_Get -PARAM "Strip[0].Mute" | Should -Be 1
            }

            It 'Should set Strip[0].Mute to 0' {
                Param_Set -PARAM "Strip[0].Mute" -VALUE 0
                Param_Get -PARAM "Strip[0].Mute" | Should -Be 0
            }

            It 'Should set Strip[1].Mute to 1' {
                Param_Set -PARAM "Strip[1].Mute" -VALUE 1
                Param_Get -PARAM "Strip[1].Mute" | Should -Be 1
            }

            It 'Should set Strip[1].Mute to 0' {
                Param_Set -PARAM "Strip[1].Mute" -VALUE 0
                Param_Get -PARAM "Strip[1].Mute" | Should -Be 0
            }

            It 'Should set Strip[2].Mute to 1' {
                Param_Set -PARAM "Strip[2].Mute" -VALUE 1
                Param_Get -PARAM "Strip[2].Mute" | Should -Be 1
            }

            It 'Should set Strip[2].Mute to 0' {
                Param_Set -PARAM "Strip[2].Mute" -VALUE 0
                Param_Get -PARAM "Strip[2].Mute" | Should -Be 0
            }
        }

        Context 'Strip[i].Solo' {
            It 'Should set Strip[0].Solo to 1' {
                Param_Set -PARAM "Strip[0].Solo" -VALUE 1
                Param_Get -PARAM "Strip[0].Solo" | Should -Be 1
            }

            It 'Should set Strip[0].Solo to 0' {
                Param_Set -PARAM "Strip[0].Solo" -VALUE 0
                Param_Get -PARAM "Strip[0].Solo" | Should -Be 0
            }

            It 'Should set Strip[1].Solo to 1' {
                Param_Set -PARAM "Strip[1].Solo" -VALUE 1
                Param_Get -PARAM "Strip[1].Solo" | Should -Be 1
            }

            It 'Should set Strip[1].Solo to 0' {
                Param_Set -PARAM "Strip[1].Solo" -VALUE 0
                Param_Get -PARAM "Strip[1].Solo" | Should -Be 0
            }

            It 'Should set Strip[2].Solo to 1' {
                Param_Set -PARAM "Strip[2].Solo" -VALUE 1
                Param_Get -PARAM "Strip[2].Solo" | Should -Be 1
            }

            It 'Should set Strip[2].Solo to 0' {
                Param_Set -PARAM "Strip[2].Solo" -VALUE 0
                Param_Get -PARAM "Strip[2].Solo" | Should -Be 0
            }
        }

        Context 'Strip[i].Mono' {
            It 'Should set Strip[0].Mono to 1' {
                Param_Set -PARAM "Strip[0].Mono" -VALUE 1
                Param_Get -PARAM "Strip[0].Mono" | Should -Be 1
            }

            It 'Should set Strip[0].Mono to 0' {
                Param_Set -PARAM "Strip[0].Mono" -VALUE 0
                Param_Get -PARAM "Strip[0].Mono" | Should -Be 0
            }

            It 'Should set Strip[1].Mono to 1' {
                Param_Set -PARAM "Strip[1].Mono" -VALUE 1
                Param_Get -PARAM "Strip[1].Mono" | Should -Be 1
            }

            It 'Should set Strip[1].Mono to 0' {
                Param_Set -PARAM "Strip[1].Mono" -VALUE 0
                Param_Get -PARAM "Strip[1].Mono" | Should -Be 0
            }

            It 'Should set Strip[2].Mono to 1' {
                Param_Set -PARAM "Strip[2].Mono" -VALUE 1
                Param_Get -PARAM "Strip[2].Mono" | Should -Be 1
            }

            It 'Should set Strip[2].Mono to 0' {
                Param_Set -PARAM "Strip[2].Mono" -VALUE 0
                Param_Get -PARAM "Strip[2].Mono" | Should -Be 0
            }
        }

        Context 'Strip[i].A1' {
            It 'Should set Strip[0].A1 to 1' {
                Param_Set -PARAM "Strip[0].A1" -VALUE 1
                Param_Get -PARAM "Strip[0].A1" | Should -Be 1
            }

            It 'Should set Strip[0].A1 to 0' {
                Param_Set -PARAM "Strip[0].A1" -VALUE 0
                Param_Get -PARAM "Strip[0].A1" | Should -Be 0
            }

            It 'Should set Strip[1].A1 to 1' {
                Param_Set -PARAM "Strip[1].A1" -VALUE 1
                Param_Get -PARAM "Strip[1].A1" | Should -Be 1
            }

            It 'Should set Strip[1].A1 to 0' {
                Param_Set -PARAM "Strip[1].A1" -VALUE 0
                Param_Get -PARAM "Strip[1].A1" | Should -Be 0
            }

            It 'Should set Strip[2].A1 to 1' {
                Param_Set -PARAM "Strip[2].A1" -VALUE 1
                Param_Get -PARAM "Strip[2].A1" | Should -Be 1
            }

            It 'Should set Strip[2].A1 to 0' {
                Param_Set -PARAM "Strip[2].A1" -VALUE 0
                Param_Get -PARAM "Strip[2].A1" | Should -Be 0
            }
        }

        Context 'Strip[i].A2' {
            It 'Should set Strip[0].A2 to 1' {
                Param_Set -PARAM "Strip[0].A2" -VALUE 1
                Param_Get -PARAM "Strip[0].A2" | Should -Be 1
            }

            It 'Should set Strip[0].A2 to 0' {
                Param_Set -PARAM "Strip[0].A2" -VALUE 0
                Param_Get -PARAM "Strip[0].A2" | Should -Be 0
            }

            It 'Should set Strip[1].A2 to 1' {
                Param_Set -PARAM "Strip[1].A2" -VALUE 1
                Param_Get -PARAM "Strip[1].A2" | Should -Be 1
            }

            It 'Should set Strip[1].A2 to 0' {
                Param_Set -PARAM "Strip[1].A2" -VALUE 0
                Param_Get -PARAM "Strip[1].A2" | Should -Be 0
            }

            It 'Should set Strip[2].A2 to 1' {
                Param_Set -PARAM "Strip[2].A2" -VALUE 1
                Param_Get -PARAM "Strip[2].A2" | Should -Be 1
            }

            It 'Should set Strip[2].A2 to 0' {
                Param_Set -PARAM "Strip[2].A2" -VALUE 0
                Param_Get -PARAM "Strip[2].A2" | Should -Be 0
            }
        }

        Context 'Strip[i].A3' {
            It 'Should set Strip[0].A3 to 1' {
                Param_Set -PARAM "Strip[0].A3" -VALUE 1
                Param_Get -PARAM "Strip[0].A3" | Should -Be 1
            }

            It 'Should set Strip[0].A3 to 0' {
                Param_Set -PARAM "Strip[0].A3" -VALUE 0
                Param_Get -PARAM "Strip[0].A3" | Should -Be 0
            }

            It 'Should set Strip[1].A3 to 1' {
                Param_Set -PARAM "Strip[1].A3" -VALUE 1
                Param_Get -PARAM "Strip[1].A3" | Should -Be 1
            }

            It 'Should set Strip[1].A3 to 0' {
                Param_Set -PARAM "Strip[1].A3" -VALUE 0
                Param_Get -PARAM "Strip[1].A3" | Should -Be 0
            }

            It 'Should set Strip[2].A3 to 1' {
                Param_Set -PARAM "Strip[2].A3" -VALUE 1
                Param_Get -PARAM "Strip[2].A3" | Should -Be 1
            }

            It 'Should set Strip[2].A3 to 0' {
                Param_Set -PARAM "Strip[2].A3" -VALUE 0
                Param_Get -PARAM "Strip[2].A3" | Should -Be 0
            }
        }

        Context 'Strip[i].B1' {
            It 'Should set Strip[0].B1 to 1' {
                Param_Set -PARAM "Strip[0].B1" -VALUE 1
                Param_Get -PARAM "Strip[0].B1" | Should -Be 1
            }

            It 'Should set Strip[0].B1 to 0' {
                Param_Set -PARAM "Strip[0].B1" -VALUE 0
                Param_Get -PARAM "Strip[0].B1" | Should -Be 0
            }

            It 'Should set Strip[1].B1 to 1' {
                Param_Set -PARAM "Strip[1].B1" -VALUE 1
                Param_Get -PARAM "Strip[1].B1" | Should -Be 1
            }

            It 'Should set Strip[1].B1 to 0' {
                Param_Set -PARAM "Strip[1].B1" -VALUE 0
                Param_Get -PARAM "Strip[1].B1" | Should -Be 0
            }

            It 'Should set Strip[2].B1 to 1' {
                Param_Set -PARAM "Strip[2].B1" -VALUE 1
                Param_Get -PARAM "Strip[2].B1" | Should -Be 1
            }

            It 'Should set Strip[2].B1 to 0' {
                Param_Set -PARAM "Strip[2].B1" -VALUE 0
                Param_Get -PARAM "Strip[2].B1" | Should -Be 0
            }
        }

        Context 'Strip[i].B2' {
            It 'Should set Strip[0].B2 to 1' {
                Param_Set -PARAM "Strip[0].B2" -VALUE 1
                Param_Get -PARAM "Strip[0].B2" | Should -Be 1
            }

            It 'Should set Strip[0].B2 to 0' {
                Param_Set -PARAM "Strip[0].B2" -VALUE 0
                Param_Get -PARAM "Strip[0].B2" | Should -Be 0
            }

            It 'Should set Strip[1].B2 to 1' {
                Param_Set -PARAM "Strip[1].B2" -VALUE 1
                Param_Get -PARAM "Strip[1].B2" | Should -Be 1
            }

            It 'Should set Strip[1].B2 to 0' {
                Param_Set -PARAM "Strip[1].B2" -VALUE 0
                Param_Get -PARAM "Strip[1].B2" | Should -Be 0
            }

            It 'Should set Strip[2].B2 to 1' {
                Param_Set -PARAM "Strip[2].B2" -VALUE 1
                Param_Get -PARAM "Strip[2].B2" | Should -Be 1
            }

            It 'Should set Strip[2].B2 to 0' {
                Param_Set -PARAM "Strip[2].B2" -VALUE 0
                Param_Get -PARAM "Strip[2].B2" | Should -Be 0
            }
        }
    }

    Describe 'Set and Get Param String Tests' {
        Context 'Strip[i].Label test0' {
            It 'Should set Strip[0].Label to test0' {
                Param_Set -PARAM "Strip[0].Label" -VALUE 'test0'
                Param_Get -PARAM "Strip[0].Label"  -IS_STRING $true | Should -Be 'test0'
            }

            It 'Should set Strip[1].Label to test0' {
                Param_Set -PARAM "Strip[1].Label" -VALUE 'test0'
                Param_Get -PARAM "Strip[1].Label" -IS_STRING $true | Should -Be 'test0'
            }

            It 'Should set Strip[2].Label to test0' {
                Param_Set -PARAM "Strip[2].Label" -VALUE 'test0'
                Param_Get -PARAM "Strip[2].Label" -IS_STRING $true | Should -Be 'test0'
            }
        }

        Context 'Strip[i].Label test1' {
            It 'Should set Strip[0].Label to test1' {
                Param_Set -PARAM "Strip[0].Label" -VALUE 'test1'
                Param_Get -PARAM "Strip[0].Label" -IS_STRING $true | Should -Be 'test1'
            }

            It 'Should set Strip[1].Label to test1' {
                Param_Set -PARAM "Strip[1].Label" -VALUE 'test1'
                Param_Get -PARAM "Strip[1].Label" -IS_STRING $true | Should -Be 'test1'
            }

            It 'Should set Strip[2].Label to test1' {
                Param_Set -PARAM "Strip[2].Label" -VALUE 'test1'
                Param_Get -PARAM "Strip[2].Label" -IS_STRING $true | Should -Be 'test1'
            }
        }

        Context 'Strip[i].Label test2' {
            It 'Should set Strip[0].Label to test2' {
                Param_Set -PARAM "Strip[0].Label" -VALUE 'test2'
                Param_Get -PARAM "Strip[0].Label" -IS_STRING $true | Should -Be 'test2'
            }

            It 'Should set Strip[1].Label to test2' {
                Param_Set -PARAM "Strip[1].Label" -VALUE 'test2'
                Param_Get -PARAM "Strip[1].Label" -IS_STRING $true | Should -Be 'test2'
            }

            It 'Should set Strip[2].Label to test2' {
                Param_Set -PARAM "Strip[2].Label" -VALUE 'test2'
                Param_Get -PARAM "Strip[2].Label" -IS_STRING $true | Should -Be 'test2'
            }
        }
    }
}
