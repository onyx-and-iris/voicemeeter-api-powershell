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
        
        Context 'FX' -Skip:$ifNotPotato {
            It "Should set and get FX booleans" {
                $vmr.fx.reverb.on = $value
                $vmr.fx.reverb.ab = $value
                $vmr.fx.delay.on  = $value
                $vmr.fx.delay.ab  = $value
                
                $vmr.fx.reverb.on | Should -Be $expected
                $vmr.fx.reverb.ab | Should -Be $expected
                $vmr.fx.delay.on  | Should -Be $expected
                $vmr.fx.delay.ab  | Should -Be $expected
            }
        }
        
        Context 'Patch' -Skip:$ifBasic {
            It "Should set and get Patch booleans" {
                $vmr.patch.insert[0]          = $value
                $vmr.patch.postfadercomposite = $value
                $vmr.patch.postfxinsert       = $value
                
                $vmr.patch.insert[0]          | Should -Be $expected
                $vmr.patch.postfadercomposite | Should -Be $expected
                $vmr.patch.postfxinsert       | Should -Be $expected
            }
        }
        
        Context 'Option' {
            It "Should set and get Option.ASIOsr" {
                $vmr.option.asiosr = $value
                $vmr.option.asiosr | Should -Be $expected
            }
            
            It "Should set and get Option booleans (potato)" -Skip:$ifNotPotato {
                $vmr.option.monitoronsel = $value
                $vmr.option.slidermode   = $value
                
                $vmr.option.monitoronsel | Should -Be $expected
                $vmr.option.slidermode   | Should -Be $expected
            }
        }

        Context 'Macrobutton' -ForEach @(
            @{ Index = 0 }, @{ Index = 69 }
        ) {
            It "Should set and get macrobutton[$index] booleans" {
                $vmr.button[$index].state     = $value
                $vmr.button[$index].stateonly = $value
                $vmr.button[$index].trigger   = $value
                
                $vmr.button[$index].state     | Should -Be $expected
                $vmr.button[$index].stateonly | Should -Be $expected
                $vmr.button[$index].trigger   | Should -Be $expected
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
            
            It "Should save then load EQ on $Label" -Skip:$Skip {
                $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "vmreq-$(New-Guid).xml")
                try {
                    $Eq.save($tmp)
                    Test-Path $tmp | Should -BeTrue
                    $Eq.load($tmp)
                }
                finally {
                    if (Test-Path $tmp) { Remove-Item $tmp -Force }
                }
            }
        }
    }
    
    Describe 'VBAN Tests' {
        It 'Should disable then enable VBAN' {
            $vmr.vban.enable = $true
            $vmr.vban.enable = $false
            $vmr.vban.enable = $true
        }
        
        Context 'Instream, outstream' -ForEach @(
            @{ Stream = $vmr.vban.instream[$vban_in]; Label = "Instream[$vban_in]"; ifIn = $true }
            @{ Stream = $vmr.vban.outstream[$vban_out]; Label = "Outstream[$vban_out]"; ifOut = $true }
        ) {
            It "Should set and get $Label.on" -ForEach @(
                @{ Value = $true; Expected = $true }
                @{ Value = $false; Expected = $false }
            ) {
                $Stream.on = $value
                $Stream.on | Should -Be $expected
            }
            
            It "Should set and get $Label strings" {
                $Stream.name = "$Label"
                $Stream.ip   = '0.0.0.0'
                
                $Stream.name | Should -Be "$Label"
                $Stream.ip   | Should -Be '0.0.0.0'
            }
            
            It "Should set and get $Label integers" {
                $Stream.port    = 65535
                $Stream.quality = 4
                $Stream.route   = 8
                
                $Stream.port    | Should -Be 65535
                $Stream.quality | Should -Be 4
                $Stream.route   | Should -Be 8
            }
            
            It "Should set and get $Label integers (out)" -Skip:$ifIn {
                $Stream.sr      = 44100
                $Stream.channel = 8
                $Stream.bit     = 24
                
                $Stream.sr      | Should -Be 44100
                $Stream.channel | Should -Be 8
                $Stream.bit     | Should -Be 24
            }
            
            It "Should get $Label integers (in)" -Skip:$ifOut {
                $samplerates = @(11025, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000)
                $channels    = 1..8
                $bitdepths   = @(16, 24)
                
                $sr      = $Stream.sr
                $channel = $Stream.channel
                $bit     = $Stream.bit
                
                $sr      | Should -BeIn $samplerates
                $channel | Should -BeIn $channels
                $bit     | Should -BeIn $bitdepths
            }
        }
    }
    
    Describe 'Special Command Tests' {
        It 'Should hide then show GUI' {
            $vmr.command.show
            $vmr.command.hide
            $vmr.command.show
        }
        
        It 'Should lock then unlock GUI' {
            $vmr.command.lock = $true
            $vmr.command.lock | Should -Be $true
            
            $vmr.command.lock = $false
            $vmr.command.lock | Should -Be $false
        }
        
        It 'Should show then hide VBAN chat' {
            $vmr.command.showvbanchat = $false
            
            $vmr.command.showvbanchat = $true
            $vmr.command.showvbanchat | Should -Be $true
            
            $vmr.command.showvbanchat = $false
            $vmr.command.showvbanchat | Should -Be $false
        }
        
        It 'Should save, reset, and load config' {
            $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "vmrconfig-$(New-Guid).xml")
            try {
                $vmr.command.save($tmp)
                Test-Path $tmp | Should -BeTrue
                $vmr.command.reset
                $vmr.command.load($tmp)
            }
            finally {
                if (Test-Path $tmp) { Remove-Item $tmp -Force }
            }
        }
    }
}
