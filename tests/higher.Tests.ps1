Describe -Tag 'higher', -TestName 'All Higher Tests' {
    Describe 'Bool tests' -ForEach @(
        @{ Value = $true }, @{ Value = $false }
    ) {
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ) {
            It "Should set and get Strip[$index] booleans" {
                $vmr.strip[$index].mute = $value
                $vmr.strip[$index].solo = $value
                $vmr.strip[$index].A1   = $value
                $vmr.strip[$index].B1   = $value
                
                $vmr.strip[$index].mute | Should -Be $value
                $vmr.strip[$index].solo | Should -Be $value
                $vmr.strip[$index].A1   | Should -Be $value
                $vmr.strip[$index].B1   | Should -Be $value
            }
            
            It "Should set and get Strip[$index] booleans (potato)" -Skip:$ifNotPotato {
                $vmr.strip[$index].postreverb = $value
                $vmr.strip[$index].postdelay  = $value
                $vmr.strip[$index].postfx1    = $value
                $vmr.strip[$index].postfx2    = $value
                
                $vmr.strip[$index].postreverb | Should -Be $value
                $vmr.strip[$index].postdelay  | Should -Be $value
                $vmr.strip[$index].postfx1    | Should -Be $value
                $vmr.strip[$index].postfx2    | Should -Be $value
            }
        }
            
        Context 'Strip, physical only' {
            BeforeAll { $index = $phys_in }
            
            It "Should set and get Strip[$index] booleans" {
                $vmr.strip[$index].mono = $value
                $vmr.strip[$index].mono | Should -Be $value
            }
            
            It "Should set and get Strip[$index] audibility and pitch booleans" -Skip:$ifNotPotato {
                $vmr.strip[$index].comp.makeup = $value
                $vmr.strip[$index].pitch.on    = $value
                
                $vmr.strip[$index].comp.makeup | Should -Be $value
                $vmr.strip[$index].pitch.on    | Should -Be $value
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
            It "Should set and get Bus[$index] booleans" {
                $vmr.bus[$index].mute = $value
                $vmr.bus[$index].mute | Should -Be $value
            }
            
            It "Should set and get Bus[$index] booleans (potato)" -Skip:$ifNotPotato {
                $vmr.bus[$index].sel     = $value
                $vmr.bus[$index].monitor = $value
                
                $vmr.bus[$index].sel     | Should -Be $value
                $vmr.bus[$index].monitor | Should -Be $value
            }

            It "Should set and get Bus[$index] modes" {
                $vmr.bus[$index].mode.normal = $value
                $vmr.bus[$index].mode.normal | Should -Be $value
                
                $vmr.bus[$index].mode.amix = $value
                $vmr.bus[$index].mode.amix | Should -Be $value
                
                $vmr.bus[$index].mode.repeat = $value
                $vmr.bus[$index].mode.repeat | Should -Be $value
                
                $vmr.bus[$index].mode.composite = $value
                $vmr.bus[$index].mode.composite | Should -Be $value
            }
            
            It "Should set and get Bus[$index] modes (banana+)" -Skip:$ifBasic {
                $vmr.bus[$index].mode.bmix = $value
                $vmr.bus[$index].mode.bmix | Should -Be $value
                
                $vmr.bus[$index].mode.tvmix = $value
                $vmr.bus[$index].mode.tvmix | Should -Be $value
                
                $vmr.bus[$index].mode.upmix21 = $value
                $vmr.bus[$index].mode.upmix21 | Should -Be $value
                
                $vmr.bus[$index].mode.upmix41 = $value
                $vmr.bus[$index].mode.upmix41 | Should -Be $value
                
                $vmr.bus[$index].mode.upmix61 = $value
                $vmr.bus[$index].mode.upmix61 | Should -Be $value
                
                $vmr.bus[$index].mode.centeronly = $value
                $vmr.bus[$index].mode.centeronly | Should -Be $value
                
                $vmr.bus[$index].mode.lfeonly = $value
                $vmr.bus[$index].mode.lfeonly | Should -Be $value
                
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
            It 'Should set and get FX booleans' {
                $vmr.fx.reverb.on = $value
                $vmr.fx.reverb.ab = $value
                $vmr.fx.delay.on  = $value
                $vmr.fx.delay.ab  = $value
                
                $vmr.fx.reverb.on | Should -Be $value
                $vmr.fx.reverb.ab | Should -Be $value
                $vmr.fx.delay.on  | Should -Be $value
                $vmr.fx.delay.ab  | Should -Be $value
            }
        }
        
        Context 'Patch' {
            It 'Should set and get Patch booleans' -Skip:$ifBasic {
                $vmr.patch.insert[$insert]    = $value
                $vmr.patch.postfadercomposite = $value
                $vmr.patch.postfxinsert       = $value
                
                $vmr.patch.insert[$insert]    | Should -Be $value
                $vmr.patch.postfadercomposite | Should -Be $value
                $vmr.patch.postfxinsert       | Should -Be $value
            }
        }
        
        Context 'Option' {
            It 'Should set and get Option booleans' {
                $vmr.option.asiosr = $value
                $vmr.option.asiosr | Should -Be $value
            }
            
            It 'Should set and get Option booleans (potato)' -Skip:$ifNotPotato {
                $vmr.option.monitoronsel = $value
                $vmr.option.slidermode   = $value
                
                $vmr.option.monitoronsel | Should -Be $value
                $vmr.option.slidermode   | Should -Be $value
            }
        }

        Context 'Macrobutton' -ForEach @(
            @{ Index = 0 }, @{ Index = 79 }
        ) {
            It "Should set and get Button[$index] booleans" {
                $vmr.button[$index].state     = $value
                $vmr.button[$index].stateonly = $value
                $vmr.button[$index].trigger   = $value
                
                $vmr.button[$index].state     | Should -Be $value
                $vmr.button[$index].stateonly | Should -Be $value
                $vmr.button[$index].trigger   | Should -Be $value
            }
        }
    }

    Describe 'Int Tests' {
        Context 'Strip, physical only' {
            BeforeAll { $index = $phys_in }
            
            It "Should set and get Strip[$index] audibility and pitch integers" -Skip:$ifNotPotato {
                $vmr.strip[$index].gate.bpsidechain = 2500
                $vmr.strip[$index].pitch.drywet     = -32
                
                $vmr.strip[$index].gate.bpsidechain | Should -Be 2500
                $vmr.strip[$index].pitch.drywet     | Should -Be -32
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
            It "Should set and get Bus[$index] integers" {
                $vmr.bus[$index].mono = 2
                $vmr.bus[$index].mono | Should -Be 2
            }
        }
        
        Context 'Patch' {
            It 'Should set and get Patch integers' -Skip:$ifBasic {
                $vmr.patch.composite[$composite] = 22
                $vmr.patch.composite[$composite] | Should -Be 22
            }
        }
        
        Context 'Option' {
            It 'Should set and get Option integers' {
                $vmr.option.sr = 32000
                $vmr.option.sr | Should -Be 32000
            }
            
            It 'Should set and get buffer sizes' -ForEach @(
                @{ Value = 1024 }, @{ Value = 512 }
            ) {
                $vmr.option.buffer.mme  = $value
                $vmr.option.buffer.wdm  = $value
                $vmr.option.buffer.ks   = $value
                $vmr.option.buffer.asio = $value
                
                $vmr.option.buffer.mme  | Should -Be $value
                $vmr.option.buffer.wdm  | Should -Be $value
                $vmr.option.buffer.ks   | Should -Be $value
                $vmr.option.buffer.asio | Should -Be $value
            }
        }
        
        Context 'Macrobutton' -ForEach @(
            @{ Index = 0 }, @{ Index = 79 }
        ) {
            It "Should set Button[$index].color" -ForEach (0..8) {
                param($color)
                $vmr.button[$index].color = $color
            }
        }
    }

    Describe 'Float Tests' -ForEach @( # knob: 1 to 8 / 0 to 10, slide: -12 to 12 / -24 to 24
        @{ Gain = -24.3; 2D_x = -0.2; 2D_y = 0.8; Knob = 6.4; Slide = -7.5; Ms = 196.8 }
        @{ Gain = -12.6; 2D_x = 0.4; 2D_y = 0.1; Knob = 3.7; Slide = 5.9; Ms = 32.6 }
    ) {
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = $phys_in }, @{ Index = $virt_in }
        ) {
            It "Should set and get Strip[$index] floats" {
                $vmr.strip[$index].gain  = $gain
                $vmr.strip[$index].pan_x = $2d_x
                $vmr.strip[$index].pan_y = $2d_y
                
                $vmr.strip[$index].gain  | Should -Be $gain
                $vmr.strip[$index].pan_x | Should -Be $2d_x
                $vmr.strip[$index].pan_y | Should -Be $2d_y
            }
            
            It "Should set and get Strip[$index] floats (banana+)" -Skip:$ifBasic {
                $vmr.strip[$index].limit = $gain
                $vmr.strip[$index].limit | Should -Be $gain
            }
            
            It "Should set and get Strip[$index] floats (potato)" -Skip:$ifNotPotato {
                $vmr.strip[$index].gainlayer[0] = $gain
                $vmr.strip[$index].gainlayer[0] | Should -Be $gain
            }
        }
        
        Context 'Strip, physical only' {
            BeforeAll { $index = $phys_in }
            
            It "Should set and get Strip[$index] floats" {
                $vmr.strip[$index].color_x = $2d_x
                $vmr.strip[$index].color_y = $2d_y
                
                $vmr.strip[$index].color_x | Should -Be $2d_x
                $vmr.strip[$index].color_y | Should -Be $2d_y
            }
            
            It "Should set and get Strip[$index] floats (banana+)" -Skip:$ifBasic {
                $vmr.strip[$index].fx_x = $2d_x
                $vmr.strip[$index].fx_y = $2d_y
                
                $vmr.strip[$index].fx_x | Should -Be $2d_x
                $vmr.strip[$index].fx_y | Should -Be $2d_y
            }
            
            It "Should set and get Strip[$index] floats (basic)" -Skip:$ifNotBasic {
                $vmr.strip[$index].audibility = $knob
                $vmr.strip[$index].audibility | Should -Be $knob
            }
            
            It "Should set and get Strip[$index] floats (potato)" -Skip:$ifNotPotato {
                $vmr.strip[$index].reverb = $knob
                $vmr.strip[$index].delay  = $knob
                $vmr.strip[$index].fx1    = $knob
                $vmr.strip[$index].fx2    = $knob
                
                $vmr.strip[$index].reverb | Should -Be $knob
                $vmr.strip[$index].delay  | Should -Be $knob
                $vmr.strip[$index].fx1    | Should -Be $knob
                $vmr.strip[$index].fx2    | Should -Be $knob
            }
            
            Context 'Audibility and pitch' -Skip:$ifBasic {
                It "Should set and get Strip[$index] audibility floats" {
                    $vmr.strip[$index].comp.knob = $knob
                    $vmr.strip[$index].gate.knob = $knob
                    
                    $vmr.strip[$index].comp.knob | Should -Be $knob
                    $vmr.strip[$index].gate.knob | Should -Be $knob
                }
                
                It "Should set and get Strip[$index] compressor floats (potato)" -Skip:$ifNotPotato {
                    $vmr.strip[$index].comp.gainin    = $slide
                    $vmr.strip[$index].comp.ratio     = $knob
                    $vmr.strip[$index].comp.threshold = $gain
                    $vmr.strip[$index].comp.attack    = $ms
                    $vmr.strip[$index].comp.release   = $ms
                    $vmr.strip[$index].comp.knee      = $2d_y
                    $vmr.strip[$index].comp.gainout   = $slide
                    
                    $vmr.strip[$index].comp.gainin    | Should -Be $slide
                    $vmr.strip[$index].comp.ratio     | Should -Be $knob
                    $vmr.strip[$index].comp.threshold | Should -Be $gain
                    $vmr.strip[$index].comp.attack    | Should -Be $ms
                    $vmr.strip[$index].comp.release   | Should -Be $ms
                    $vmr.strip[$index].comp.knee      | Should -Be $2d_y
                    $vmr.strip[$index].comp.gainout   | Should -Be $slide
                }
                
                It "Should set and get Strip[$index] gate floats (potato)" -Skip:$ifNotPotato {
                    $vmr.strip[$index].gate.threshold = $gain
                    $vmr.strip[$index].gate.damping   = $gain
                    $vmr.strip[$index].gate.attack    = $ms
                    $vmr.strip[$index].gate.hold      = $ms
                    $vmr.strip[$index].gate.release   = $ms
                    
                    $vmr.strip[$index].gate.threshold | Should -Be $gain
                    $vmr.strip[$index].gate.damping   | Should -Be $gain
                    $vmr.strip[$index].gate.attack    | Should -Be $ms
                    $vmr.strip[$index].gate.hold      | Should -Be $ms
                    $vmr.strip[$index].gate.release   | Should -Be $ms
                }
            
                It "Should set and get Strip[$index] denoiser floats (potato)" -Skip:$ifNotPotato {
                    $vmr.strip[$index].denoiser.knob      = $knob
                    $vmr.strip[$index].denoiser.threshold = $knob
                    
                    $vmr.strip[$index].denoiser.knob      | Should -Be $knob
                    $vmr.strip[$index].denoiser.threshold | Should -Be $knob
                }
                
                It "Should set and get Strip[$index] pitch floats (potato)" -Skip:$ifNotPotato {
                    $vmr.strip[$index].pitch.pitchvalue = $slide
                    $vmr.strip[$index].pitch.loformant  = $slide
                    $vmr.strip[$index].pitch.medformant = $slide
                    $vmr.strip[$index].pitch.hiformant  = $slide
                    
                    $vmr.strip[$index].pitch.pitchvalue | Should -Be $slide
                    $vmr.strip[$index].pitch.loformant  | Should -Be $slide
                    $vmr.strip[$index].pitch.medformant | Should -Be $slide
                    $vmr.strip[$index].pitch.hiformant  | Should -Be $slide
                }
            }
        }
        
        Context 'Strip, virtual only' {
            BeforeAll { $index = $virt_in }
            
            It "Should set and get virtual Strip[$index] EQ via aliases" {
                $vmr.strip[$index].bass   = 0
                $vmr.strip[$index].mid    = 0
                $vmr.strip[$index].treble = 0
                
                $vmr.strip[$index].low    = $slide
                $vmr.strip[$index].med    = $slide
                $vmr.strip[$index].high   = $slide
                
                $vmr.strip[$index].bass   | Should -Be $slide
                $vmr.strip[$index].low    | Should -Be $slide
                $vmr.strip[$index].mid    | Should -Be $slide
                $vmr.strip[$index].med    | Should -Be $slide
                $vmr.strip[$index].treble | Should -Be $slide
                $vmr.strip[$index].high   | Should -Be $slide
            }
        }
        
        Context 'Bus, one physical one virual' -ForEach @(
            @{ Index = $phys_out }, @{ Index = $virt_out }
        ) {
            It "Should set and get Bus[$index] floats" {
                $vmr.bus[$index].gain = $gain
                $vmr.bus[$index].gain | Should -Be $gain
            }
            
            It "Should set and get Bus[$index] floats (potato)" -Skip:$ifNotPotato {
                $vmr.bus[$index].returnreverb = $knob
                $vmr.bus[$index].returndelay  = $knob
                $vmr.bus[$index].returnfx1    = $knob
                $vmr.bus[$index].returnfx2    = $knob
                
                $vmr.bus[$index].returnreverb | Should -Be $knob
                $vmr.bus[$index].returndelay  | Should -Be $knob
                $vmr.bus[$index].returnfx1    | Should -Be $knob
                $vmr.bus[$index].returnfx2    | Should -Be $knob
            }
        }
        
        Context 'Option' {
            It "Should set and get Option.delay[$phys_out]" {
                $mss = $ms + 0.03   # delay should take and return 2 decimal places
                $vmr.option.delay[$phys_out] = $mss
                $vmr.option.delay[$phys_out] | Should -Be $mss
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
        Context 'Bus and physical strip' -ForEach @(
            @{ Eq = $vmr.bus[$phys_out].eq;  Label = "Bus[$phys_out]";  Skip = $ifBasic }
            @{ Eq = $vmr.bus[$virt_out].eq;  Label = "Bus[$virt_out]";  Skip = $ifBasic }
            @{ Eq = $vmr.strip[$phys_in].eq; Label = "Strip[$phys_in]"; Skip = $ifNotPotato }
        ) {
            It "Should set and get $Label.EQ booleans" -Skip:$Skip -ForEach @(
                @{ Value = $true }, @{ Value = $false }
            ) {
                $Eq.on = $value
                $Eq.ab = $value
                
                $Eq.on | Should -Be $value
                $Eq.ab | Should -Be $value
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
    
    Describe 'Recorder Tests' {
        Context 'Recorder' -Skip:$ifBasic {
            
        }
    }
    
    Describe 'VBAN Tests' {
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
                    @{ Value = $true; Expected = $true }
                    @{ Value = $false; Expected = $false }
                ) {
                    $Stream.on = $value
                    $Stream.on | Should -Be $value
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
                    $Stream.route   = 7
                    
                    $Stream.port    | Should -Be 65535
                    $Stream.quality | Should -Be 4
                    $Stream.route   | Should -Be 7
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
                    
                    $Stream.sr      | Should -BeIn $samplerates
                    $Stream.channel | Should -BeIn $channels
                    $Stream.bit     | Should -BeIn $bitdepths
                }
            }
        }
    }
    
    Describe 'Special Command Tests' {
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
}
