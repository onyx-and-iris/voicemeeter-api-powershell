Describe -Tag 'higher', -TestName 'All Alias Tests' {
    Describe 'Macrobutton Tests' {
        Context 'mode = State' {
            It 'Should set macrobutton[0] State to 1' {
                $vmr.button[0].state = 1
                $vmr.button[0].state | Should -Be 1
            }

            It 'Should set macrobutton[0] State to 0' {
                $vmr.button[0].state = 0
                $vmr.button[0].state | Should -Be 0
            }

            It 'Should set macrobutton[1] State to 1' {
                $vmr.button[1].state = 1
                $vmr.button[1].state | Should -Be 1
            }

            It 'Should set macrobutton[1] State to 0' {
                $vmr.button[1].state = 0
                $vmr.button[1].state | Should -Be 0
            }

            It 'Should set macrobutton[2] State to 1' {
                $vmr.button[2].state = 1
                $vmr.button[2].state | Should -Be 1
            }

            It 'Should set macrobutton[2] State to 0' {
                $vmr.button[2].state = 0
                $vmr.button[2].state | Should -Be 0
            }
        }

        Context 'mode = StateOnly' {
            It 'Should set macrobutton[0] StateOnly to 1' {
                $vmr.button[0].stateonly = 1
                $vmr.button[0].stateonly | Should -Be 1
            }

            It 'Should set macrobutton[0] StateOnly to 0' {
                $vmr.button[0].stateonly = 0
                $vmr.button[0].stateonly | Should -Be 0
            }

            It 'Should set macrobutton[1] StateOnly to 1' {
                $vmr.button[1].stateonly = 1
                $vmr.button[1].stateonly | Should -Be 1
            }

            It 'Should set macrobutton[1] StateOnly to 0' {
                $vmr.button[1].stateonly = 0
                $vmr.button[1].stateonly | Should -Be 0
            }

            It 'Should set macrobutton[2] StateOnly to 1' {
                $vmr.button[2].stateonly = 1
                $vmr.button[2].stateonly | Should -Be 1
            }

            It 'Should set macrobutton[2] StateOnly to 0' {
                $vmr.button[2].stateonly = 0
                $vmr.button[2].stateonly | Should -Be 0
            }
        }

        Context 'mode = Trigger' {
            It 'Should set macrobutton[0] Trigger to 1' {
                $vmr.button[0].trigger = 1
                $vmr.button[0].trigger | Should -Be 1
            }

            It 'Should set macrobutton[0] Trigger to 0' {
                $vmr.button[0].trigger = 0
                $vmr.button[0].trigger | Should -Be 0
            }

            It 'Should set macrobutton[1] Trigger to 1' {
                $vmr.button[1].trigger = 1
                $vmr.button[1].trigger | Should -Be 1
            }

            It 'Should set macrobutton[1] Trigger to 0' {
                $vmr.button[1].trigger = 0
                $vmr.button[1].trigger | Should -Be 0
            }

            It 'Should set macrobutton[2] Trigger to 1' {
                $vmr.button[2].trigger = 1
                $vmr.button[2].trigger | Should -Be 1
            }

            It 'Should set macrobutton[2] Trigger to 0' {
                $vmr.button[2].trigger = 0
                $vmr.button[2].trigger | Should -Be 0
            }
        }
    }

    Describe 'Set and Get Param Float Tests' {
        Context 'Strip[i].Mute' {
            It 'Should set Strip[0].Mute to 1' {
                $vmr.strip[0].mute = 1
                $vmr.strip[0].mute | Should -Be 1
            }

            It 'Should set Strip[0].Mute to 0' {
                $vmr.strip[0].mute = 0
                $vmr.strip[0].mute | Should -Be 0
            }

            It 'Should set Strip[1].Mute to 1' {
                $vmr.strip[1].mute = 1
                $vmr.strip[1].mute | Should -Be 1
            }

            It 'Should set Strip[1].Mute to 0' {
                $vmr.strip[1].mute = 0
                $vmr.strip[1].mute | Should -Be 0
            }

            It 'Should set Strip[2].Mute to 1' {
                $vmr.strip[2].mute = 1
                $vmr.strip[2].mute | Should -Be 1
            }

            It 'Should set Strip[2].Mute to 0' {
                $vmr.strip[2].mute = 0
                $vmr.strip[2].mute | Should -Be 0
            }
        }

        Context 'Strip[i].Solo' {
            It 'Should set Strip[0].Solo to 1' {
                $vmr.strip[0].solo = 1
                $vmr.strip[0].solo | Should -Be 1
            }

            It 'Should set Strip[0].Solo to 0' {
                $vmr.strip[0].solo = 0
                $vmr.strip[0].solo | Should -Be 0
            }

            It 'Should set Strip[1].Solo to 1' {
                $vmr.strip[1].solo = 1
                $vmr.strip[1].solo | Should -Be 1
            }

            It 'Should set Strip[1].Solo to 0' {
                $vmr.strip[1].solo = 0
                $vmr.strip[1].solo | Should -Be 0
            }

            It 'Should set Strip[2].Solo to 1' {
                $vmr.strip[2].solo = 1
                $vmr.strip[2].solo | Should -Be 1
            }

            It 'Should set Strip[2].Solo to 0' {
                $vmr.strip[2].solo = 0
                $vmr.strip[2].solo | Should -Be 0
            }
        }

        Context 'Strip[i].Mono' {
            It 'Should set Strip[0].Mono to 1' {
                $vmr.strip[0].mono = 1
                $vmr.strip[0].mono | Should -Be 1
            }

            It 'Should set Strip[0].Mono to 0' {
                $vmr.strip[0].mono = 0
                $vmr.strip[0].mono | Should -Be 0
            }

            It 'Should set Strip[1].Mono to 1' {
                $vmr.strip[1].mono = 1
                $vmr.strip[1].mono | Should -Be 1
            }

            It 'Should set Strip[1].Mono to 0' {
                $vmr.strip[1].mono = 0
                $vmr.strip[1].mono | Should -Be 0
            }

            It 'Should set Strip[2].Mono to 1' {
                $vmr.strip[2].mono = 1
                $vmr.strip[2].mono | Should -Be 1
            }

            It 'Should set Strip[2].Mono to 0' {
                $vmr.strip[2].mono = 0
                $vmr.strip[2].mono | Should -Be 0
            }
        }

        Context 'Strip[i].A1' {
            It 'Should set Strip[0].A1 to 1' {
                $vmr.strip[0].A1 = 1
                $vmr.strip[0].A1 | Should -Be 1
            }

            It 'Should set Strip[0].A1 to 0' {
                $vmr.strip[0].A1 = 0
                $vmr.strip[0].A1 | Should -Be 0
            }

            It 'Should set Strip[1].A1 to 1' {
                $vmr.strip[1].A1 = 1
                $vmr.strip[1].A1 | Should -Be 1
            }

            It 'Should set Strip[1].A1 to 0' {
                $vmr.strip[1].A1 = 0
                $vmr.strip[1].A1 | Should -Be 0
            }

            It 'Should set Strip[2].A1 to 1' {
                $vmr.strip[2].A1 = 1
                $vmr.strip[2].A1 | Should -Be 1
            }

            It 'Should set Strip[2].A1 to 0' {
                $vmr.strip[2].A1 = 0
                $vmr.strip[2].A1 | Should -Be 0
            }
        }

        Context 'Strip[i].A2' {
            It 'Should set Strip[0].A2 to 1' {
                $vmr.strip[0].A2 = 1
                $vmr.strip[0].A2 | Should -Be 1
            }

            It 'Should set Strip[0].v to 0' {
                $vmr.strip[0].A2 = 0
                $vmr.strip[0].A2 | Should -Be 0
            }

            It 'Should set Strip[1].A2 to 1' {
                $vmr.strip[1].A2 = 1
                $vmr.strip[1].A2 | Should -Be 1
            }

            It 'Should set Strip[1].A2 to 0' {
                $vmr.strip[1].A2 = 0
                $vmr.strip[1].A2 | Should -Be 0
            }

            It 'Should set Strip[2].A2 to 1' {
                $vmr.strip[2].A2 = 1
                $vmr.strip[2].A2 | Should -Be 1
            }

            It 'Should set Strip[2].A2 to 0' {
                $vmr.strip[2].A2 = 0
                $vmr.strip[2].A2 | Should -Be 0
            }
        }

        Context 'Strip[i].A3' {
            It 'Should set Strip[0].A3 to 1' {
                $vmr.strip[0].A3 = 1
                $vmr.strip[0].A3 | Should -Be 1
            }

            It 'Should set Strip[0].A3 to 0' {
                $vmr.strip[0].A3 = 0
                $vmr.strip[0].A3 | Should -Be 0
            }

            It 'Should set Strip[1].A3 to 1' {
                $vmr.strip[1].A3 = 1
                $vmr.strip[1].A3 | Should -Be 1
            }

            It 'Should set Strip[1].A3 to 0' {
                $vmr.strip[1].A3 = 0
                $vmr.strip[1].A3 | Should -Be 0
            }

            It 'Should set Strip[2].A3 to 1' {
                $vmr.strip[2].A3 = 1
                $vmr.strip[2].A3 | Should -Be 1
            }

            It 'Should set Strip[2].A3 to 0' {
                $vmr.strip[2].A3 = 0
                $vmr.strip[2].A3 | Should -Be 0
            }
        }

        Context 'Strip[i].B1' {
            It 'Should set Strip[0].B1 to 1' {
                $vmr.strip[0].B1 = 1
                $vmr.strip[0].B1 | Should -Be 1
            }

            It 'Should set Strip[0].B1 to 0' {
                $vmr.strip[0].B1 = 0
                $vmr.strip[0].B1 | Should -Be 0
            }

            It 'Should set Strip[1].B1 to 1' {
                $vmr.strip[1].B1 = 1
                $vmr.strip[1].B1 | Should -Be 1
            }

            It 'Should set Strip[1].B1 to 0' {
                $vmr.strip[1].B1 = 0
                $vmr.strip[1].B1 | Should -Be 0
            }

            It 'Should set Strip[2].B1 to 1' {
                $vmr.strip[2].B1 = 1
                $vmr.strip[2].B1 | Should -Be 1
            }

            It 'Should set Strip[2].B1 to 0' {
                $vmr.strip[2].B1 = 0
                $vmr.strip[2].B1 | Should -Be 0
            }
        }

        Context 'Strip[i].B2' {
            It 'Should set Strip[0].B2 to 1' {
                $vmr.strip[0].B2 = 1
                $vmr.strip[0].B2 | Should -Be 1
            }

            It 'Should set Strip[0].B2 to 0' {
                $vmr.strip[0].B2 = 0
                $vmr.strip[0].B2 | Should -Be 0
            }

            It 'Should set Strip[1].B2 to 1' {
                $vmr.strip[1].B2 = 1
                $vmr.strip[1].B2 | Should -Be 1
            }

            It 'Should set Strip[1].B2 to 0' {
                $vmr.strip[1].B2 = 0
                $vmr.strip[1].B2 | Should -Be 0
            }

            It 'Should set Strip[2].B2 to 1' {
                $vmr.strip[2].B2 = 1
                $vmr.strip[2].B2 | Should -Be 1
            }

            It 'Should set Strip[2].B2 to 0' {
                $vmr.strip[2].B2 = 0
                $vmr.strip[2].B2 | Should -Be 0
            }
        }

        Context 'Strip[i].B3' {
            It 'Should set Strip[0].B3 to 1' {
                $vmr.strip[0].B3 = 1
                $vmr.strip[0].B3 | Should -Be 1
            }

            It 'Should set Strip[0].B3 to 0' {
                $vmr.strip[0].B3 = 0
                $vmr.strip[0].B3 | Should -Be 0
            }

            It 'Should set Strip[1].B3 to 1' {
                $vmr.strip[1].B3 = 1
                $vmr.strip[1].B3 | Should -Be 1
            }

            It 'Should set Strip[1].B3 to 0' {
                $vmr.strip[1].B3 = 0
                $vmr.strip[1].B3 | Should -Be 0
            }

            It 'Should set Strip[2].B3 to 1' {
                $vmr.strip[2].B3 = 1
                $vmr.strip[2].B3 | Should -Be 1
            }

            It 'Should set Strip[2].B3 to 0' {
                $vmr.strip[2].B3 = 0
                $vmr.strip[2].B3 | Should -Be 0
            }
        }
    }
}
