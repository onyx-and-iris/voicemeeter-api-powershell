Describe -Tag 'higher', -TestName 'All Higher Tests' {
    Describe 'Bool tests' -ForEach @(
        @{ Value = $true; Expected = $true }
        @{ Value = $false; Expected = $false }
    ) {
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ) {
            It "Should set and get Strip[$index] booleans" {
                $vmr.strip[$index].mute = $value
                $vmr.strip[$index].solo = $value
                $vmr.strip[$index].A1   = $value
                $vmr.strip[$index].B1   = $value
                
                $vmr.strip[$index].mute | Should -Be $expected
                $vmr.strip[$index].solo | Should -Be $expected
                $vmr.strip[$index].A1   | Should -Be $expected
                $vmr.strip[$index].B1   | Should -Be $expected
            }
            
            It "Should set and get Strip[$index] booleans (potato)" -Skip:$ifNotPotato {
                $vmr.strip[$index].postreverb = $value
                $vmr.strip[$index].postdelay  = $value
                $vmr.strip[$index].postfx1    = $value
                $vmr.strip[$index].postfx2    = $value
                
                $vmr.strip[$index].postreverb | Should -Be $expected
                $vmr.strip[$index].postdelay  | Should -Be $expected
                $vmr.strip[$index].postfx1    | Should -Be $expected
                $vmr.strip[$index].postfx2    | Should -Be $expected
            }
        }
            
        Context 'Strip, physical only' -ForEach @(
            @{ Index = $phys_in }
        ) {
            It "Should set and get Strip[$index] booleans" {
                $vmr.strip[$index].mono = $value
                $vmr.strip[$index].vaio = $value
                
                $vmr.strip[$index].mono | Should -Be $expected
                $vmr.strip[$index].vaio | Should -Be $expected
            }
            
            It "Should set and get Strip[$index] audibility and pitch booleans" -Skip:$ifNotPotato {
                $vmr.strip[$index].comp.makeup = $value
                $vmr.strip[$index].pitch.on    = $value
                
                $vmr.strip[$index].comp.makeup | Should -Be $expected
                $vmr.strip[$index].pitch.on    | Should -Be $expected
            }
        }
        
        Context 'Strip, first virtual' -ForEach @(
            @{ Index = $phys_in + 1 }
        ) {
            It "Should set and get virtual Strip[$index].MC via .Mono alias" {
                $vmr.strip[$index].mc = -not $value
                $vmr.strip[$index].mono = $value
                
                $vmr.strip[$index].mc | Should -Be $expected
                $vmr.strip[$index].mono | Should -Be $expected
            }
        }

        Context 'Bus, one physical one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
            It "Should set and get Bus[$index].Mute" {
                $vmr.bus[$index].mute = $value
                $vmr.bus[$index].mute | Should -Be $expected
            }
            
            It "Should set and get Bus[$index] booleans (potato)" -Skip:$ifNotPotato {
                $vmr.bus[$index].sel     = $value
                $vmr.bus[$index].monitor = $value
                
                $vmr.bus[$index].sel     | Should -Be $expected
                $vmr.bus[$index].monitor | Should -Be $expected
            }

            It "Should set and get Bus[$index] modes" {
                $vmr.bus[$index].mode.normal = $value
                $vmr.bus[$index].mode.normal | Should -Be $expected
                
                $vmr.bus[$index].mode.amix = $value
                $vmr.bus[$index].mode.amix | Should -Be $expected
                
                $vmr.bus[$index].mode.repeat = $value
                $vmr.bus[$index].mode.repeat | Should -Be $expected
                
                $vmr.bus[$index].mode.composite = $value
                $vmr.bus[$index].mode.composite | Should -Be $expected
            }
            
            It "Should set and get Bus[$index] modes (banana+)" -Skip:$ifBasic {
                $vmr.bus[$index].mode.bmix = $value
                $vmr.bus[$index].mode.bmix | Should -Be $expected
                
                $vmr.bus[$index].mode.tvmix = $value
                $vmr.bus[$index].mode.tvmix | Should -Be $expected
                
                $vmr.bus[$index].mode.upmix21 = $value
                $vmr.bus[$index].mode.upmix21 | Should -Be $expected
                
                $vmr.bus[$index].mode.upmix41 = $value
                $vmr.bus[$index].mode.upmix41 | Should -Be $expected
                
                $vmr.bus[$index].mode.upmix61 = $value
                $vmr.bus[$index].mode.upmix61 | Should -Be $expected
                
                $vmr.bus[$index].mode.centeronly = $value
                $vmr.bus[$index].mode.centeronly | Should -Be $expected
                
                $vmr.bus[$index].mode.lfeonly = $value
                $vmr.bus[$index].mode.lfeonly | Should -Be $expected
                
                $vmr.bus[$index].mode.rearonly = $value
                $vmr.bus[$index].mode.rearonly | Should -Be $expected
            }
        }
        
        Context 'Bus, physical only' -ForEach @(
            @{ Index = $phys_out }
        ) {
            It "Should set and get Bus[$index].Vaio" {
                $vmr.bus[$index].vaio = $value
                $vmr.bus[$index].vaio | Should -Be $expected
            }
        }

        Context 'Macrobutton' -ForEach @(
            @{ Index = 0 }, @{ Index = 69 }
        ) {
            It "Should set and get macrobutton[$index] State" {
                $vmr.button[$index].state = $value
                $vmr.button[$index].state | Should -Be $expected
            }
        }

        Context 'Vban instream' -ForEach @(
            @{ Index = $vban_in }
        ) {
            It "Should set vban.instream[$index].on" {
                $vmr.vban.instream[$index].on = $value
                $vmr.vban.instream[$index].on | Should -Be $expected
            }
        }

        Context 'Vban outstream' -ForEach @(
            @{ Index = $vban_out }
        ) {
            It "Should set vban.outstream[$index].on" {
                $vmr.vban.outstream[$index].on = $value
                $vmr.vban.outstream[$index].on | Should -Be $expected
            }
        }

        Context 'Recorder' -Skip:$ifBasic {
            It 'Should set and get Recorder.A3' {
                $vmr.recorder.A3 = $value
                $vmr.recorder.A3 | Should -Be $expected
            }

            It 'Should set and get Recorder.B1' {
                $vmr.recorder.B1 = $value
                $vmr.recorder.B1 | Should -Be $expected
            }

            It 'Should set and get Recorder.loop' {
                $vmr.recorder.loop = $value
            }
        }

        Context 'Command' {
            It 'Should set command.lock' {
                $vmr.command.lock = $value
            }
        }
    }

    Describe 'Int Tests' -ForEach @(
        @{ Index = $phys_in }, @{ Index = $virt_in }
    ) {
        Context 'Strip, one physical, one virtual' -Skip:$ifBasic -ForEach @(
            @{ Value = 3; Expected = 3 }
            @{ Value = -6; Expected = -6 }
        ) {
            It "Should set Strip[$index].Limit to 3" {
                $vmr.strip[$index].limit = $value
                $vmr.strip[$index].limit | Should -Be $expected
            }
        }

        Context 'Vban outstream' {
            Context 'sr' -ForEach @(
                @{ Value = 44100; Expected = 44100 }
                @{ Value = 48000; Expected = 48000 }
            ) {
                It "Should set vban.outstream[$index].sr to $value" {
                    $vmr.vban.outstream[$index].sr = $value
                    $vmr.vban.outstream[$index].sr | Should -Be $expected
                }
            }

            Context 'channel' -ForEach @(
                @{ Value = 1; Expected = 1 }
                @{ Value = 2; Expected = 2 }
            ) {
                It 'Should set vban.outstream[0].channel to 1' {
                    $vmr.vban.outstream[$index].channel = $value
                    $vmr.vban.outstream[$index].channel | Should -Be $expected
                }
            }            
        }
    }

    Describe 'Float Tests' {
        Describe 'Strip tests' {
            Context 'one physical, one virtual' -ForEach @(
                @{ Index = $phys_in }, @{ Index = $virt_in }
            ) {
                Context 'gain' -ForEach @(
                    @{ Value = 3.6; Expected = 3.6 }, @{ Value = -8.2; Expected = -8.2 }
                ) {
                    It "Should set Strip[$index].Gain to $value" {
                        $vmr.strip[$index].gain = $value
                        $vmr.strip[$index].gain | Should -Be $expected
                    }                    
                }
            }

            Context 'physical only' -Skip:$ifBasic -ForEach @(
                @{ Index = $phys_in }
            ) {
                Context 'comp, gate' -ForEach @(
                    @{ Value = 8.3; Expected = 8.3 }, @{ Value = 5.1; Expected = 5.1 }
                ) {
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
                ) {
                    It "Should set Strip[$index].Denoiser to $value" {
                        $vmr.strip[$index].denoiser.knob = $value
                        $vmr.strip[$index].denoiser.knob | Should -Be $expected
                    }
                }

                Context 'comp.{param}' -Skip:$ifNotPotato -ForEach @(
                    @{ Value = 8.3; Expected = 8.3 }, @{ Value = 5.1; Expected = 5.1 }
                ) {
                    It "Should set Strip[$index].Comp.Attack to $value" {
                        $vmr.strip[$index].comp.attack = $value
                        $vmr.strip[$index].comp.attack | Should -Be $expected
                    }
                }

                Context 'comp.{param}' -Skip:$ifNotPotato -ForEach @(
                    @{ Value = 0.3; Expected = 0.3 }, @{ Value = 0.8; Expected = 0.8 }
                ) {
                    It "Should set Strip[$index].Comp.Knee to $value" {
                        $vmr.strip[$index].comp.knee = $value
                        $vmr.strip[$index].comp.knee | Should -Be $expected
                    }
                }

                Context 'gate.{param}' -Skip:$ifNotPotato -ForEach @(
                    @{ Value = 103; Expected = 103 }, @{ Value = 3800; Expected = 3800 }
                ) {
                    It "Should set Strip[$index].Gate.BPSidechain to $value" {
                        $vmr.strip[$index].gate.bpsidechain = $value
                        $vmr.strip[$index].gate.bpsidechain | Should -Be $expected
                    }
                }

                Context 'gate.{param}' -Skip:$ifNotPotato -ForEach @(
                    @{ Value = 0.3; Expected = 0.3 }, @{ Value = 5000; Expected = 5000 }
                ) {
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
            ) {
                Context 'gain' -ForEach @(
                    @{ Value = 5.2; Expected = 5.2 }, @{ Value = -38.2; Expected = -38.2 }
                ) {
                    It "Should set Bus[$index].Gain to $value" {
                        $vmr.bus[$index].gain = $value
                        $vmr.bus[$index].gain | Should -Be $expected
                    }                    
                }
            }
        }
    }

    Describe 'String Tests' {
        Context 'Strip, one physical, one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ) {
            It "Should set Strip[$index].Label" -ForEach @(
                @{ Value = 'test0'; Expected = 'test0' }
                @{ Value = 'test1'; Expected = 'test1' }
            ) {
                $vmr.strip[$index].label = $value
                $vmr.strip[$index].label | Should -Be $expected
            }
        }

        Context 'Bus, one physical, one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
            It "Should set Bus[$index].Label" -ForEach @(
                @{ Value = 'test0'; Expected = 'test0' }
                @{ Value = 'test1'; Expected = 'test1' }
            ) {
                $vmr.bus[$index].label = $value
                $vmr.bus[$index].label | Should -Be $expected
            }
        }

        Describe 'Vban' -ForEach @(
            @{ Index = $vban_in }
        ) {
            Context 'instream' {
                Context 'ip' -ForEach @(
                    @{ Value = '0.0.0.0'; Expected = '0.0.0.0' }
                ) {
                    It "Should set vban.instream[$index].name to $value" {
                        $vmr.vban.instream[$index].ip = $value
                        $vmr.vban.instream[$index].ip | Should -Be $expected
                    }
                }                 
            }

            Context 'outstream' {
                Context 'ip' -ForEach @(
                    @{ Value = '0.0.0.0'; Expected = '0.0.0.0' }
                ) {
                    It "Should set vban.outstream[$index].name to $value" {
                        $vmr.vban.outstream[$index].ip = $value
                        $vmr.vban.outstream[$index].ip | Should -Be $expected
                    }
                }                  
            }
        }
    }
    
    Describe 'EQ Tests' {
        Context 'Bus & physical strip' -ForEach @(
            @{ Eq = $vmr.bus[$phys_out].eq;  Label = "Bus[$phys_out]";  Skip = $ifBasic }
            @{ Eq = $vmr.bus[$virt_out].eq;  Label = "Bus[$virt_out]";  Skip = $ifBasic }
            @{ Eq = $vmr.strip[$phys_in].eq; Label = "Strip[$phys_in]"; Skip = $ifNotPotato }
        ) {
            It "Should set and get $Label.EQ booleans" -Skip:$Skip -ForEach @(
                @{ Value = $true; Expected = $true }
                @{ Value = $false; Expected = $false }
            ) {
                $Eq.on = $value
                $Eq.ab = $value
                
                $Eq.on | Should -Be $expected
                $Eq.ab | Should -Be $expected
            }
            
            It "Should save then load EQ on $Label" -Skip:$Skip {
                $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "vmreq-$(New-Guid).txt")
                try {
                    $Eq.save($tmp)
                    Test-Path $tmp | Should -BeTrue
                    $Eq.load($tmp)
                }
                finally {
                    if (Test-Path $tmp) { Remove-Item $tmp -Force }
                }
            }
            
            It "Should set and get Channel[0].Cell[0] params on $Label" -Skip:$Skip {
                $Eq.channel[0].cell[0].on   = $true
                $Eq.channel[0].cell[0].type = 1
                $Eq.channel[0].cell[0].f    = 1000
                $Eq.channel[0].cell[0].gain = 2.5
                $Eq.channel[0].cell[0].q    = 52.7

                $Eq.channel[0].cell[0].on   | Should -Be $true
                $Eq.channel[0].cell[0].type | Should -Be 1
                $Eq.channel[0].cell[0].f    | Should -Be 1000
                $Eq.channel[0].cell[0].gain | Should -Be 2.5
                $Eq.channel[0].cell[0].q    | Should -Be 52.7
                
                $Eq.channel[0].cell[0].on = $false
                $Eq.channel[0].cell[0].on | Should -Be $false
            }
        }
    }
}
