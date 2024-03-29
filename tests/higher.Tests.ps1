Describe -Tag 'higher', -TestName 'All Higher Tests' {
    Describe 'Bool tests' -ForEach @(
        @{ Value = $true; Expected = $true }
        @{ Value = $false; Expected = $false }
    ){
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ){
            It "Should set and get Strip[$index].Mute" {
                $vmr.strip[$index].mute = $value
                $vmr.strip[$index].mute | Should -Be $expected
            }

            It "Should set and get Strip[$index].Solo" {
                $vmr.strip[$index].solo = $value
                $vmr.strip[$index].solo | Should -Be $expected
            }

            It "Should set and get Strip[$index].A1" {
                $vmr.strip[$index].A1 = $value
                $vmr.strip[$index].A1 | Should -Be $expected
            }

            It "Should set and get Strip[$index].B1" {
                $vmr.strip[$index].B1 = $value
                $vmr.strip[$index].B1 | Should -Be $expected
            }
        }

        Context 'physical only' -ForEach @(
            @{ Index = $phys_in }
        ){
            Context 'eq.{param}' -Skip:$ifNotPotato {
                It "Should set Strip[$index].EQ.On to $value" {
                    $vmr.strip[$index].eq.on = $value
                    $vmr.strip[$index].eq.on | Should -Be $expected
                }                    
            }
        }

        Context 'Bus, one physical one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ){
            It "Should set and get Bus[$index].Eq.On" -Skip:$ifBasic {
                $vmr.bus[$index].eq.on = $value
                $vmr.bus[$index].eq.on | Should -Be $expected
            }

            It "Should set and get Bus[$index].Mono" {
                $vmr.bus[$index].mono = $value
                $vmr.bus[$index].mono | Should -Be $expected
            }

            It "Should set and get Bus[$index].mode.amix" -Skip:$ifBasic {
                $vmr.bus[$index].mode.amix = $value
                $vmr.bus[$index].mode.amix | Should -Be $expected
            }

            It "Should set and get Bus[$index].mode.centeronly" -Skip:$ifBasic {
                $vmr.bus[$index].mode.centeronly = $value
                $vmr.bus[$index].mode.centeronly | Should -Be $expected
            }
        }

        Context 'Macrobutton' -ForEach @(
            @{ Index = 0 }, @{ Index = 69 }
        ){
            It "Should set and get macrobutton[$index] State" {
                $vmr.button[$index].state = $value
                $vmr.button[$index].state | Should -Be $expected
            }
        }

        Context 'Vban instream' -ForEach @(
            @{ Index = $vban_in }
        ){
            It "Should set vban.instream[$index].on" {
                $vmr.vban.instream[$index].on = $value
                $vmr.vban.instream[$index].on | Should -Be $expected
            }
        }

        Context 'Vban outstream' -ForEach @(
            @{ Index = $vban_out }
        ){
            It "Should set vban.outstream[$index].on" {
                $vmr.vban.outstream[$index].on = $value
                $vmr.vban.outstream[$index].on | Should -Be $expected
            }
        }

        Context 'Recorder' -Skip:$ifBasic {
            It "Should set and get Recorder.A3" {
                $vmr.recorder.A3 = $value
                $vmr.recorder.A3 | Should -Be $expected
            }

            It "Should set and get Recorder.B1" {
                $vmr.recorder.B1 = $value
                $vmr.recorder.B1 | Should -Be $expected
            }

            It "Should set and get Recorder.loop" {
                $vmr.recorder.loop = $value
            }
        }

        Context 'Command' {
            It 'Should set command.lock' {
                $vmr.command.lock = $value
            }
        }
    }

    Describe 'Float Tests' {
        Describe 'Strip tests' {
            Context 'one physical, one virtual' -ForEach @(
                @{ Index = $phys_in }, @{ Index = $virt_in }
            ){
                Context 'gain' -ForEach @(
                    @{ Value = 3.6; Expected = 3.6 }, @{ Value = -8.2; Expected = -8.2 }
                ){
                    It "Should set Strip[$index].Gain to $value" {
                        $vmr.strip[$index].gain = $value
                        $vmr.strip[$index].gain | Should -Be $expected
                    }                    
                }
            }

            Context 'physical only' -Skip:$ifBasic -ForEach @(
                @{ Index = $phys_in }
            ){
                Context 'comp, gate' -ForEach @(
                    @{ Value = 8.3; Expected = 8.3 }, @{ Value = 5.1; Expected = 5.1 }
                ){
                    It "Should set Strip[$index].Comp to $value" {
                        $vmr.strip[$index].comp.knob = $value
                        $vmr.strip[$index].comp.knob | Should -Be $expected
                    }

                    It "Should set Strip[$index].Gate to $value" {
                        $vmr.strip[$index].gate.knob = $value
                        $vmr.strip[$index].gate.knob | Should -Be $expected
                    }
                }

                Context 'denoiser' -Skip:$ifNotPotato -ForEach @(
                    @{ Value = 8.3; Expected = 8.3 }, @{ Value = 5.1; Expected = 5.1 }
                ){
                    It "Should set Strip[$index].Denoiser to $value" {
                        $vmr.strip[$index].denoiser.knob = $value
                        $vmr.strip[$index].denoiser.knob | Should -Be $expected
                    }
                }

                Context 'comp.{param}' -Skip:$ifNotPotato -ForEach @(
                    @{ Value = 8.3; Expected = 8.3 }, @{ Value = 5.1; Expected = 5.1 }
                ){
                    It "Should set Strip[$index].Comp.Attack to $value" {
                        $vmr.strip[$index].comp.attack = $value
                        $vmr.strip[$index].comp.attack | Should -Be $expected
                    }
                }

                Context 'comp.{param}' -Skip:$ifNotPotato -ForEach @(
                    @{ Value = 0.3; Expected = 0.3 }, @{ Value = 0.8; Expected = 0.8 }
                ){
                    It "Should set Strip[$index].Comp.Knee to $value" {
                        $vmr.strip[$index].comp.knee = $value
                        $vmr.strip[$index].comp.knee | Should -Be $expected
                    }
                }

                Context 'gate.{param}' -Skip:$ifNotPotato -ForEach @(
                    @{ Value = 103; Expected = 103 }, @{ Value = 3800; Expected = 3800 }
                ){
                    It "Should set Strip[$index].Gate.BPSidechain to $value" {
                        $vmr.strip[$index].gate.bpsidechain = $value
                        $vmr.strip[$index].gate.bpsidechain | Should -Be $expected
                    }
                }

                Context 'gate.{param}' -Skip:$ifNotPotato -ForEach @(
                    @{ Value = 0.3; Expected = 0.3 }, @{ Value = 5000; Expected = 5000 }
                ){
                    It "Should set Strip[$index].Gate.Hold to $value" {
                        $vmr.strip[$index].gate.hold = $value
                        $vmr.strip[$index].gate.hold | Should -Be $expected
                    }
                }
            }            
        }

        Describe 'Bus tests' {
            Context 'one physical, one virtual' -ForEach @(
                @{ Index = $phys_out }, @{ Index = $virt_out }
            ){
                Context 'gain' -ForEach @(
                    @{ Value = 5.2; Expected = 5.2 }, @{ Value = -38.2; Expected = -38.2 }
                ){
                    It "Should set Bus[$index].Gain to $value" {
                        $vmr.bus[$index].gain = $value
                        $vmr.bus[$index].gain | Should -Be $expected
                    }                    
                }
            }
        }
    }

    Describe 'Int Tests' -ForEach @(
        @{ Index = $phys_in }, @{ Index = $virt_in }
    ){
        Context 'Strip, one physical, one virtual' -Skip:$ifBasic -ForEach @(
            @{ Value = 3; Expected = 3 }
            @{ Value = -6; Expected = -6 }
        ){
            It "Should set Strip[$index].Limit to 3" {
                $vmr.strip[$index].limit = $value
                $vmr.strip[$index].limit | Should -Be $expected
            }
        }

        Context 'Vban outstream' {
            Context 'sr' -ForEach @(
                @{ Value = 44100; Expected = 44100 }
                @{ Value = 48000; Expected = 48000 }
            ){
                It "Should set vban.outstream[$index].sr to $value" {
                    $vmr.vban.outstream[$index].sr = $value
                    $vmr.vban.outstream[$index].sr | Should -Be $expected
                }
            }

            Context 'channel' -ForEach @(
                @{ Value = 1; Expected = 1 }
                @{ Value = 2; Expected = 2 }
            ){
                It 'Should set vban.outstream[0].channel to 1' {
                    $vmr.vban.outstream[$index].channel = $value
                    $vmr.vban.outstream[$index].channel | Should -Be $expected
                }
            }            
        }
    }

    Describe 'String Tests' {
        Context 'Strip, one physical, one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ){
            It "Should set Strip[$index].Label" -ForEach @(
                @{ Value = "test0"; Expected = "test0" }
                @{ Value = "test1"; Expected = "test1" }
            ){
                $vmr.strip[$index].label = $value
                $vmr.strip[$index].label | Should -Be $expected
            }
        }

        Context 'Bus, one physical, one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ){
            It "Should set Bus[$index].Label" -ForEach @(
                @{ Value = "test0"; Expected = "test0" }
                @{ Value = "test1"; Expected = "test1" }
            ){
                $vmr.bus[$index].label = $value
                $vmr.bus[$index].label | Should -Be $expected
            }
        }

        Describe 'Vban' -ForEach @(
            @{ Index = $vban_in }
        ){
            Context 'instream' {
                Context 'ip' -ForEach @(
                    @{ Value = "0.0.0.0"; Expected = "0.0.0.0" }
                ){
                    It "Should set vban.instream[$index].name to $value" {
                        $vmr.vban.instream[$index].ip = $value
                        $vmr.vban.instream[$index].ip | Should -Be $expected
                    }
                }                 
            }

            Context 'outstream' {
                Context 'ip' -ForEach @(
                    @{ Value = "0.0.0.0"; Expected = "0.0.0.0" }
                ){
                    It "Should set vban.outstream[$index].name to $value" {
                        $vmr.vban.outstream[$index].ip = $value
                        $vmr.vban.outstream[$index].ip | Should -Be $expected
                    }
                }                  
            }
        }
    }
}
