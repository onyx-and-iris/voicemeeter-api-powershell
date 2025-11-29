Describe -Tag 'higher', -TestName 'All Higher Tests' {
    Describe 'Bool tests' -Tag 'bool' -ForEach @(
        @{ Value = $true; Expected = $true }
        @{ Value = $false; Expected = $false }
    ) {
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ) {
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

        Context 'Strip, physical only' -ForEach @(
            @{ Index = $phys_in }
        ) {
            Context 'Eq' -Skip:$ifNotPotato -ForEach @(
                @{ Eq = $vmr.strip[$index].eq }
            ) {
                It "Should set Strip[$index].EQ.On to $value" {
                    $eq.on = $value
                    $eq.on | Should -Be $value
                }

                It "Should set Strip[$index].EQ.AB to $value" {
                    $eq.ab = $value
                    $eq.ab | Should -Be $value
                }

                It "Should set Strip[$index].EQ.Channel[$strip_ch].Cell[$cells].On to $value" {
                    $eq.channel[$strip_ch].cell[$cells].on = $value
                    $eq.channel[$strip_ch].cell[$cells].on | Should -Be $value
                }
            }
        }

        Context 'Bus, one physical one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
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

            Context 'Eq' -Skip:$ifBasic -ForEach @(
                @{ Eq = $vmr.bus[$index].eq }
            ) {
                It "Should set Bus[$index].EQ.On to $value" {
                    $eq.on = $value
                    $eq.on | Should -Be $value
                }

                It "Should set Bus[$index].EQ.AB to $value" {
                    $eq.ab = $value
                    $eq.ab | Should -Be $value
                }

                It "Should set Bus[$index].EQ.Channel[$bus_ch].Cell[$cells].On to $value" {
                    $eq.channel[$bus_ch].cell[$cells].on = $value
                    $eq.channel[$bus_ch].cell[$cells].on | Should -Be $value
                }
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

        Context 'Vban' {
            It 'Should set and get Vban.enable' {
                $vmr.vban.enable = $value
                $vmr.command.restart
                Start-Sleep -Milliseconds 2000
                $vmr.vban.enable | Should -Be $expected
            }
        
            Context 'Instream' -ForEach @(
                @{ Index = $vban_inA }
                # @{ Index = $vban_inM }
                # @{ Index = $vban_inT }
            ) {
                It "Should set vban.instream[$index].on" {
                    $vmr.vban.instream[$index].on = $value
                    $vmr.vban.instream[$index].on | Should -Be $expected
                }
            }

            Context 'Outstream' -ForEach @(
                @{ Index = $vban_outA }
                # @{ Index = $vban_outM }
            ) {
                It "Should set vban.outstream[$index].on" {
                    $vmr.vban.outstream[$index].on = $value
                    $vmr.vban.outstream[$index].on | Should -Be $expected
                }
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

        Context 'Fx' -Skip:$ifNotPotato {
            Context 'Delay' {
                It 'Should set and get Fx.delay.on' {
                    $vmr.fx.delay.on = $value
                    $vmr.fx.delay.on | Should -Be $expected
                }

                It 'Should set and get Fx.delay.ab' {
                    $vmr.fx.delay.ab = $value
                    $vmr.fx.delay.ab | Should -Be $expected
                }
            }
            
            Context 'Reverb' {
                It 'Should set and get Fx.reverb.on' {
                    $vmr.fx.reverb.on = $value
                    $vmr.fx.reverb.on | Should -Be $expected
                }

                It 'Should set and get Fx.reverb.ab' {
                    $vmr.fx.reverb.ab = $value
                    $vmr.fx.reverb.ab | Should -Be $expected
                }
            }
        }
        
        Context 'Patch' {
            It 'Should set and get Patch.insert[$insert]' -Skip:$ifBasic {
                $vmr.patch.insert[$insert].set($value)
                $vmr.patch.insert[$insert].get() | Should -Be $value
            }
            
            It 'Should set and get Patch.postfadercomposite' -Skip:$ifBasic {
                $vmr.patch.postfadercomposite = $value
                $vmr.patch.postfadercomposite | Should -Be $value
            }
            
            It 'Should set and get Patch.postfxinsert' -Skip:$ifBasic {
                $vmr.patch.postfxinsert = $value
                $vmr.patch.postfxinsert | Should -Be $value
            }
        }
        
        Context 'Option' {
            It 'Should set and get Option.monitoronsel' -Skip:$ifNotPotato {
                $vmr.option.monitoronsel = $value
                $vmr.command.restart
                Start-Sleep -Milliseconds 2000
                $vmr.option.monitoronsel | Should -Be $value
            }
            
            It 'Should set and get Option.slidermode' -Skip:$ifNotPotato {
                $vmr.option.slidermode = $value
                $vmr.command.restart
                Start-Sleep -Milliseconds 2000
                $vmr.option.slidermode | Should -Be $value
            }
        }
    }

    Describe 'Float Tests' -Tag 'float' {
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ) {
            It "Should set Strip[$index].Gain to $value" -ForEach @(
                @{ Value = 3.6; Expected = 3.6 }, @{ Value = -8.2; Expected = -8.2 }
            ) {
                $vmr.strip[$index].gain = $value
                $vmr.strip[$index].gain | Should -Be $expected
            }
        }

        Context 'Strip, physical only' -Skip:$ifBasic -ForEach @(
            @{ Index = $phys_in }
        ) {
            Context 'Knobs' -Skip:$ifBasic -ForEach @(
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

                It "Should set Strip[$index].Denoiser to $value" -Skip:$ifNotPotato {
                    $vmr.strip[$index].denoiser.knob = $value
                    $vmr.strip[$index].denoiser.knob | Should -Be $expected
                }
            }

            Context 'Comp' -Skip:$ifNotPotato {
                It "Should set Strip[$index].Comp.Attack" -ForEach @(
                    @{ Value = 8.3; Expected = 8.3 }, @{ Value = 5.1; Expected = 5.1 }
                ) {
                    $vmr.strip[$index].comp.attack = $value
                    $vmr.strip[$index].comp.attack | Should -Be $expected
                }

                It "Should set Strip[$index].Comp.Knee" -ForEach @(
                    @{ Value = 0.3; Expected = 0.3 }, @{ Value = 0.8; Expected = 0.8 }
                ) {
                    $vmr.strip[$index].comp.knee = $value
                    $vmr.strip[$index].comp.knee | Should -Be $expected
                }
            }

            Context 'Gate' -Skip:$ifNotPotato {
                It "Should set Strip[$index].Gate.BPSidechain" -ForEach @(
                    @{ Value = 103.1; Expected = 103.1 }, @{ Value = 3800; Expected = 3800 }
                ) {
                    $vmr.strip[$index].gate.bpsidechain = $value
                    $vmr.strip[$index].gate.bpsidechain | Should -Be $expected
                }

                It "Should set Strip[$index].Gate.Hold" -ForEach @(
                    @{ Value = 0.3; Expected = 0.3 }, @{ Value = 5000; Expected = 5000 }
                ) {
                    $vmr.strip[$index].gate.hold = $value
                    $vmr.strip[$index].gate.hold | Should -Be $expected
                }
            }

            Context 'EQ' -Skip:$ifNotPotato -ForEach @(
                @{ Eq = $vmr.strip[$index].eq }
            ) {
                It "Should set Strip[$index].EQ.Channel[$strip_ch].Cell[$cells].F" -ForEach @(
                    @{ Value = 1234.6; Expected = 1234.6 }, @{ Value = 7500; Expected = 7500 }
                ) {
                    $eq.channel[$strip_ch].cell[$cells].f = $value
                    $eq.channel[$strip_ch].cell[$cells].f | Should -Be $expected
                }

                It "Should set Strip[$index].EQ.Channel[$strip_ch].Cell[$cells].Gain" -ForEach @(
                    @{ Value = 4.2; Expected = 4.2 }, @{ Value = -7.3; Expected = -7.3 }
                ) {
                    $eq.channel[$strip_ch].cell[$cells].gain = $value
                    $eq.channel[$strip_ch].cell[$cells].gain | Should -Be $expected
                }

                It "Should set Strip[$index].EQ.Channel[$strip_ch].Cell[$cells].Q" -ForEach @(
                    @{ Value = 1.2; Expected = 1.2 }, @{ Value = 5.6; Expected = 5.6 }
                ) {
                    $eq.channel[$strip_ch].cell[$cells].q = $value
                    $eq.channel[$strip_ch].cell[$cells].q | Should -Be $expected
                }
            }
        }

        Context 'Bus, one physical one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
            It "Should set Bus[$index].Gain" -ForEach @(
                @{ Value = 5.2; Expected = 5.2 }, @{ Value = -38.2; Expected = -38.2 }
            ) {
                $vmr.bus[$index].gain = $value
                $vmr.bus[$index].gain | Should -Be $expected
            }

            Context 'EQ' -Skip:$ifBasic -ForEach @(
                @{ Eq = $vmr.bus[$index].eq }
            ) {
                It "Should set Bus[$index].EQ.Channel[$bus_ch].Cell[$cells].F" -ForEach @(
                    @{ Value = 1234.6; Expected = 1234.6 }, @{ Value = 7500; Expected = 7500 }
                ) {
                    $eq.channel[$bus_ch].cell[$cells].f = $value
                    $eq.channel[$bus_ch].cell[$cells].f | Should -Be $expected
                }

                It "Should set Bus[$index].EQ.Channel[$bus_ch].Cell[$cells].Gain" -ForEach @(
                    @{ Value = 4.2; Expected = 4.2 }, @{ Value = -7.3; Expected = -7.3 }
                ) {
                    $eq.channel[$bus_ch].cell[$cells].gain = $value
                    $eq.channel[$bus_ch].cell[$cells].gain | Should -Be $expected
                }

                It "Should set Bus[$index].EQ.Channel[$bus_ch].Cell[$cells].Q" -ForEach @(
                    @{ Value = 1.2; Expected = 1.2 }, @{ Value = 5.6; Expected = 5.6 }
                ) {
                    $eq.channel[$bus_ch].cell[$cells].q = $value
                    $eq.channel[$bus_ch].cell[$cells].q | Should -Be $expected
                }
            }
        }
        
        Context 'Option' {
            It "Should set and get Option.delay[$phys_out]" -ForEach @(
                @{ Value = 486.57 }, @{ Value = 26.41 }
            ) {
                $vmr.option.delay[$phys_out].set($value)
                $vmr.command.restart
                Start-Sleep -Milliseconds 2000
                $vmr.option.delay[$phys_out].get() | Should -Be $value
            }
        }
    }

    Describe 'Int Tests' -Tag 'int' {
        Context 'Strip, one physical, one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ) {
            It "Should set and get Strip[$index].Limit" -Skip:$ifBasic -ForEach @(
                @{ Value = 3; Expected = 3 }
                @{ Value = -6; Expected = -6 }
            ) {
                $vmr.strip[$index].limit = $value
                $vmr.strip[$index].limit | Should -Be $expected
            }
        }

        Context 'Strip, physical only' -ForEach @(
            @{ Index = $phys_in }
        ) {
            Context 'Device' {
                It "Should get Strip[$index].Device.sr" {
                    $vmr.strip[$index].device.sr | Should -BeOfType [int]
                }
            }

            Context 'Eq' -Skip:$ifNotPotato -ForEach @(
                @{ Eq = $vmr.strip[$index].eq }
            ) {
                It "Should set Strip[$index].EQ.Channel[$strip_ch].Cell[$cells].Type" -ForEach @(
                    @{ Value = 0; Expected = 0 }, @{ Value = 6; Expected = 6 }
                ) {
                    $eq.channel[$strip_ch].cell[$cells].type = $value
                    $eq.channel[$strip_ch].cell[$cells].type | Should -Be $expected
                }
            }
        }

        Context 'Bus, one physical one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
            Context 'Eq' -Skip:$ifBasic -ForEach @(
                @{ Eq = $vmr.bus[$index].eq }
            ) {
                It "Should set Bus[$index].EQ.Channel[$bus_ch].Cell[$cells].Type" -ForEach @(
                    @{ Value = 0; Expected = 0 }, @{ Value = 6; Expected = 6 }
                ) {
                    $eq.channel[$bus_ch].cell[$cells].type = $value
                    $eq.channel[$bus_ch].cell[$cells].type | Should -Be $expected
                }
            }
        }

        Context 'Bus, physical only' -ForEach @(
            @{ Index = $phys_out }
        ) {
            Context 'Device' {
                It "Should get Bus[$index].Device.sr" {
                    $vmr.bus[$index].device.sr | Should -BeOfType [int]
                }
            }
        }

        Context 'Bus, virtual only' -ForEach @(
            @{ Index = $virt_out }
        ) {
            Context 'Device' -Skip:$ifNotBasic {
                It "Should get Bus[$index].Device.sr" {
                    $vmr.bus[$index].device.sr | Should -BeOfType [int]
                }
            }
        }

        Context 'Vban' {
            It 'Should set vban.port' -ForEach @(
                @{ Value = 1024; Expected = 1024 }
                @{ Value = 65535; Expected = 65535 }
            ) {
                $vmr.vban.port = $value
                $vmr.command.restart
                Start-Sleep -Milliseconds 2000
                $vmr.vban.port | Should -Be $expected
            }
            
            Context 'Instream' -ForEach @(
                @{ Index = $vban_inA }
            ) {
                It "Should set vban.instream[$index].port" -ForEach @(
                    @{ Value = 1024; Expected = 1024 }
                    @{ Value = 65535; Expected = 65535 }
                ) {
                    $vmr.vban.instream[$index].port = $value
                    $vmr.command.restart
                    Start-Sleep -Milliseconds 2000
                    $vmr.vban.instream[$index].port | Should -Be $expected
                }

                It "Should set vban.instream[$index].sr" {
                    $vmr.vban.instream[$index].sr | Should -BeOfType [int]
                }

                It "Should set vban.instream[$index].channel" {
                    $vmr.vban.instream[$index].channel | Should -BeOfType [int]
                }

                It "Should set vban.instream[$index].bit" {
                    $vmr.vban.instream[$index].bit | Should -BeOfType [int]
                }

                It "Should set vban.instream[$index].quality" -ForEach @(
                    @{ Value = 0; Expected = 0 }
                    @{ Value = 4; Expected = 4 }
                ) {
                    $vmr.vban.instream[$index].quality = $value
                    Start-Sleep -Milliseconds 500
                    $vmr.vban.instream[$index].quality | Should -Be $expected
                }

                It "Should set vban.instream[$index].route" -ForEach @(
                    @{ Value = $phys_in; Expected = $phys_in }
                    @{ Value = $virt_in; Expected = $virt_in }
                ) {
                    $vmr.vban.instream[$index].route = $value
                    $vmr.vban.instream[$index].route | Should -Be $expected
                }
            }
            
            Context 'Outstream' -ForEach @(
                @{ Index = $vban_outA }
            ) {
                It "Should set vban.outstream[$index].port" -ForEach @(
                    @{ Value = 1024; Expected = 1024 }
                    @{ Value = 65535; Expected = 65535 }
                ) {
                    $vmr.vban.outstream[$index].port = $value
                    $vmr.command.restart
                    Start-Sleep -Milliseconds 2000
                    $vmr.vban.outstream[$index].port | Should -Be $expected
                }
                
                It "Should set vban.outstream[$index].sr" -ForEach @(
                    @{ Value = 44100; Expected = 44100 }
                    @{ Value = 48000; Expected = 48000 }
                ) {
                    $vmr.vban.outstream[$index].sr = $value
                    $vmr.vban.outstream[$index].sr | Should -Be $expected
                }

                It "Should set vban.outstream[$index].channel" -ForEach @(
                    @{ Value = 1; Expected = 1 }
                    @{ Value = 2; Expected = 2 }
                ) {
                    $vmr.vban.outstream[$index].channel = $value
                    $vmr.vban.outstream[$index].channel | Should -Be $expected
                }

                It "Should set vban.outstream[$index].bit" -ForEach @(
                    @{ Value = 16; Expected = 16 }
                    @{ Value = 24; Expected = 24 }
                ) {
                    $vmr.vban.outstream[$index].bit = $value
                    $vmr.vban.outstream[$index].bit | Should -Be $expected
                }

                It "Should set vban.outstream[$index].quality" -ForEach @(
                    @{ Value = 0; Expected = 0 }
                    @{ Value = 4; Expected = 4 }
                ) {
                    $vmr.vban.outstream[$index].quality = $value
                    Start-Sleep -Milliseconds 500
                    $vmr.vban.outstream[$index].quality | Should -Be $expected
                }

                It "Should set vban.outstream[$index].route" -ForEach @(
                    @{ Value = $phys_out; Expected = $phys_out }
                    @{ Value = $virt_out; Expected = $virt_out }
                ) {
                    $vmr.vban.outstream[$index].route = $value
                    $vmr.vban.outstream[$index].route | Should -Be $expected
                }
            }
        }
        
        Context 'Patch' {
            It 'Should set and get Patch.composite[$composite]' -Skip:$ifBasic -ForEach @(
                @{ Value = 22 }, @{ Value = 6 }
            ) {
                $vmr.patch.composite[$composite].set($value)
                $vmr.patch.composite[$composite].get() | Should -Be $value
            }
        }
        
        Context 'Option' {
            It 'Should set and get Option.sr' -ForEach @(
                @{ Value = 44100 }, @{ Value = 48000 }
            ) {
                $vmr.option.sr = $value
                Start-Sleep -Milliseconds 500
                $vmr.option.sr | Should -Be $value
            }
            
            Context 'Option.buffer' -ForEach @(
                @{ Value = 1024 }, @{ Value = 512 }
            ) {
                It 'Should set and get mme buffer' {
                    $vmr.option.buffer.mme = $value
                    Start-Sleep -Milliseconds 500
                    $vmr.option.buffer.mme | Should -Be $value
                }
                
                It 'Should set and get wdm buffer' {
                    $vmr.option.buffer.wdm = $value
                    Start-Sleep -Milliseconds 500
                    $vmr.option.buffer.wdm | Should -Be $value
                }
                
                It 'Should set and get ks buffer' {
                    $vmr.option.buffer.ks = $value
                    Start-Sleep -Milliseconds 500
                    $vmr.option.buffer.ks | Should -Be $value
                }
            }
        }
    }

    Describe 'String Tests' -Tag 'string' {
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

        Context 'Strip, physical only' -ForEach @(
            @{ Index = $phys_in }
        ) {
            Context 'Device' -ForEach @(
                @{ Value = 'testInput' }, @{ Value = '' }
            ) {
                It "Should set Strip[$index].Device.wdm" {
                    $vmr.strip[$index].device.wdm = $value
                    Start-Sleep -Milliseconds 800
                    $vmr.strip[$index].device.name | Should -Be $value
                }

                It "Should set Strip[$index].Device.ks" {
                    $vmr.strip[$index].device.ks = $value
                    Start-Sleep -Milliseconds 800
                    $vmr.strip[$index].device.name | Should -Be $value
                }
            
                It "Should set Strip[$index].Device.mme" {
                    $vmr.strip[$index].device.mme = $value
                    Start-Sleep -Milliseconds 800
                    $vmr.strip[$index].device.name | Should -Be $value
                }
            }

            Context 'EQ' -Skip:$ifNotPotato -ForEach @(
                @{ Eq = $vmr.strip[$index].eq }
            ) {
                It "Should save then load Strip[$index].EQ" -ForEach @(
                    @{ Fq = 1234.5; Gain = 4.2; Ql = 56.2; Type = 3 }
                ) {
                    $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "vmreq-$(New-Guid).xml")
                    try {
                        # set some values
                        $eq.channel[$strip_ch].cell[$cells].f = $fq
                        $eq.channel[$strip_ch].cell[$cells].gain = $gain
                        $eq.channel[$strip_ch].cell[$cells].q = $ql
                        $eq.channel[$strip_ch].cell[$cells].type = $type
                        
                        # save eq
                        $eq.Save($tmp)
                        Start-Sleep -Milliseconds 100
                        Test-Path $tmp | Should -BeTrue

                        # change values
                        $eq.channel[$strip_ch].cell[$cells].f = 1000
                        $eq.channel[$strip_ch].cell[$cells].gain = 0
                        $eq.channel[$strip_ch].cell[$cells].q = 1
                        $eq.channel[$strip_ch].cell[$cells].type = 0

                        # load eq
                        $eq.Load($tmp)
                        Start-Sleep -Milliseconds 100

                        # verify values
                        $eq.channel[$strip_ch].cell[$cells].f | Should -Be $fq
                        $eq.channel[$strip_ch].cell[$cells].gain | Should -Be $gain
                        $eq.channel[$strip_ch].cell[$cells].q | Should -Be $ql
                        $eq.channel[$strip_ch].cell[$cells].type | Should -Be $type
                    }
                    finally {
                        if (Test-Path $tmp) {
                            Remove-Item $tmp -Force
                        }
                    }
                }
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

            Context 'EQ' -Skip:$ifBasic -ForEach @(
                @{ Eq = $vmr.bus[$index].eq }
            ) {
                It "Should save then load Bus[$index].EQ" -ForEach @(
                    @{ Fq = 1234.5; Gain = 4.2; Ql = 56.2; Type = 3 }
                ) {
                    $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "vmreq-$(New-Guid).xml")
                    try {
                        # set some values
                        $eq.channel[$bus_ch].cell[$cells].f = $fq
                        $eq.channel[$bus_ch].cell[$cells].gain = $gain
                        $eq.channel[$bus_ch].cell[$cells].q = $ql
                        $eq.channel[$bus_ch].cell[$cells].type = $type
                        
                        # save eq
                        $eq.Save($tmp)
                        Start-Sleep -Milliseconds 100
                        Test-Path $tmp | Should -BeTrue

                        # change values
                        $eq.channel[$bus_ch].cell[$cells].f = 1000
                        $eq.channel[$bus_ch].cell[$cells].gain = 0
                        $eq.channel[$bus_ch].cell[$cells].q = 1
                        $eq.channel[$bus_ch].cell[$cells].type = 0

                        # load eq
                        $eq.Load($tmp)
                        Start-Sleep -Milliseconds 100

                        # verify values
                        $eq.channel[$bus_ch].cell[$cells].f | Should -Be $fq
                        $eq.channel[$bus_ch].cell[$cells].gain | Should -Be $gain
                        $eq.channel[$bus_ch].cell[$cells].q | Should -Be $ql
                        $eq.channel[$bus_ch].cell[$cells].type | Should -Be $type
                    }
                    finally {
                        if (Test-Path $tmp) {
                            Remove-Item $tmp -Force
                        }
                    }
                }
            }
        }

        Context 'Bus, physical only' -ForEach @(
            @{ Index = $phys_out }
        ) {
            Context 'Device' -ForEach @(
                @{ Value = 'testOutput' }, @{ Value = '' }
            ) {
                It "Should set Bus[$index].Device.wdm" {
                    $vmr.bus[$index].device.wdm = $value
                    Start-Sleep -Milliseconds 800
                    $vmr.bus[$index].device.name | Should -Be $value
                }

                It "Should set Bus[$index].Device.ks" {
                    $vmr.bus[$index].device.ks = $value
                    Start-Sleep -Milliseconds 800
                    $vmr.bus[$index].device.name | Should -Be $value
                }
            
                It "Should set Bus[$index].Device.mme" {
                    $vmr.bus[$index].device.mme = $value
                    Start-Sleep -Milliseconds 800
                    $vmr.bus[$index].device.name | Should -Be $value
                }
            }
        }

        Context 'Bus, virtual only' -ForEach @(
            @{ Index = $virt_out }
        ) {
            Context 'Device' -Skip:$ifNotBasic -ForEach @(
                @{ Value = 'testOutput' }, @{ Value = '' }
            ) {
                It "Should set Bus[$index].Device.wdm" {
                    $vmr.bus[$index].device.wdm = $value
                    Start-Sleep -Milliseconds 800
                    $vmr.bus[$index].device.name | Should -Be $value
                }

                It "Should set Bus[$index].Device.ks" {
                    $vmr.bus[$index].device.ks = $value
                    Start-Sleep -Milliseconds 800
                    $vmr.bus[$index].device.name | Should -Be $value
                }

                It "Should set Bus[$index].Device.mme" {
                    $vmr.bus[$index].device.mme = $value
                    Start-Sleep -Milliseconds 800
                    $vmr.bus[$index].device.name | Should -Be $value
                }
            }
        }

        Describe 'Vban' {
            Context 'Instream' -ForEach @(
                @{ Index = $vban_inA }
                # @{ Index = $vban_inM }
                # @{ Index = $vban_inT }
            ) {
                It "Should set vban.instream[$index].name" -ForEach @(
                    @{ Value = 'TestIn0'; Expected = 'TestIn0' }
                    @{ Value = 'TestIn1'; Expected = 'TestIn1' }
                ) {
                    $vmr.vban.instream[$index].name = $value
                    $vmr.vban.instream[$index].name | Should -Be $expected
                }
                
                It "Should set vban.instream[$index].ip" -ForEach @(
                    @{ Value = '0.0.0.0'; Expected = '0.0.0.0' }
                ) {
                    $vmr.vban.instream[$index].ip = $value
                    $vmr.vban.instream[$index].ip | Should -Be $expected
                }
            }

            Context 'Outstream' -ForEach @(
                @{ Index = $vban_outA }
                # @{ Index = $vban_outM }
            ) {
                It "Should set vban.outstream[$index].name" -ForEach @(
                    @{ Value = 'TestOut0'; Expected = 'TestOut0' }
                    @{ Value = 'TestOut1'; Expected = 'TestOut1' }
                ) {
                    $vmr.vban.outstream[$index].name = $value
                    $vmr.vban.outstream[$index].name | Should -Be $expected
                }
                
                It "Should set vban.outstream[$index].ip" -ForEach @(
                    @{ Value = '0.0.0.0'; Expected = '0.0.0.0' }
                ) {
                    $vmr.vban.outstream[$index].ip = $value
                    $vmr.vban.outstream[$index].ip | Should -Be $expected
                }       
            }
        }
    }
}
