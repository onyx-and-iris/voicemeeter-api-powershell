Describe -Tag 'higher', -TestName 'All Alias Tests' {
    Describe 'Macrobutton Tests' {
        Context 'mode = State' {
            It 'Should set macrobutton[0] State to 1' {
                $vmr.button[0].state = $true
                $vmr.button[0].state | Should -Be $true
            }

            It 'Should set macrobutton[0] State to 0' {
                $vmr.button[0].state = $false
                $vmr.button[0].state | Should -Be $false
            }

            It 'Should set macrobutton[1] State to 1' {
                $vmr.button[1].state = $true
                $vmr.button[1].state | Should -Be $true
            }

            It 'Should set macrobutton[1] State to 0' {
                $vmr.button[1].state = $false
                $vmr.button[1].state | Should -Be $false
            }

            It 'Should set macrobutton[2] State to 1' {
                $vmr.button[2].state = $true
                $vmr.button[2].state | Should -Be $true
            }

            It 'Should set macrobutton[2] State to 0' {
                $vmr.button[2].state = $false
                $vmr.button[2].state | Should -Be $false
            }
        }

        Context 'mode = StateOnly' {
            It 'Should set macrobutton[0] StateOnly to 1' {
                $vmr.button[0].stateonly = $true
                $vmr.button[0].stateonly | Should -Be $true
            }

            It 'Should set macrobutton[0] StateOnly to 0' {
                $vmr.button[0].stateonly = $false
                $vmr.button[0].stateonly | Should -Be $false
            }

            It 'Should set macrobutton[1] StateOnly to 1' {
                $vmr.button[1].stateonly = $true
                $vmr.button[1].stateonly | Should -Be $true
            }

            It 'Should set macrobutton[1] StateOnly to 0' {
                $vmr.button[1].stateonly = $false
                $vmr.button[1].stateonly | Should -Be $false
            }

            It 'Should set macrobutton[2] StateOnly to 1' {
                $vmr.button[2].stateonly = $true
                $vmr.button[2].stateonly | Should -Be $true
            }

            It 'Should set macrobutton[2] StateOnly to 0' {
                $vmr.button[2].stateonly = $false
                $vmr.button[2].stateonly | Should -Be $false
            }
        }

        Context 'mode = Trigger' {
            It 'Should set macrobutton[0] Trigger to 1' {
                $vmr.button[0].trigger = $true
                $vmr.button[0].trigger | Should -Be $true
            }

            It 'Should set macrobutton[0] Trigger to 0' {
                $vmr.button[0].trigger = $false
                $vmr.button[0].trigger | Should -Be $false
            }

            It 'Should set macrobutton[1] Trigger to 1' {
                $vmr.button[1].trigger = $true
                $vmr.button[1].trigger | Should -Be $true
            }

            It 'Should set macrobutton[1] Trigger to 0' {
                $vmr.button[1].trigger = $false
                $vmr.button[1].trigger | Should -Be $false
            }

            It 'Should set macrobutton[2] Trigger to 1' {
                $vmr.button[2].trigger = $true
                $vmr.button[2].trigger | Should -Be $true
            }

            It 'Should set macrobutton[2] Trigger to 0' {
                $vmr.button[2].trigger = $false
                $vmr.button[2].trigger | Should -Be $false
            }
        }
    }

    Describe 'Set and Get Param Float Tests' {
        Context 'Strip[i].Mute' {
            It 'Should set Strip[0].Mute to 1' {
                $vmr.strip[0].mute = $true
                $vmr.strip[0].mute | Should -Be $true
            }

            It 'Should set Strip[0].Mute to 0' {
                $vmr.strip[0].mute = $false
                $vmr.strip[0].mute | Should -Be $false
            }

            It 'Should set Strip[1].Mute to 1' {
                $vmr.strip[1].mute = $true
                $vmr.strip[1].mute | Should -Be $true
            }

            It 'Should set Strip[1].Mute to 0' {
                $vmr.strip[1].mute = $false
                $vmr.strip[1].mute | Should -Be $false
            }

            It 'Should set Strip[2].Mute to 1' {
                $vmr.strip[2].mute = $true
                $vmr.strip[2].mute | Should -Be $true
            }

            It 'Should set Strip[2].Mute to 0' {
                $vmr.strip[2].mute = $false
                $vmr.strip[2].mute | Should -Be $false
            }
        }

        Context 'Strip[i].Solo' {
            It 'Should set Strip[0].Solo to 1' {
                $vmr.strip[0].solo = $true
                $vmr.strip[0].solo | Should -Be $true
            }

            It 'Should set Strip[0].Solo to 0' {
                $vmr.strip[0].solo = $false
                $vmr.strip[0].solo | Should -Be $false
            }

            It 'Should set Strip[1].Solo to 1' {
                $vmr.strip[1].solo = $true
                $vmr.strip[1].solo | Should -Be $true
            }

            It 'Should set Strip[1].Solo to 0' {
                $vmr.strip[1].solo = $false
                $vmr.strip[1].solo | Should -Be $false
            }

            It 'Should set Strip[2].Solo to 1' {
                $vmr.strip[2].solo = $true
                $vmr.strip[2].solo | Should -Be $true
            }

            It 'Should set Strip[2].Solo to 0' {
                $vmr.strip[2].solo = $false
                $vmr.strip[2].solo | Should -Be $false
            }
        }

        Context 'Strip[i].Mono' {
            It 'Should set Strip[0].Mono to 1' {
                $vmr.strip[0].mono = $true
                $vmr.strip[0].mono | Should -Be $true
            }

            It 'Should set Strip[0].Mono to 0' {
                $vmr.strip[0].mono = $false
                $vmr.strip[0].mono | Should -Be $false
            }

            It 'Should set Strip[1].Mono to 1' {
                $vmr.strip[1].mono = $true
                $vmr.strip[1].mono | Should -Be $true
            }

            It 'Should set Strip[1].Mono to 0' {
                $vmr.strip[1].mono = $false
                $vmr.strip[1].mono | Should -Be $false
            }

            It 'Should set Strip[2].Mono to 1' {
                $vmr.strip[2].mono = $true
                $vmr.strip[2].mono | Should -Be $true
            }

            It 'Should set Strip[2].Mono to 0' {
                $vmr.strip[2].mono = $false
                $vmr.strip[2].mono | Should -Be $false
            }
        }

        Context 'Strip[i].A1' {
            It 'Should set Strip[0].A1 to 1' {
                $vmr.strip[0].A1 = $true
                $vmr.strip[0].A1 | Should -Be $true
            }

            It 'Should set Strip[0].A1 to 0' {
                $vmr.strip[0].A1 = $false
                $vmr.strip[0].A1 | Should -Be $false
            }

            It 'Should set Strip[1].A1 to 1' {
                $vmr.strip[1].A1 = $true
                $vmr.strip[1].A1 | Should -Be $true
            }

            It 'Should set Strip[1].A1 to 0' {
                $vmr.strip[1].A1 = $false
                $vmr.strip[1].A1 | Should -Be $false
            }

            It 'Should set Strip[2].A1 to 1' {
                $vmr.strip[2].A1 = $true
                $vmr.strip[2].A1 | Should -Be $true
            }

            It 'Should set Strip[2].A1 to 0' {
                $vmr.strip[2].A1 = $false
                $vmr.strip[2].A1 | Should -Be $false
            }
        }

        Context 'Strip[i].A2' {
            It 'Should set Strip[0].A2 to 1' {
                $vmr.strip[0].A2 = $true
                $vmr.strip[0].A2 | Should -Be $true
            }

            It 'Should set Strip[0].v to 0' {
                $vmr.strip[0].A2 = $false
                $vmr.strip[0].A2 | Should -Be $false
            }

            It 'Should set Strip[1].A2 to 1' {
                $vmr.strip[1].A2 = $true
                $vmr.strip[1].A2 | Should -Be $true
            }

            It 'Should set Strip[1].A2 to 0' {
                $vmr.strip[1].A2 = $false
                $vmr.strip[1].A2 | Should -Be $false
            }

            It 'Should set Strip[2].A2 to 1' {
                $vmr.strip[2].A2 = $true
                $vmr.strip[2].A2 | Should -Be $true
            }

            It 'Should set Strip[2].A2 to 0' {
                $vmr.strip[2].A2 = $false
                $vmr.strip[2].A2 | Should -Be $false
            }
        }

        Context 'Strip[i].A3' {
            It 'Should set Strip[0].A3 to 1' {
                $vmr.strip[0].A3 = $true
                $vmr.strip[0].A3 | Should -Be $true
            }

            It 'Should set Strip[0].A3 to 0' {
                $vmr.strip[0].A3 = $false
                $vmr.strip[0].A3 | Should -Be $false
            }

            It 'Should set Strip[1].A3 to 1' {
                $vmr.strip[1].A3 = $true
                $vmr.strip[1].A3 | Should -Be $true
            }

            It 'Should set Strip[1].A3 to 0' {
                $vmr.strip[1].A3 = $false
                $vmr.strip[1].A3 | Should -Be $false
            }

            It 'Should set Strip[2].A3 to 1' {
                $vmr.strip[2].A3 = $true
                $vmr.strip[2].A3 | Should -Be $true
            }

            It 'Should set Strip[2].A3 to 0' {
                $vmr.strip[2].A3 = $false
                $vmr.strip[2].A3 | Should -Be $false
            }
        }

        Context 'Strip[i].B1' {
            It 'Should set Strip[0].B1 to 1' {
                $vmr.strip[0].B1 = $true
                $vmr.strip[0].B1 | Should -Be $true
            }

            It 'Should set Strip[0].B1 to 0' {
                $vmr.strip[0].B1 = $false
                $vmr.strip[0].B1 | Should -Be $false
            }

            It 'Should set Strip[1].B1 to 1' {
                $vmr.strip[1].B1 = $true
                $vmr.strip[1].B1 | Should -Be $true
            }

            It 'Should set Strip[1].B1 to 0' {
                $vmr.strip[1].B1 = $false
                $vmr.strip[1].B1 | Should -Be $false
            }

            It 'Should set Strip[2].B1 to 1' {
                $vmr.strip[2].B1 = $true
                $vmr.strip[2].B1 | Should -Be $true
            }

            It 'Should set Strip[2].B1 to 0' {
                $vmr.strip[2].B1 = $false
                $vmr.strip[2].B1 | Should -Be $false
            }
        }

        Context 'Strip[i].B2' {
            It 'Should set Strip[0].B2 to 1' {
                $vmr.strip[0].B2 = $true
                $vmr.strip[0].B2 | Should -Be $true
            }

            It 'Should set Strip[0].B2 to 0' {
                $vmr.strip[0].B2 = $false
                $vmr.strip[0].B2 | Should -Be $false
            }

            It 'Should set Strip[1].B2 to 1' {
                $vmr.strip[1].B2 = $true
                $vmr.strip[1].B2 | Should -Be $true
            }

            It 'Should set Strip[1].B2 to 0' {
                $vmr.strip[1].B2 = $false
                $vmr.strip[1].B2 | Should -Be $false
            }

            It 'Should set Strip[2].B2 to 1' {
                $vmr.strip[2].B2 = $true
                $vmr.strip[2].B2 | Should -Be $true
            }

            It 'Should set Strip[2].B2 to 0' {
                $vmr.strip[2].B2 = $false
                $vmr.strip[2].B2 | Should -Be $false
            }
        }

        Context 'Strip[i].B3' {
            It 'Should set Strip[0].B3 to 1' {
                $vmr.strip[0].B3 = $true
                $vmr.strip[0].B3 | Should -Be $true
            }

            It 'Should set Strip[0].B3 to 0' {
                $vmr.strip[0].B3 = $false
                $vmr.strip[0].B3 | Should -Be $false
            }

            It 'Should set Strip[1].B3 to 1' {
                $vmr.strip[1].B3 = $true
                $vmr.strip[1].B3 | Should -Be $true
            }

            It 'Should set Strip[1].B3 to 0' {
                $vmr.strip[1].B3 = $false
                $vmr.strip[1].B3 | Should -Be $false
            }

            It 'Should set Strip[2].B3 to 1' {
                $vmr.strip[2].B3 = $true
                $vmr.strip[2].B3 | Should -Be $true
            }

            It 'Should set Strip[2].B3 to 0' {
                $vmr.strip[2].B3 = $false
                $vmr.strip[2].B3 | Should -Be $false
            }
        }

        Context 'Strip[i].Gain' {
            It 'Should set Strip[0].Gain to 3.6' {
                $vmr.strip[0].gain = 3.6
                $vmr.strip[0].gain | Should -Be 3.6
            }

            It 'Should set Strip[0].Gain to -0.2' {
                $vmr.strip[0].gain = -0.2
                $vmr.strip[0].gain | Should -Be -0.2
            }

            It 'Should set Strip[1].Gain to 5.1' {
                $vmr.strip[1].gain = 5.1
                $vmr.strip[1].gain | Should -Be 5.1
            }

            It 'Should set Strip[1].Gain to -4.2' {
                $vmr.strip[1].gain = -4.2
                $vmr.strip[1].gain | Should -Be -4.2
            }

            It 'Should set Strip[2].Gain to 2.7' {
                $vmr.strip[2].gain = 2.7
                $vmr.strip[2].gain | Should -Be 2.7
            }

            It 'Should set Strip[2].Gain to -2.5' {
                $vmr.strip[2].gain = -2.5
                $vmr.strip[2].gain | Should -Be -2.5
            }
        }

        Context 'Strip[i].Comp' {
            It 'Should set Strip[0].Comp to 3.6' {
                $vmr.strip[0].comp = 3.6
                $vmr.strip[0].comp | Should -Be 3.6
            }

            It 'Should set Strip[0].Comp to 0.2' {
                $vmr.strip[0].comp = 0.2
                $vmr.strip[0].comp | Should -Be 0.2
            }

            It 'Should set Strip[1].Comp to 5.1' {
                $vmr.strip[1].comp = 5.1
                $vmr.strip[1].comp | Should -Be 5.1
            }

            It 'Should set Strip[1].Comp to 4.2' {
                $vmr.strip[1].comp = 4.2
                $vmr.strip[1].comp | Should -Be 4.2
            }

            It 'Should set Strip[2].Comp to 2.7' {
                $vmr.strip[2].comp = 2.7
                $vmr.strip[2].comp | Should -Be 2.7
            }

            It 'Should set Strip[2].Comp to -2.5' {
                $vmr.strip[2].comp = 2.5
                $vmr.strip[2].comp | Should -Be 2.5
            }
        }

        Context 'Strip[i].Gate' {
            It 'Should set Strip[0].Gate to 3.6' {
                $vmr.strip[0].gate = 3.6
                $vmr.strip[0].gate | Should -Be 3.6
            }

            It 'Should set Strip[0].Gate to 0.2' {
                $vmr.strip[0].gate = 0.2
                $vmr.strip[0].gate | Should -Be 0.2
            }

            It 'Should set Strip[1].Gate to 5.1' {
                $vmr.strip[1].gate = 5.1
                $vmr.strip[1].gate | Should -Be 5.1
            }

            It 'Should set Strip[1].Gate to 3.2' {
                $vmr.strip[1].gate = 3.2
                $vmr.strip[1].gate | Should -Be 3.2
            }

            It 'Should set Strip[2].Gate to 2.7' {
                $vmr.strip[2].gate = 2.7
                $vmr.strip[2].gate | Should -Be 2.7
            }

            It 'Should set Strip[2].Gate to 2.5' {
                $vmr.strip[2].gate = 2.5
                $vmr.strip[2].gate | Should -Be 2.5
            }
        }

        Context 'Strip[i].Limit' {
            It 'Should set Strip[0].Limit to 3' {
                $vmr.strip[0].limit = 3
                $vmr.strip[0].limit | Should -Be 3
            }

            It 'Should set Strip[0].Limit to 0' {
                $vmr.strip[0].limit = 0
                $vmr.strip[0].limit | Should -Be 0
            }

            It 'Should set Strip[1].Limit to -5' {
                $vmr.strip[1].limit = -5
                $vmr.strip[1].limit | Should -Be -5
            }

            It 'Should set Strip[1].Limit to 0' {
                $vmr.strip[1].limit = 0
                $vmr.strip[1].limit | Should -Be 0
            }

            It 'Should set Strip[2].Limit to 2' {
                $vmr.strip[2].limit = 2
                $vmr.strip[2].limit | Should -Be 2
            }

            It 'Should set Strip[2].Limit to -3' {
                $vmr.strip[2].limit = -3
                $vmr.strip[2].limit | Should -Be -3
            }
        }

        Context 'Bus[i].Mute' {
            It 'Should set Bus[0].Mute to 1' {
                $vmr.bus[0].mute = $true
                $vmr.bus[0].mute | Should -Be $true
            }

            It 'Should set Bus[0].Mute to 0' {
                $vmr.bus[0].mute = $false
                $vmr.bus[0].mute | Should -Be $false
            }

            It 'Should set Bus[1].Mute to 1' {
                $vmr.bus[1].mute = $true
                $vmr.bus[1].mute | Should -Be $true
            }

            It 'Should set Bus[1].Mute to 0' {
                $vmr.bus[1].mute = $false
                $vmr.bus[1].mute | Should -Be $false
            }

            It 'Should set Bus[2].Mute to 1' {
                $vmr.bus[2].mute = $true
                $vmr.bus[2].mute | Should -Be $true
            }

            It 'Should set Bus[2].Mute to 0' {
                $vmr.bus[2].mute = $false
                $vmr.bus[2].mute | Should -Be $false
            }
        }

        Context 'Bus[i].Mono' {
            It 'Should set Bus[0].Mono to 1' {
                $vmr.bus[0].mono = $true
                $vmr.bus[0].mono | Should -Be $true
            }

            It 'Should set Bus[0].Mono to 0' {
                $vmr.bus[0].mono = $false
                $vmr.bus[0].mono | Should -Be $false
            }

            It 'Should set Bus[1].Mono to 1' {
                $vmr.bus[1].mono = $true
                $vmr.bus[1].mono | Should -Be $true
            }

            It 'Should set Bus[1].Mono to 0' {
                $vmr.bus[1].mono = $false
                $vmr.bus[1].mono | Should -Be $false
            }

            It 'Should set Bus[2].Mono to 1' {
                $vmr.bus[2].mono = $true
                $vmr.bus[2].mono | Should -Be $true
            }

            It 'Should set Bus[2].Mono to 0' {
                $vmr.bus[2].mono = $false
                $vmr.bus[2].mono | Should -Be $false
            }
        }

        Context 'Bus[i].Gain' {
            It 'Should set Bus[0].Gain to 3.6' {
                $vmr.bus[0].gain = 3.6
                $vmr.bus[0].gain | Should -Be 3.6
            }

            It 'Should set Bus[0].Gain to -0.2' {
                $vmr.bus[0].gain = -0.2
                $vmr.bus[0].gain | Should -Be -0.2
            }

            It 'Should set Bus[1].Gain to 5.1' {
                $vmr.bus[1].gain = 5.1
                $vmr.bus[1].gain | Should -Be 5.1
            }

            It 'Should set Bus[1].Gain to -4.2' {
                $vmr.bus[1].gain = -4.2
                $vmr.bus[1].gain | Should -Be -4.2
            }

            It 'Should set Bus[2].Gain to 2.7' {
                $vmr.bus[2].gain = 2.7
                $vmr.bus[2].gain | Should -Be 2.7
            }

            It 'Should set Bus[2].Gain to -2.5' {
                $vmr.bus[2].gain = -2.5
                $vmr.bus[2].gain | Should -Be -2.5
            }
        }
    }
}
