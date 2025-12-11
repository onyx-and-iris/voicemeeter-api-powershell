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
            It "Should set Strip[$index].Mono" {
                $vmr.strip[$index].mono = $value
                $vmr.strip[$index].mono | Should -Be $expected
            }

            It "Should set Strip[$index].VAIO" {
                $vmr.strip[$index].vaio = $value
                $vmr.strip[$index].vaio | Should -Be $expected
            }

            Context 'Pitch' -Skip:$ifNotPotato {
                It "Should set Strip[$index].Pitch.On" {
                    $vmr.strip[$index].pitch.on = $value
                    $vmr.strip[$index].pitch.on | Should -Be $expected
                }
            }
            
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

        Context 'Strip, first virtual' -ForEach @(
            @{ Index = $phys_in + 1 }
        ) {
            It "Should set Strip[$index].MC via alias 'Mono'" {
                $vmr.strip[$index].mono = $value
                $vmr.strip[$index].mc | Should -Be $expected
            }
        }

        Context 'Bus, one physical one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
            It "Should set and get Bus[$index].Monitor" -Skip:$ifNotPotato {
                $vmr.bus[$index].monitor = $value
                $vmr.bus[$index].monitor | Should -Be $expected
            }

            It "Should set and get Bus[$index].Mute" {
                $vmr.bus[$index].mute = $value
                $vmr.bus[$index].mute | Should -Be $expected
            }

            It "Should set and get Bus[$index].Sel" -Skip:$ifNotPotato {
                $vmr.bus[$index].sel = $value
                $vmr.bus[$index].sel | Should -Be $expected
            }

            It "Should set and get Bus[$index].mode.amix" {
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

        Context 'Bus, physical only' -ForEach @(
            @{ Index = $phys_out }
        ) {
            It "Should set and get Bus[$index].vaio" {
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

        Context 'Vban' {
            It 'Should set and get Vban.enable' {
                $vmr.vban.enable = $value
                $vmr.command.restart()
                Start-Sleep -Milliseconds 2000
                $vmr.vban.enable | Should -Be $expected
            }
        
            Context 'Instream, audio, midi, text' -ForEach @(
                @{ Index = $vban_inA }
                @{ Index = $vban_inM }
                @{ Index = $vban_inT }
            ) {
                It "Should set vban.instream[$index].on" {
                    $vmr.vban.instream[$index].on = $value
                    $vmr.vban.instream[$index].on | Should -Be $expected
                }
            }

            Context 'Outstream, audio, midi, video' -ForEach @(
                @{ Index = $vban_outA }
                @{ Index = $vban_outM }
                @{ Index = $vban_outV }
            ) {
                It "Should set vban.outstream[$index].on" {
                    $vmr.vban.outstream[$index].on = $value
                    $vmr.vban.outstream[$index].on | Should -Be $expected
                }
            }

            Context 'Outstream, video only' -ForEach @(
                @{ Index = $vban_outV }
            ) {
                It "Should set vban.outstream[$index].vcursor" {
                    $vmr.vban.outstream[$index].vcursor = $value
                    $vmr.vban.outstream[$index].vcursor | Should -Be $expected
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

            It 'Should set and get Recorder.armstrip[i]' -ForEach @(
                @{ Index = $phys_in }, @{ Index = $virt_in }
            ) {
                $vmr.recorder.armstrip[$index].set($value)
                $vmr.recorder.armstrip[$index].get() | Should -Be $value
            }

            It 'Should set and get Recorder.armbus[i]' -ForEach @(
                @{ Index = $phys_out }, @{ Index = $virt_out }
            ) {
                $vmr.recorder.armbus[$index].set($value)
                $vmr.recorder.armbus[$index].get() | Should -Be $value
            }

            Context 'Mode' {
                It 'Should set and get Recorder.mode.multitrack' {
                    $vmr.recorder.mode.multitrack = $value
                    $vmr.recorder.mode.multitrack | Should -Be $expected
                }

                It 'Should set and get Recorder.mode.loop' {
                    $vmr.recorder.mode.loop = $value
                    $vmr.recorder.mode.loop | Should -Be $expected
                }
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
                $vmr.command.restart()
                Start-Sleep -Milliseconds 2000
                $vmr.option.monitoronsel | Should -Be $value
            }
            
            It 'Should set and get Option.slidermode' -Skip:$ifNotPotato {
                $vmr.option.slidermode = $value
                $vmr.command.restart()
                Start-Sleep -Milliseconds 2000
                $vmr.option.slidermode | Should -Be $value
            }
        }
    }

    Describe 'Float Tests' -Tag 'float' -ForEach @(
        @{ Gain = -24.63; Knob = 5.27; Slide = -7.51; Xy10 = 0.83; Xy05 = -0.42; MsHz = 196.57 }
        @{ Gain = -12.48; Knob = 8.91; Slide = 3.14; Xy10 = 0.27; Xy05 = 0.29; MsHz = 142.13 }
    ) {
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ) {
            It "Should set Strip[$index].Gain" {
                $vmr.strip[$index].gain = $gain
                $vmr.strip[$index].gain | Should -Be $gain
            }

            It "Should set Strip[$index].Limit" -Skip:$ifBasic {
                $vmr.strip[$index].limit = $gain
                $vmr.strip[$index].limit | Should -Be $gain
            }

            Context 'Gainlayers' -Skip:$ifNotPotato -ForEach @(
                @{ Layer = $phys_out }, @{ Layer = $virt_out }
            ) {
                It "Should set Strip[$index].Gainlayer[$layer]" {
                    $vmr.strip[$index].gainlayer[$layer].set($gain)
                    $vmr.strip[$index].gainlayer[$layer].get() | Should -Be $gain
                }
            }
        }

        Context 'Strip, physical only' -ForEach @(
            @{ Index = $phys_in }
        ) {
            It "Should set Strip[$index].Pan_Y" {
                $vmr.strip[$index].pan_y = $xy10
                $vmr.strip[$index].pan_y | Should -Be $xy10
            }
            
            Context 'Comp, Gate' -Skip:$ifBasic {
                It "Should set Strip[$index].Comp" {
                    $vmr.strip[$index].comp.knob = $knob
                    $vmr.strip[$index].comp.knob | Should -Be $knob
                }

                It "Should set Strip[$index].Gate" {
                    $vmr.strip[$index].gate.knob = $knob
                    $vmr.strip[$index].gate.knob | Should -Be $knob
                }
            }

            Context 'Comp' -Skip:$ifNotPotato {
                It "Should set Strip[$index].Comp.Attack" {
                    $vmr.strip[$index].comp.attack = $msHz
                    $vmr.strip[$index].comp.attack | Should -Be $msHz
                }

                It "Should set Strip[$index].Comp.Knee" {
                    $vmr.strip[$index].comp.knee = $xy10
                    $vmr.strip[$index].comp.knee | Should -Be $xy10
                }
            }

            Context 'Gate' -Skip:$ifNotPotato {
                It "Should set Strip[$index].Gate.BPSidechain" {
                    $vmr.strip[$index].gate.bpsidechain = $msHz
                    $vmr.strip[$index].gate.bpsidechain | Should -Be $msHz
                }

                It "Should set Strip[$index].Gate.Hold" {
                    $vmr.strip[$index].gate.hold = $msHz
                    $vmr.strip[$index].gate.hold | Should -Be $msHz
                }
            }

            Context 'Denoiser' -Skip:$ifNotPotato {
                It "Should set Strip[$index].Denoiser" {
                    $vmr.strip[$index].denoiser.knob = $knob
                    $vmr.strip[$index].denoiser.knob | Should -Be $knob
                }

                It "Should set Strip[$index].Denoiser.Threshold" {
                    $vmr.strip[$index].denoiser.threshold = $knob
                    $vmr.strip[$index].denoiser.threshold | Should -Be $knob
                }
            }

            Context 'Pitch' -Skip:$ifNotPotato {
                It "Should set Strip[$index].Pitch.drywet" {
                    $vmr.strip[$index].pitch.drywet = $slide
                    $vmr.strip[$index].pitch.drywet | Should -Be $slide
                }

                It "Should set Strip[$index].Pitch.pitchvalue" {
                    $vmr.strip[$index].pitch.pitchvalue = $slide
                    $vmr.strip[$index].pitch.pitchvalue | Should -Be $slide
                }

                It "Should set Strip[$index].Pitch.loformant" {
                    $vmr.strip[$index].pitch.loformant = $slide
                    $vmr.strip[$index].pitch.loformant | Should -Be $slide
                }

                It "Should set Strip[$index].Pitch.medformant" {
                    $vmr.strip[$index].pitch.medformant = $slide
                    $vmr.strip[$index].pitch.medformant | Should -Be $slide
                }

                It "Should set Strip[$index].Pitch.hiformant" {
                    $vmr.strip[$index].pitch.hiformant = $slide
                    $vmr.strip[$index].pitch.hiformant | Should -Be $slide
                }
            }

            Context 'Audibility' -Skip:$ifNotBasic {
                It "Should set Strip[$index].Audibility" {
                    $vmr.strip[$index].audibility.knob = $knob
                    $vmr.strip[$index].audibility.knob | Should -Be $knob
                }
            }

            Context 'EQ' -Skip:$ifNotPotato -ForEach @(
                @{ Eq = $vmr.strip[$index].eq }
            ) {
                It "Should set Strip[$index].EQ.Channel[$strip_ch].Cell[$cells].F" {
                    $eq.channel[$strip_ch].cell[$cells].f = $msHz
                    $eq.channel[$strip_ch].cell[$cells].f | Should -Be $msHz
                }

                It "Should set Strip[$index].EQ.Channel[$strip_ch].Cell[$cells].Gain" {
                    $eq.channel[$strip_ch].cell[$cells].gain = $slide
                    $eq.channel[$strip_ch].cell[$cells].gain | Should -Be $slide
                }

                It "Should set Strip[$index].EQ.Channel[$strip_ch].Cell[$cells].Q" {
                    $eq.channel[$strip_ch].cell[$cells].q = $knob
                    $eq.channel[$strip_ch].cell[$cells].q | Should -Be $knob
                }
            }
        }

        Context 'Strip, virtual only' -ForEach @(
            @{ Index = $virt_in }
        ) {
            It "Should set Strip[$index].Pan_Y" {
                $vmr.strip[$index].pan_y = $xy05
                $vmr.strip[$index].pan_y | Should -Be $xy05
            }
            
            Context 'EQ' {
                BeforeEach {
                    $vmr.strip[$index].eqgain1 = 0
                    $vmr.strip[$index].eqgain2 = 0
                    $vmr.strip[$index].eqgain3 = 0
                }
            
                It "Should set Strip[$index].EQGain1 via alias 'bass'" {
                    $vmr.strip[$index].bass = $slide
                    $vmr.strip[$index].eqgain1 | Should -Be $slide
                }

                It "Should set Strip[$index].EQGain1 via alias 'low'" {
                    $vmr.strip[$index].low = $slide
                    $vmr.strip[$index].eqgain1 | Should -Be $slide
                }

                It "Should set Strip[$index].EQGain2 via alias 'mid'" {
                    $vmr.strip[$index].mid = $slide
                    $vmr.strip[$index].eqgain2 | Should -Be $slide
                }

                It "Should set Strip[$index].EQGain2 via alias 'med'" {
                    $vmr.strip[$index].med = $slide
                    $vmr.strip[$index].eqgain2 | Should -Be $slide
                }

                It "Should set Strip[$index].EQGain3 via alias 'treble'" {
                    $vmr.strip[$index].treble = $slide
                    $vmr.strip[$index].eqgain3 | Should -Be $slide
                }

                It "Should set Strip[$index].EQGain3 via alias 'high'" {
                    $vmr.strip[$index].high = $slide
                    $vmr.strip[$index].eqgain3 | Should -Be $slide
                }
            }
        }

        Context 'Bus, one physical one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
            It "Should set Bus[$index].Gain" {
                $vmr.bus[$index].gain = $gain
                $vmr.bus[$index].gain | Should -Be $gain
            }

            Context 'EQ' -Skip:$ifBasic -ForEach @(
                @{ Eq = $vmr.bus[$index].eq }
            ) {
                Context "Channel[$bus_ch]" {
                    It "Should set Bus[$index].EQ.Channel[$bus_ch].Trim" {
                        $eq.channel[$bus_ch].trim = $slide
                        $eq.channel[$bus_ch].trim | Should -Be $slide
                    }

                    It "Should set Bus[$index].EQ.Channel[$bus_ch].Delay" {
                        $eq.channel[$bus_ch].delay = $msHz
                        $eq.channel[$bus_ch].delay | Should -Be $msHz
                    }
                    
                    Context "Cell[$cells]" {
                        It "Should set Bus[$index].EQ.Channel[$bus_ch].Cell[$cells].F" {
                            $eq.channel[$bus_ch].cell[$cells].f = $msHz
                            $eq.channel[$bus_ch].cell[$cells].f | Should -Be $msHz
                        }

                        It "Should set Bus[$index].EQ.Channel[$bus_ch].Cell[$cells].Gain" {
                            $eq.channel[$bus_ch].cell[$cells].gain = $slide
                            $eq.channel[$bus_ch].cell[$cells].gain | Should -Be $slide
                        }

                        It "Should set Bus[$index].EQ.Channel[$bus_ch].Cell[$cells].Q" {
                            $eq.channel[$bus_ch].cell[$cells].q = $knob
                            $eq.channel[$bus_ch].cell[$cells].q | Should -Be $knob
                        }
                    }
                }
            }
        }
        
        Context 'Option' {
            It "Should set and get Option.delay[$phys_out]" {
                $vmr.option.delay[$phys_out].set($msHz)
                $vmr.command.restart()
                Start-Sleep -Milliseconds 2000
                $vmr.option.delay[$phys_out].get() | Should -Be $msHz
            }
        }
    }

    Describe 'Int Tests' -Tag 'int' {
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

        Context 'Strip, second virtual' -Skip:$ifBasic -ForEach @(
            @{ Index = $phys_in + 2 }
        ) {
            It "Should set Strip[$index].K via alias 'Karaoke'" -ForEach @(
                @{ Value = 0; Expected = 0 }
                @{ Value = 2; Expected = 2 }
                @{ Value = 4; Expected = 4 }
            ) { 
                $vmr.strip[$index].karaoke = $value
                $vmr.strip[$index].k | Should -Be $expected
            }
        }

        Context 'Bus, one physical one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
            It "Should set and get Bus[$index].Mono" -ForEach @(
                @{ Value = 0; Expected = 0 }
                @{ Value = 1; Expected = 1 }
                @{ Value = 2; Expected = 2 }
            ) {
                $vmr.bus[$index].mono = $value
                $vmr.bus[$index].mono | Should -Be $expected
            }
            
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
                $vmr.command.restart()
                Start-Sleep -Milliseconds 2000
                $vmr.vban.port | Should -Be $expected
            }
            
            Context 'Instream, audio, midi, text' -ForEach @(
                @{ Index = $vban_inA }
                @{ Index = $vban_inM }
                @{ Index = $vban_inT }
            ) {
                It "Should set vban.instream[$index].port" -ForEach @(
                    @{ Value = 1024; Expected = 1024 }
                    @{ Value = 65535; Expected = 65535 }
                ) {
                    $vmr.vban.instream[$index].port = $value
                    $vmr.command.restart()
                    Start-Sleep -Milliseconds 2000
                    $vmr.vban.instream[$index].port | Should -Be $expected
                }
            }

            Context 'Instream, audio only' -ForEach @(
                @{ Index = $vban_inA }
            ) {

                It "Should get vban.instream[$index].sr" {
                    $vmr.vban.instream[$index].sr | Should -BeOfType [int]
                }

                It "Should get vban.instream[$index].channel" {
                    $vmr.vban.instream[$index].channel | Should -BeOfType [int]
                }

                It "Should get vban.instream[$index].bit" {
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
            
            Context 'Outstream, audio, midi, video' -ForEach @(
                @{ Index = $vban_outA }
                @{ Index = $vban_outM }
                @{ Index = $vban_outV }
            ) {
                It "Should set vban.outstream[$index].port" -ForEach @(
                    @{ Value = 1024; Expected = 1024 }
                    @{ Value = 65535; Expected = 65535 }
                ) {
                    $vmr.vban.outstream[$index].port = $value
                    $vmr.command.restart()
                    Start-Sleep -Milliseconds 2000
                    $vmr.vban.outstream[$index].port | Should -Be $expected
                }
            }

            Context 'Outstream, audio only' -ForEach @(
                @{ Index = $vban_outA }
            ) {
                
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

            Context 'Outstream, midi only' -ForEach @(
                @{ Index = $vban_outM }
            ) {
                It "Should set vban.outstream[$index].route" -ForEach @(
                    @{ Value = 7; Expected = 7 }
                    @{ Value = 3; Expected = 3 }
                ) {
                    $vmr.vban.outstream[$index].route = $value
                    $vmr.vban.outstream[$index].route | Should -Be $expected
                }
            }

            Context 'Outstream, video only' -ForEach @(
                @{ Index = $vban_outV }
            ) {
                It "Should set vban.outstream[$index].vfps" -ForEach @(
                    @{ Value = 6; Expected = 6 }
                    @{ Value = 24; Expected = 24 }
                ) {
                    $vmr.vban.outstream[$index].vfps = $value
                    $vmr.vban.outstream[$index].vfps | Should -Be $expected
                }

                It "Should set vban.outstream[$index].vquality" -ForEach @(
                    @{ Value = 80; Expected = 80 }
                    @{ Value = 100; Expected = 100 }
                ) {
                    $vmr.vban.outstream[$index].vquality = $value
                    $vmr.vban.outstream[$index].vquality | Should -Be $expected
                }

                It "Should set vban.outstream[$index].route" -ForEach @(
                    @{ Value = 1; Expected = 1 }
                    @{ Value = 4; Expected = 4 }
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

            It 'Should set and get Option.MonitoringBus' -Skip:$ifNotPotato -ForEach @(
                @{ Value = $phys_out }, @{ Value = $virt_out }
            ) {
                $vmr.option.monitoringbus = $value
                $vmr.option.monitoringbus | Should -Be $value
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

        Context 'Recorder' -Skip:$ifBasic {
            It 'Should set and get Recorder.armedbus' -ForEach @(
                @{ Value = $phys_out }, @{ Value = $virt_out }
            ) {
                $vmr.recorder.armedbus = $value
                $vmr.recorder.armedbus | Should -Be $value
            }

            It 'Should set and get Recorder.prerectime' -ForEach @(
                @{ Value = 5 }, @{ Value = 20 }
            ) {
                $vmr.recorder.prerectime = $value
                $vmr.recorder.prerectime | Should -Be $value
            }

            It 'Should set and get Recorder.samplerate' -ForEach @(
                @{ Value = 44100 }, @{ Value = 48000 }
            ) {
                $vmr.recorder.samplerate = $value
                $vmr.recorder.samplerate | Should -Be $value
            }

            It 'Should set and get Recorder.bitresolution' -ForEach @(
                @{ Value = 24 }, @{ Value = 16 }
            ) {
                $vmr.recorder.bitresolution = $value
                $vmr.recorder.bitresolution | Should -Be $value
            }

            It 'Should set and get Recorder.kbps' -ForEach @(
                @{ Value = 96 }, @{ Value = 192 }
            ) {
                $vmr.recorder.kbps = $value
                $vmr.recorder.kbps | Should -Be $value
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

            It "Should set Bus[$index].Mode" -Skip:$ifBasic -ForEach @(
                @{ Value = 'bmix'; Expected = 'bmix' }
                @{ Value = 'upmix41'; Expected = 'upmix41' }
                @{ Value = 'rearonly'; Expected = 'rearonly' }
            ) {
                $vmr.bus[$index].mode.Set($value)
                $vmr.bus[$index].mode.Get() | Should -Be $expected
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
            Context 'Instream, audio, midi, text' -ForEach @(
                @{ Index = $vban_inA }
                @{ Index = $vban_inM }
                @{ Index = $vban_inT }
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

            Context 'Outstream, audio, midi, video' -ForEach @(
                @{ Index = $vban_outA }
                @{ Index = $vban_outM }
                @{ Index = $vban_outV }
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

            Context 'Outstream, video only' -ForEach @(
                @{ Index = $vban_outV }
            ) {
                It "Should set vban.outstream[$index].vformat" -ForEach @(
                    @{ Value = 'png'; Expected = 'png' }
                    @{ Value = 'jpg'; Expected = 'jpg' }
                ) {
                    $vmr.vban.outstream[$index].vformat = $value
                    $vmr.vban.outstream[$index].vformat | Should -Be $expected
                }
            }
        }

        Context 'Recorder' -Skip:$ifBasic {
            It 'Should record a test file, eject, and load it back' -Skip:$ifCustomDir {
                try {
                    $prefix = 'stringtest'
                    $filetype = 'wav'
                    $vmr.recorder.prefix = $prefix
                    $vmr.recorder.filetype = $filetype

                    $vmr.recorder.state = 'record'
                    Start-Sleep -Milliseconds 10
                    $stamp = '{0:yyyy-MM-dd} at {0:HH}h{0:mm}m{0:ss}s' -f (Get-Date)
                    $vmr.recorder.state | Should -Be 'record'
                    Start-Sleep -Milliseconds 2000

                    $tmp = [System.IO.Path]::Combine($recDir, ("{0} {1}.{2}" -f $prefix, $stamp, $filetype))

                    $vmr.recorder.state = 'stop'
                    $vmr.recorder.eject()
                    Start-Sleep -Milliseconds 500

                    $vmr.recorder.state = 'play'
                    $vmr.recorder.state | Should -Be 'stop'  # because no file is loaded

                    $vmr.recorder.load($tmp)
                    Start-Sleep -Milliseconds 500
                    if (-not $vmr.recorder.mode.playonload) {
                        $vmr.recorder.state = 'play'
                    }
                    $vmr.recorder.state | Should -Be 'play'
                }
                finally {
                    $vmr.recorder.state = 'stop'
                    $vmr.recorder.eject()
                    Start-Sleep -Milliseconds 500
                    
                    if (Test-Path $tmp) {
                        Remove-Item -Path $tmp -Force
                    }
                    else {
                        throw "Recording file $tmp was not found."
                    }
                }
            }
        }

        Context 'Command' {
            It 'Should save, reset, then load config' -ForEach @(
                @{ Gain = -27.1; Mode = 'composite'; Bit = 24; Port = 1044 }
            ) {
                $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "vmrconfig-$(New-Guid).xml")
                try {
                    # set some values
                    $vmr.strip[$virt_in].gain = $gain
                    $vmr.bus[$phys_out].mode.set($mode)
                    $vmr.vban.outstream[$vban_outA].bit = $bit
                    $vmr.vban.port = $port

                    # save config
                    $vmr.command.save($tmp)
                    Start-Sleep -Milliseconds 100
                    Test-Path $tmp | Should -BeTrue

                    # reset config
                    $vmr.command.reset()
                    Start-Sleep -Milliseconds 500

                    # verify default values
                    $vmr.strip[$virt_in].gain | Should -Be 0.0
                    $vmr.bus[$phys_out].mode.get() | Should -Be 'normal'
                    $vmr.vban.outstream[$vban_outA].bit | Should -Be 16
                    $vmr.vban.port | Should -Be 6980

                    # load config
                    $vmr.command.load($tmp)
                    Start-Sleep -Milliseconds 500

                    # verify values
                    $vmr.strip[$virt_in].gain | Should -Be $gain
                    $vmr.bus[$phys_out].mode.get() | Should -Be $mode
                    $vmr.vban.outstream[$vban_outA].bit | Should -Be $bit
                    $vmr.vban.port | Should -Be $port
                }
                finally {
                    if (Test-Path $tmp) {
                        Remove-Item $tmp -Force
                    }
                }
            }
        }
    }

    Describe 'Action Tests' -Tag 'action' {
        Context 'Recorder' -Skip:$ifBasic {
            Context 'Recording/Playback' -Skip:$ifCustomDir {
                BeforeAll {
                    $prefix = 'actiontest'
                    $filetype = 'wav'
                    $vmr.recorder.prefix = $prefix
                    $vmr.recorder.filetype = $filetype
                }

                BeforeEach {
                    $vmr.recorder.record()
                    Start-Sleep -Milliseconds 10
                    $stamp = '{0:yyyy-MM-dd} at {0:HH}h{0:mm}m{0:ss}s' -f (Get-Date)
                    Start-Sleep -Milliseconds 2000

                    $tmp = [System.IO.Path]::Combine($recDir, ("{0} {1}.{2}" -f $prefix, $stamp, $filetype))

                    $vmr.recorder.pause()
                    Start-Sleep -Milliseconds 500
                }

                AfterEach {
                    $vmr.recorder.stop()
                    $vmr.recorder.eject()
                    Start-Sleep -Milliseconds 500
                    
                    if (Test-Path $tmp) {
                        Remove-Item -Path $tmp -Force
                    }
                    else {
                        throw "Recording file $tmp was not found."
                    }
                }
            
                It 'Should call Recorder.record()' {
                    $vmr.recorder.record()
                    $vmr.recorder.state | Should -Be 'record'
                }

                It 'Should call Recorder.pause()' {
                    $vmr.recorder.record()
                    Start-Sleep -Milliseconds 500
                    $vmr.recorder.pause()
                    $vmr.recorder.state | Should -Be 'pause'
                }

                It 'Should call Recorder.play()' {
                    $vmr.recorder.stop()
                    Start-Sleep -Milliseconds 500
                    $vmr.recorder.play()
                    $vmr.recorder.state | Should -Be 'play'
                }
            }
        }

        Context 'Command' {
            Context 'Preset Scene' -ForEach @(
                @{ Index = 0; Name = 'Test Scene 1' }
                @{ Index = 63; Name = 'Test Scene 64' }
            ) {
                It "Should store preset at index '$index' with name '$name'" -ForEach @(
                    @{ Value = -15.5 }, @{ Value = -52.9 }
                ) {
                    $vmr.bus[$phys_out].gain = $value
                    $vmr.command.storepreset($index, $name)

                    $vmr.bus[$phys_out].gain = 0.0

                    $vmr.command.recallpreset($name)
                    Start-Sleep -Milliseconds 500
                    $vmr.bus[$phys_out].gain | Should -Be $value
                }

                It "Should update preset at index '$index'" -ForEach @(
                    @{ Value = $false }, @{ Value = $true }
                ) {
                    $vmr.strip[$virt_in].B1 = $value
                    $vmr.command.storepreset($index)

                    $vmr.strip[$virt_in].B1 = -not $value

                    $vmr.command.recallpreset($index)
                    Start-Sleep -Milliseconds 500
                    $vmr.strip[$virt_in].B1 | Should -Be $value
                }

                It "Should update preset with name '$name'" -ForEach @(
                    @{ Value = 2 }, @{ Value = 1 }
                ) {
                    $vmr.bus[$virt_out].mono = $value
                    $vmr.command.storepreset($name)

                    $vmr.bus[$virt_out].mono = 0

                    $vmr.command.recallpreset($name)
                    Start-Sleep -Milliseconds 500
                    $vmr.bus[$virt_out].mono | Should -Be $value
                }

                It "Should update last recalled preset ($index`: $(($index + 1).ToString('00')) - $name)" -ForEach @(
                    @{ Value = 0.8 }, @{ Value = 0.3 }
                ) {
                    $vmr.strip[$phys_in].color_y = $value
                    $vmr.command.storepreset()

                    $vmr.strip[$phys_in].color_y = 0.0
                    
                    $vmr.command.recallpreset()
                    Start-Sleep -Milliseconds 500
                    $vmr.strip[$phys_in].color_y | Should -Be $value
                }
            }
        }
    }
}
