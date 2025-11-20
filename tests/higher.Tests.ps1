Describe -Tag 'higher', -TestName 'All Higher Tests' {
    Describe 'Bool Tests' -ForEach @(
        @{ Value = $true }, @{ Value = $false }
    ) {
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ) {
            It "Should set and get Strip[$index].mute" {
                $vmr.strip[$index].mute = $value
                $vmr.strip[$index].mute | Should -Be $value
            }
            
            It "Should set and get Strip[$index].solo" {
                $vmr.strip[$index].solo = $value
                $vmr.strip[$index].solo | Should -Be $value
            }
            
            It "Should set and get Strip[$index].A1" {
                $vmr.strip[$index].A1 = $value
                $vmr.strip[$index].A1 | Should -Be $value
            }
            
            It "Should set and get Strip[$index].B1" {
                $vmr.strip[$index].B1 = $value
                $vmr.strip[$index].B1 | Should -Be $value
            }
            
            It "Should set and get Strip[$index].postreverb" -Skip:$ifNotPotato {
                $vmr.strip[$index].postreverb = $value
                $vmr.strip[$index].postreverb | Should -Be $value
            }
            
            It "Should set and get Strip[$index].postdelay" -Skip:$ifNotPotato {
                $vmr.strip[$index].postdelay = $value
                $vmr.strip[$index].postdelay | Should -Be $value
            }
            
            It "Should set and get Strip[$index].postfx1" -Skip:$ifNotPotato {
                $vmr.strip[$index].postfx1 = $value
                $vmr.strip[$index].postfx1 | Should -Be $value
            }
            
            It "Should set and get Strip[$index].postfx2" -Skip:$ifNotPotato {
                $vmr.strip[$index].postfx2 = $value
                $vmr.strip[$index].postfx2 | Should -Be $value
            }
        }
            
        Context 'Strip, physical only' {
            BeforeAll { $index = $phys_in }
            
            It "Should set and get Strip[$index].mono" {
                $vmr.strip[$index].mono = $value
                $vmr.strip[$index].mono | Should -Be $value
            }
            
            It "Should set and get Strip[$index].comp.makeup" -Skip:$ifNotPotato {
                $vmr.strip[$index].comp.makeup = $value
                $vmr.strip[$index].comp.makeup | Should -Be $value
            }
            
            It "Should set and get Strip[$index].pitch.on" -Skip:$ifNotPotato {
                $vmr.strip[$index].pitch.on = $value
                $vmr.strip[$index].pitch.on | Should -Be $value
            }
        }
        
        Context 'Strip, first virtual' {
            BeforeAll { $index = $phys_in + 1 }
            
            It "Should set and get Strip[$index].MC via .Mono alias" {
                $vmr.strip[$index].mc   = -not $value
                $vmr.strip[$index].mono = $value
                
                $vmr.strip[$index].mc   | Should -Be $value
                $vmr.strip[$index].mono | Should -Be $value
            }
        }

        Context 'Bus, one physical one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
            It "Should set and get Bus[$index].mute" {
                $vmr.bus[$index].mute = $value
                $vmr.bus[$index].mute | Should -Be $value
            }
            
            It "Should set and get Bus[$index].sel" -Skip:$ifNotPotato {
                $vmr.bus[$index].sel = $value
                $vmr.bus[$index].sel | Should -Be $value
            }
            
            It "Should set and get Bus[$index].monitor" -Skip:$ifNotPotato {
                $vmr.bus[$index].monitor = $value
                $vmr.bus[$index].monitor | Should -Be $value
            }

            It "Should set and get Bus[$index].mode.normal" {
                $vmr.bus[$index].mode.normal = $value
                $vmr.bus[$index].mode.normal | Should -Be $value
            }

            It "Should set and get Bus[$index].mode.amix" {
                $vmr.bus[$index].mode.amix = $value
                $vmr.bus[$index].mode.amix | Should -Be $value
            }

            It "Should set and get Bus[$index].mode.repeat" {
                $vmr.bus[$index].mode.repeat = $value
                $vmr.bus[$index].mode.repeat | Should -Be $value
            }

            It "Should set and get Bus[$index].mode.composite" {
                $vmr.bus[$index].mode.composite = $value
                $vmr.bus[$index].mode.composite | Should -Be $value
            }
            
            It "Should set and get Bus[$index].mode.bmix" -Skip:$ifBasic {
                $vmr.bus[$index].mode.bmix = $value
                $vmr.bus[$index].mode.bmix | Should -Be $value
            }
            
            It "Should set and get Bus[$index].mode.tvmix" -Skip:$ifBasic {
                $vmr.bus[$index].mode.tvmix = $value
                $vmr.bus[$index].mode.tvmix | Should -Be $value
            }
            
            It "Should set and get Bus[$index].mode.upmix21" -Skip:$ifBasic {
                $vmr.bus[$index].mode.upmix21 = $value
                $vmr.bus[$index].mode.upmix21 | Should -Be $value
            }
            
            It "Should set and get Bus[$index].mode.upmix41" -Skip:$ifBasic {
                $vmr.bus[$index].mode.upmix41 = $value
                $vmr.bus[$index].mode.upmix41 | Should -Be $value
            }
            
            It "Should set and get Bus[$index].mode.upmix61" -Skip:$ifBasic {
                $vmr.bus[$index].mode.upmix61 = $value
                $vmr.bus[$index].mode.upmix61 | Should -Be $value
            }
            
            It "Should set and get Bus[$index].mode.centeronly" -Skip:$ifBasic {
                $vmr.bus[$index].mode.centeronly = $value
                $vmr.bus[$index].mode.centeronly | Should -Be $value
            }
            
            It "Should set and get Bus[$index].mode.lfeonly" -Skip:$ifBasic {
                $vmr.bus[$index].mode.lfeonly = $value
                $vmr.bus[$index].mode.lfeonly | Should -Be $value
            }
            
            It "Should set and get Bus[$index].mode.rearonly" -Skip:$ifBasic {
                $vmr.bus[$index].mode.rearonly = $value
                $vmr.bus[$index].mode.rearonly | Should -Be $value
            }
        }
        
        Context 'Physical bus physical strip' -ForEach @(
            @{ Target = $vmr.bus[$phys_out]; Label = "Bus[$phys_out]" }
            @{ Target = $vmr.strip[$phys_in]; Label = "Strip[$phys_in]" }
        ) {
            It "Should set and get $Label.vaio" {
                $Target.vaio = $value
                $Target.vaio | Should -Be $value
            }
        }
        
        Context 'FX' -Skip:$ifNotPotato {
            It 'Should set and get FX.reverb.on' {
                $vmr.fx.reverb.on = $value
                $vmr.fx.reverb.on | Should -Be $value
            }
            
            It 'Should set and get FX.reverb.ab' {
                $vmr.fx.reverb.ab = $value
                $vmr.fx.reverb.ab | Should -Be $value
            }
            
            It 'Should set and get FX.delay.on' {
                $vmr.fx.delay.on = $value
                $vmr.fx.delay.on | Should -Be $value
            }
            
            It 'Should set and get FX.delay.ab' {
                $vmr.fx.delay.ab = $value
                $vmr.fx.delay.ab | Should -Be $value
            }
        }
        
        Context 'Patch' {
            It 'Should set and get Patch.insert[$insert]' -Skip:$ifBasic {
                $vmr.patch.insert[$insert] = $value
                $vmr.patch.insert[$insert] | Should -Be $value
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
            It 'Should set and get Option.asiosr' {
                $vmr.option.asiosr = $value
                $vmr.option.asiosr | Should -Be $value
            }
            
            It 'Should set and get Option.monitoronsel' -Skip:$ifNotPotato {
                $vmr.option.monitoronsel = $value
                $vmr.option.monitoronsel | Should -Be $value
            }
            
            It 'Should set and get Option.slidermode' -Skip:$ifNotPotato {
                $vmr.option.slidermode = $value
                $vmr.option.slidermode | Should -Be $value
            }
        }
        
        Context 'Recorder' -Skip:$ifBasic {
            It 'Should set and get Recorder.A3' {
                $vmr.recorder.A3 = $value
                $vmr.recorder.A3 | Should -Be $value
            }
            
            It 'Should set and get Recorder.B2' {
                $vmr.recorder.B2 = $value
                $vmr.recorder.B2 | Should -Be $value
            }
            
            It 'Should set and get Recorder.mode.recbus' {
                $vmr.recorder.mode.recbus = $value
                $vmr.recorder.mode.recbus | Should -Be $value
            }
            
            It 'Should set and get Recorder.mode.playonload' {
                $vmr.recorder.mode.playonload = $value
                $vmr.recorder.mode.playonload | Should -Be $value
            }
            
            It 'Should set and get Recorder.mode.loop' {
                $vmr.recorder.mode.loop = $value
                $vmr.recorder.mode.loop | Should -Be $value
            }
            
            It 'Should set and get Recorder.mode.multitrack' {
                $vmr.recorder.mode.multitrack = $value
                $vmr.recorder.mode.multitrack | Should -Be $value
            }
        }

        Context 'Macrobutton' -ForEach @(
            @{ Index = 0 }, @{ Index = 79 }
        ) {
            It "Should set and get Button[$index].state" {
                $vmr.button[$index].state = $value
                $vmr.button[$index].state | Should -Be $value
            }
            
            It "Should set and get Button[$index].stateonly" {
                $vmr.button[$index].stateonly = $value
                $vmr.button[$index].stateonly | Should -Be $value
            }
            
            It "Should set and get Button[$index].trigger" {
                $vmr.button[$index].trigger = $value
                $vmr.button[$index].trigger | Should -Be $value
            }
        }
    }

    Describe 'Int Tests' {
        Context 'Strip, physical only' {
            BeforeAll { $index = $phys_in }
            
            It "Should set and get Strip[$index].gate.bpsidechain" -Skip:$ifNotPotato {
                $vmr.strip[$index].gate.bpsidechain = 2500
                $vmr.strip[$index].gate.bpsidechain | Should -Be 2500
            }
            
            It "Should set and get Strip[$index].pitch.drywet" -Skip:$ifNotPotato {
                $vmr.strip[$index].pitch.drywet = -32
                $vmr.strip[$index].pitch.drywet | Should -Be -32
            }
        }
        
        Context 'Strip, second virtual' -Skip:$ifBasic {
            BeforeAll { $index = $phys_in + 2 }
            
            It "Should set and get Strip[$index].k via .karaoke alias" {
                $vmr.strip[$index].k       = 0
                $vmr.strip[$index].karaoke = 4
                
                $vmr.strip[$index].k       | Should -Be 4
                $vmr.strip[$index].karaoke | Should -Be 4
            }
        }
        
        Context 'Bus, one physical one virtual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
            It "Should set and get Bus[$index].mono" {
                $vmr.bus[$index].mono = 2
                $vmr.bus[$index].mono | Should -Be 2
            }
        }
        
        Context 'Patch' {
            It 'Should set and get Patch.composite[$composite]' -Skip:$ifBasic -ForEach @(
                @{ Value = 22 }, @{ Value = 6 }
            ) {
                $vmr.patch.composite[$composite] = $value
                $vmr.patch.composite[$composite] | Should -Be $value
            }
        }
        
        Context 'Option' {
            It 'Should set and get Option.sr' -ForEach @(
                @{ Value = 44100 }, @{ Value = 48000 }
            ) {
                $vmr.option.sr = $value
                $vmr.option.sr | Should -Be $value
            }
            
            Context 'Option.buffer' -ForEach @(
                @{ Value = 1024 }, @{ Value = 512 }
            ) {
                It 'Should set and get mme buffer' {
                    $vmr.option.buffer.mme = $value
                    $vmr.option.buffer.mme | Should -Be $value
                }
                
                It 'Should set and get wdm buffer' {
                    $vmr.option.buffer.wdm = $value
                    $vmr.option.buffer.wdm | Should -Be $value
                }
                
                It 'Should set and get ks buffer' {
                    $vmr.option.buffer.ks = $value
                    $vmr.option.buffer.ks | Should -Be $value
                }
                
                It 'Should set and get asio buffer' {
                    $vmr.option.buffer.asio = $value
                    $vmr.option.buffer.asio | Should -Be $value
                }
            }
        }
        
        Context 'Recorder' -Skip:$ifBasic {
            It 'Should set and get Recorder integers' -ForEach @(
                @{ Value = 32000 }, @{ Value = 44100 }
            ) {
                $vmr.recorder.samplerate = $value
                $vmr.recorder.samplerate | Should -Be $value
            }
            
            It 'Should set and get Recorder.bitresolution' -ForEach @(
                @{ Value = 16 }, @{ Value = 24 }
            ) {
                $vmr.recorder.bitresolution = $value
                $vmr.recorder.bitresolution | Should -Be $value
            }
            
            It 'Should set and get Recorder.channel' -ForEach @(
                @{ Value = 1 }, @{ Value = 2 }
            ) {
                $vmr.recorder.channel = $value
                $vmr.recorder.channel | Should -Be $value
            }
            
            It 'Should set and get Recorder.kbps' -ForEach @(
                @{ Value = 96 }, @{ Value = 192 }
            ) {
                $vmr.recorder.kbps = $value
                $vmr.recorder.kbps | Should -Be $value
            }
        }
        
        Context 'Macrobutton' -ForEach @(
            @{ Index = 0 }, @{ Index = 79 }
        ) {
            It "Should set Button[$index].color" -ForEach (0..8) {
                param($color)
                $vmr.button[$index].color = $color
                Start-Sleep -Milliseconds 50
            }
        }
    }

    Describe 'Float Tests' -ForEach @( # knob: 1 to 8 / 0 to 10, slide: -12 to 12 / -24 to 24
        @{ Gain = -24.3; TwoD_x = -0.2; TwoD_y = 0.8; Knob = 6.4; Slide = -7.5; Ms = 196.8 }
        @{ Gain = -12.6; TwoD_x = 0.4; TwoD_y = 0.1; Knob = 3.7; Slide = 5.9; Ms = 32.6 }
    ) {
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ) {
            It "Should set and get Strip[$index].gain" {
                $vmr.strip[$index].gain = $gain
                $vmr.strip[$index].gain | Should -Be $gain
            }
            
            It "Should set and get Strip[$index].pan_x" {
                $vmr.strip[$index].pan_x = $twoD_x
                $vmr.strip[$index].pan_x | Should -Be $twoD_x
            }
            
            It "Should set and get Strip[$index].pan_y" {
                $vmr.strip[$index].pan_y = $twoD_y
                $vmr.strip[$index].pan_y | Should -Be $twoD_y
            }
            
            It "Should set and get Strip[$index].limit" -Skip:$ifBasic {
                $vmr.strip[$index].limit = $gain
                $vmr.strip[$index].limit | Should -Be $gain
            }
            
            It "Should set and get Strip[$index].gainlayer[$layer]" -Skip:$ifNotPotato -ForEach @(
                @{ Layer = 0 }, @{ Layer = 8 }
            ) {
                $vmr.strip[$index].gainlayer[$layer] = $gain
                $vmr.strip[$index].gainlayer[$layer] | Should -Be $gain
            }
        }
        
        Context 'Strip, physical only' {
            BeforeAll { $index = $phys_in }
            
            It "Should set and get Strip[$index].color_x" {
                $vmr.strip[$index].color_x = $twoD_x
                $vmr.strip[$index].color_x | Should -Be $twoD_x
            }
            
            It "Should set and get Strip[$index].color_y" {
                $vmr.strip[$index].color_y = $twoD_y
                $vmr.strip[$index].color_y | Should -Be $twoD_y
            }
            
            It "Should set and get Strip[$index].fx_x" -Skip:$ifBasic {
                $vmr.strip[$index].fx_x = $twoD_x
                $vmr.strip[$index].fx_x | Should -Be $twoD_x
            }
            
            It "Should set and get Strip[$index].fx_y" -Skip:$ifBasic {
                $vmr.strip[$index].fx_y = $twoD_y
                $vmr.strip[$index].fx_y | Should -Be $twoD_y
            }
            
            It "Should set and get Strip[$index].audibility" -Skip:$ifNotBasic {
                $vmr.strip[$index].audibility = $knob
                $vmr.strip[$index].audibility | Should -Be $knob
            }
            
            It "Should set and get Strip[$index].reverb" -Skip:$ifNotPotato {
                $vmr.strip[$index].reverb = $knob
                $vmr.strip[$index].reverb | Should -Be $knob
            }
            
            It "Should set and get Strip[$index].delay" -Skip:$ifNotPotato {
                $vmr.strip[$index].delay = $knob
                $vmr.strip[$index].delay | Should -Be $knob
            }
            
            It "Should set and get Strip[$index].fx1" -Skip:$ifNotPotato {
                $vmr.strip[$index].fx1 = $knob
                $vmr.strip[$index].fx1 | Should -Be $knob
            }
            
            It "Should set and get Strip[$index].fx2" -Skip:$ifNotPotato {
                $vmr.strip[$index].fx2 = $knob
                $vmr.strip[$index].fx2 | Should -Be $knob
            }
            
            Context "Strip[$index].Comp" -Skip:$ifBasic {
                It "Should set and get Strip[$index].comp.knob" {
                    $vmr.strip[$index].comp.knob = $knob
                    $vmr.strip[$index].comp.knob | Should -Be $knob
                }
                
                It "Should set and get Strip[$index].comp.gainin" -Skip:$ifNotPotato {
                    $vmr.strip[$index].comp.gainin = $slide
                    $vmr.strip[$index].comp.gainin | Should -Be $slide
                }
                
                It "Should set and get Strip[$index].comp.ratio" -Skip:$ifNotPotato {
                    $vmr.strip[$index].comp.ratio = $knob
                    $vmr.strip[$index].comp.ratio | Should -Be $knob
                }
                
                It "Should set and get Strip[$index].comp.threshold" -Skip:$ifNotPotato {
                    $vmr.strip[$index].comp.threshold = $gain
                    $vmr.strip[$index].comp.threshold | Should -Be $gain
                }
                
                It "Should set and get Strip[$index].comp.attack" -Skip:$ifNotPotato {
                    $vmr.strip[$index].comp.attack = $ms
                    $vmr.strip[$index].comp.attack | Should -Be $ms
                }
                
                It "Should set and get Strip[$index].comp.release" -Skip:$ifNotPotato {
                    $vmr.strip[$index].comp.release = $ms
                    $vmr.strip[$index].comp.release | Should -Be $ms
                }
                
                It "Should set and get Strip[$index].comp.knee" -Skip:$ifNotPotato {
                    $vmr.strip[$index].comp.knee = $twoD_y
                    $vmr.strip[$index].comp.knee | Should -Be $twoD_y
                }
                
                It "Should set and get Strip[$index].comp.gainout" -Skip:$ifNotPotato {
                    $vmr.strip[$index].comp.gainout = $slide
                    $vmr.strip[$index].comp.gainout | Should -Be $slide
                }
            }
            
            Context "Strip[$index].Gate" -Skip:$ifBasic {
                It "Should set and get Strip[$index].gate.knob" {
                    $vmr.strip[$index].gate.knob = $knob
                    $vmr.strip[$index].gate.knob | Should -Be $knob
                }
                
                It "Should set and get Strip[$index].gate.threshold" -Skip:$ifNotPotato {
                    $vmr.strip[$index].gate.threshold = $gain
                    $vmr.strip[$index].gate.threshold | Should -Be $gain
                }
                
                It "Should set and get Strip[$index].gate.damping" -Skip:$ifNotPotato {
                    $vmr.strip[$index].gate.damping = $gain
                    $vmr.strip[$index].gate.damping | Should -Be $gain
                }
                
                It "Should set and get Strip[$index].gate.attack" -Skip:$ifNotPotato {
                    $vmr.strip[$index].gate.attack = $ms
                    $vmr.strip[$index].gate.attack | Should -Be $ms
                }
                
                It "Should set and get Strip[$index].gate.hold" -Skip:$ifNotPotato {
                    $vmr.strip[$index].gate.hold = $ms
                    $vmr.strip[$index].gate.hold | Should -Be $ms
                }
                
                It "Should set and get Strip[$index].gate.release" -Skip:$ifNotPotato {
                    $vmr.strip[$index].gate.release = $ms
                    $vmr.strip[$index].gate.release | Should -Be $ms
                }
            }
            
            Context "Strip[$index].Denoiser" -Skip:$ifNotPotato {
                It "Should set and get Strip[$index].denoiser.knob" {
                    $vmr.strip[$index].denoiser.knob = $knob
                    $vmr.strip[$index].denoiser.knob | Should -Be $knob
                }
                
                It "Should set and get Strip[$index].denoiser.threshold" {
                    $vmr.strip[$index].denoiser.threshold = $knob
                    $vmr.strip[$index].denoiser.threshold | Should -Be $knob
                }
            }
            
            Context "Strip[$index].Pitch" -Skip:$ifNotPotato {
                It "Should set and get Strip[$index].pitch.pitchvalue" {
                    $vmr.strip[$index].pitch.pitchvalue = $slide
                    $vmr.strip[$index].pitch.pitchvalue | Should -Be $slide
                }
                
                It "Should set and get Strip[$index].pitch.loformant" {
                    $vmr.strip[$index].pitch.loformant = $slide
                    $vmr.strip[$index].pitch.loformant | Should -Be $slide
                }
                
                It "Should set and get Strip[$index].pitch.medformant" {
                    $vmr.strip[$index].pitch.medformant = $slide
                    $vmr.strip[$index].pitch.medformant | Should -Be $slide
                }
                
                It "Should set and get Strip[$index].pitch.hiformant" {
                    $vmr.strip[$index].pitch.hiformant = $slide
                    $vmr.strip[$index].pitch.hiformant | Should -Be $slide
                }
            }
        }
        
        Context 'Strip, virtual only' {
            BeforeAll { $index = $virt_in }
            
            It "Should set and get Strip[$index].bass via .low alias" {
                $vmr.strip[$index].bass = 0
                $vmr.strip[$index].low  = $slide
                
                $vmr.strip[$index].bass | Should -Be $slide
                $vmr.strip[$index].low  | Should -Be $slide
            }
            
            It "Should set and get Strip[$index].mid via .med alias" {
                $vmr.strip[$index].mid = 0
                $vmr.strip[$index].med = $slide
                
                $vmr.strip[$index].mid | Should -Be $slide
                $vmr.strip[$index].med | Should -Be $slide
            }
            
            It "Should set and get Strip[$index].treble via .high alias" {
                $vmr.strip[$index].treble = 0
                $vmr.strip[$index].high   = $slide
                
                $vmr.strip[$index].treble | Should -Be $slide
                $vmr.strip[$index].high   | Should -Be $slide
            }
        }
        
        Context 'Bus, one physical one virual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
            It "Should set and get Bus[$index].gain" {
                $vmr.bus[$index].gain = $gain
                $vmr.bus[$index].gain | Should -Be $gain
            }
            
            It "Should set and get Bus[$index].returnreverb" -Skip:$ifNotPotato {
                $vmr.bus[$index].returnreverb = $knob
                $vmr.bus[$index].returnreverb | Should -Be $knob
            }
            
            It "Should set and get Bus[$index].returndelay" -Skip:$ifNotPotato {
                $vmr.bus[$index].returndelay = $knob
                $vmr.bus[$index].returndelay | Should -Be $knob
            }
            
            It "Should set and get Bus[$index].returnfx1" -Skip:$ifNotPotato {
                $vmr.bus[$index].returnfx1 = $knob
                $vmr.bus[$index].returnfx1 | Should -Be $knob
            }
            
            It "Should set and get Bus[$index].returnfx2" -Skip:$ifNotPotato {
                $vmr.bus[$index].returnfx2 = $knob
                $vmr.bus[$index].returnfx2 | Should -Be $knob
            }
        }
        
        Context 'Option' {
            It "Should set and get Option.delay[$phys_out]" {
                $mss = $ms + 0.03   # delay should take and return 2 decimal places
                $vmr.option.delay[$phys_out] = $mss
                $vmr.option.delay[$phys_out] | Should -Be $mss
            }
        }
        
        Context 'Recorder' -Skip:$ifBasic {
            It 'Should set and get Recorder.gain' {
                $vmr.recorder.gain = $gain
                $vmr.recorder.gain | Should -Be $gain
            }
        }
    }

    Describe 'String Tests' {
        Context 'Bus and strip, one physical one virtual' -ForEach @(
            @{ Target = $vmr.bus[$phys_out]; Label = "Bus[$phys_out]" }
            @{ Target = $vmr.bus[$virt_out]; Label = "Bus[$virt_out]" }
            @{ Target = $vmr.strip[$phys_in]; Label = "Strip[$phys_in]" }
            @{ Target = $vmr.strip[$virt_in]; Label = "Strip[$virt_in]" }
        ) {
            It "Should set $Label.Label" -ForEach @(
                @{ Value = 'test0' }, @{ Value = 'test1' }
            ) {
                $target.label = $value
                $target.label | Should -Be $value
            }
        }
    }
    
    Describe 'Fade Tests' {
        Context 'Bus and strip, one physical one virtual' -ForEach @(
            @{ Target = $vmr.bus[$phys_out]; Label = "Bus[$phys_out]" }
            @{ Target = $vmr.bus[$virt_out]; Label = "Bus[$virt_out]" }
            @{ Target = $vmr.strip[$phys_in]; Label = "Strip[$phys_in]" }
            @{ Target = $vmr.strip[$virt_in]; Label = "Strip[$virt_in]" }
        ) {
            It "Should fade $Label gain to dB over ms time" -ForEach @(
                @{ Value = -21.7; Time = 750 }, @{ Value = -60.0; Time = 1250 }
            ) {
                $sleep = $time + 10   # give it a little wiggle room
                
                $target.fadeto($value, $time)
                Start-Sleep -Milliseconds $sleep
                $target.gain | Should -Be $value
            }
            
            It "Should fade $Label gain by dB over ms time" -ForEach @(
                @{ Value = -45.0; Time = 1050 }, @{ Value = 16.9; Time = 300 }
            ) {
                $sleep = $time + 10
                $gain = @($target.gain + $value, -60.0, 12.0)
                
                $target.fadeby($value, $time)
                Start-Sleep -Milliseconds $sleep
                $target.gain | Should -BeIn $gain
            }
        }
    }
    
    Describe 'EQ Tests' {
        Context 'Bus and physical strip EQ' -Skip:$ifBasic -ForEach @(
            @{ Eq = $vmr.bus[$phys_out].eq; Label = "Bus[$phys_out]" }
            @{ Eq = $vmr.bus[$virt_out].eq; Label = "Bus[$virt_out]" }
            @{ Eq = $vmr.strip[$phys_in].eq; Label = "Strip[$phys_in]"; Skip = $ifNotPotato }
        ) {
            Describe 'Bool Tests' -Skip:$Skip -ForEach @(
                @{ Value = $true }, @{ Value = $false }
            ) {
                It "Should set and get $Label.EQ.on" {
                    $Eq.on = $value
                    $Eq.on | Should -Be $value
                }
                
                It "Should set and get $Label.EQ.ab" {
                    $Eq.ab = $value
                    $Eq.ab | Should -Be $value
                }
                
                It "Should set and get $Label.EQ.Channel[0].Cell[0].on" {
                    $Eq.channel[0].cell[0].on = $value
                    $Eq.channel[0].cell[0].on | Should -Be $value
                }
            }
            
            It "Should set and get $Label.EQ.Channel[0].Cell[0].type" -Skip:$Skip -ForEach @(
                @{ Value = 1 }, @{ Value = 4 }
            ) {
                $Eq.channel[0].cell[0].type = $value
                $Eq.channel[0].cell[0].type | Should -Be $value
            }
            
            It "Should set and get $Label.EQ.Channel[0].Cell[0].f" -Skip:$Skip -ForEach @(
                @{ Value = 1098.4 }, @{ Value = 14753.2 }
            ) {
                $Eq.channel[0].cell[0].f = $value
                $Eq.channel[0].cell[0].f | Should -Be $value
            }
            
            It "Should set and get $Label.EQ.Channel[0].Cell[0].gain" -Skip:$Skip -ForEach @(
                @{ Value = 2.5 }, @{ Value = -6.1 }
            ) {
                $Eq.channel[0].cell[0].gain = $value
                $Eq.channel[0].cell[0].gain | Should -Be $value
            }
            
            It "Should set and get $Label.EQ.Channel[0].Cell[0].q" -Skip:$Skip -ForEach @(
                @{ Value = 52.7 }, @{ Value = 3.0 } 
            ) {
                $Eq.channel[0].cell[0].q = $value
                $Eq.channel[0].cell[0].q | Should -Be $value
            }
            
            It "Should save then load EQ on $Label" -Skip:$Skip {
                $tmp = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "vmreq-$(New-Guid).xml")
                try {
                    $Eq.save($tmp)
                    Start-Sleep -Milliseconds 50
                    Test-Path $tmp | Should -BeTrue
                    $Eq.load($tmp)
                    Start-Sleep -Milliseconds 50
                }
                finally {
                    if (Test-Path $tmp) { Remove-Item $tmp -Force }
                }
            }
        }
    }
    
    Describe 'Special Tests' {
        Context 'Recorder' -Skip:$ifBasic {
            It 'Should set Recorder input arming' -ForEach @(
                @{ Value = $true }, @{ Value = $false }
            ) {
                $vmr.recorder.armstrip[$phys_in].set($value)
                $vmr.recorder.armstrip[$virt_in].set($value)
            }
            
            It 'Should set Recorder output arming' {
                $vmr.recorder.armbus[$phys_out].set($true)
                $vmr.recorder.armbus[$virt_out].set($true)
                
                $vmr.recorder.armbus[$virt_out].set($false)
            }
            
            It 'Should record a short audio file, perform navigation tests, then eject' {
                $vmr.recorder.record
                Start-Sleep -Seconds 5
                $vmr.recorder.pause
                
                $vmr.recorder.record
                Start-Sleep -Seconds 5
                $vmr.recorder.stop
                
                $vmr.recorder.play
                Start-Sleep -Seconds 2
                
                $vmr.recorder.replay
                Start-Sleep -Seconds 2
                
                $vmr.recorder.ff
                Start-Sleep -Seconds 2
                $vmr.recorder.stop
                
                $vmr.recorder.goto('00:00:08')
                
                $vmr.recorder.rew
                Start-Sleep -Seconds 2
                $vmr.recorder.stop
                
                $vmr.recorder.eject
                Start-Sleep -Milliseconds 50
            }
        }
    
        Context 'VBAN' {
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
                    @{ Value = $true }, @{ Value = $false }
                ) {
                    $Stream.on = $value
                    $Stream.on | Should -Be $value
                }
                
                It "Should set and get $Label.name" -ForEach @(
                    @{ Value = 'test0' }, @{ Value = 'test1' }
                ) {
                    $Stream.name = $value
                    $Stream.name | Should -Be $value
                }
                
                It "Should set and get $Label.ip" -ForEach @(
                    @{ Value = '0.0.0.0' }, @{ Value = '10.0.0.4' }
                ) {
                    $Stream.ip = $value
                    $Stream.ip | Should -Be $value
                }
                
                It "Should set and get $Label.port" -ForEach @(
                    @{ Value = 65535 }, @{ Value = 5481 }
                ) {
                    $Stream.port = $value
                    $Stream.port | Should -Be $value
                }
                
                It "Should set and get $Label.quality" -ForEach @(
                    @{ Value = 4 }, @{ Value = 0 }
                ) {
                    $Stream.quality = $value
                    $Stream.quality | Should -Be $value
                }
                
                It "Should set and get $Label.route" -ForEach @(
                    @{ Value = 7 }, @{ Value = 0 }
                ) {
                    $Stream.route = $value
                    $Stream.route | Should -Be $value
                }
                
                It "Should set and get $Label.sr" -Skip:$ifIn -ForEach @(
                    @{ Value = 44100 }, @{ Value = 48000 }
                ) {
                    $Stream.sr = $value
                    $Stream.sr | Should -Be $value
                }
                
                It "Should set and get $Label.channel" -Skip:$ifIn -ForEach @(
                    @{ Value = 8 }, @{ Value = 1 }
                ) {
                    $Stream.channel = $value
                    $Stream.channel | Should -Be $value
                }
                
                It "Should set and get $Label.bit" -Skip:$ifIn -ForEach @(
                    @{ Value = 24 }, @{ Value = 16 }
                ) {
                    $Stream.bit = $value
                    $Stream.bit | Should -Be $value
                }
                
                It "Should get $Label.sr" -Skip:$ifOut {
                    $samplerates = @(11025, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000)
                    $Stream.sr | Should -BeIn $samplerates
                }
                
                It "Should get $Label.channel" -Skip:$ifOut {
                    $channels = 1..8
                    $Stream.channel | Should -BeIn $channels
                }
                
                It "Should get $Label.bit" -Skip:$ifOut {
                    $bitdepths = @(16, 24)
                    $Stream.bit | Should -BeIn $bitdepths
                }
            }
        }
    
        Context 'Command' {
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
                    Start-Sleep -Milliseconds 50
                    Test-Path $tmp | Should -BeTrue
                    $vmr.command.reset
                    $vmr.command.load($tmp)
                    Start-Sleep -Milliseconds 50
                }
                finally {
                    if (Test-Path $tmp) { Remove-Item $tmp -Force }
                }
            }
        }
    }
}
