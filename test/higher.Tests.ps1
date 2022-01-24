Describe -Tag 'higher', -TestName 'All Higher Tests' {
    Describe 'Bool tests' -ForEach @(
        @{ Value = $true; Expected = $true }
        @{ Value = $false; Expected = $false }
    ){
        Context 'Strip, one physical one virtual' -ForEach @(
            @{ Index = 0 }, @{ Index = 3 }
        ){
            It "Should set and get Strip[$index].Mute" {
                $vmr.strip[$index].mute = $value
                $vmr.strip[$index].mute | Should -Be $expected
            }

            It "Should set and get Strip[$index].Solo" {
                $vmr.strip[$index].solo = $value
                $vmr.strip[$index].solo | Should -Be $expected
            }

            It "Should set and get Strip[$index].A3" {
                $vmr.strip[$index].A3 = $value
                $vmr.strip[$index].A3 | Should -Be $expected
            }

            It "Should set and get Strip[$index].B2" {
                $vmr.strip[$index].B2 = $value
                $vmr.strip[$index].B2 | Should -Be $expected
            }
        }

        Context 'Bus, one physical one virtual' -ForEach @(
            @{ Index = 2 }, @{ Index = 4 }
        ){
            It "Should set and get Bus[$index].Eq" {
                $vmr.bus[$index].eq = $value
                $vmr.bus[$index].eq | Should -Be $expected
            }

            It "Should set and get Bus[$index].Mono" {
                $vmr.bus[$index].mono = $value
                $vmr.bus[$index].mono | Should -Be $expected
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
            @{ Index = 0 }, @{ Index = 4 }
        ){
            It "Should set vban.instream[$index].on" {
                $vmr.vban.instream[$index].on = $value
                $vmr.vban.instream[$index].on | Should -Be $expected
            }
        }

        Context 'Vban outstream' -ForEach @(
            @{ Index = 3 }, @{ Index = 7 }
        ){
            It "Should set vban.outstream[$index].on" {
                $vmr.vban.outstream[$index].on = $value
                $vmr.vban.outstream[$index].on | Should -Be $expected
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
                @{ Index = 0 }, @{ Index = 4 }
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

            Context 'physical only' -ForEach @(
                @{ Index = 0 }, @{ Index = 1 }
            ){
                Context 'comp, gate' -ForEach @(
                    @{ Value = 8.3; Expected = 8.3 }, @{ Value = 5.1; Expected = 5.1 }
                ){
                    It "Should set Strip[$index].Comp to $value" {
                        $vmr.strip[$index].comp = $value
                        $vmr.strip[$index].comp | Should -Be $expected
                    }

                    It "Should set Strip[$index].Gate to $value" {
                        $vmr.strip[$index].gate = $value
                        $vmr.strip[$index].gate | Should -Be $expected
                    }
                }
            }            
        }

        Describe 'Bus tests' {
            Context 'one physical, one virtual' -ForEach @(
                @{ Index = 0 }, @{ Index = 4 }
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
        @{ Index = 0 }, @{ Index = 4 }
    ){
        Context 'Strip, one physical, one virtual' -ForEach @(
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
            @{ Index = 0 }, @{ Index = 4 }
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
            @{ Index = 0 }, @{ Index = 4 }
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
            @{ Index = 0 }, @{ Index = 4 }
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
