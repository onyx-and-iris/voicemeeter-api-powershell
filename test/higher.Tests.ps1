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
    }
}
