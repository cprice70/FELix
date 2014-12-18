#   FELConsts.rb
#   Copyright 2014 Bartosz Jankowski
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

FELIX_VERSION = "1.0 alfa"

#Maximum data transfer length
FELIX_MAX_CHUNK  = 65536
FELIX_HEADER_KEY = "\0" * 31 << "i"
FELIX_ITEM_KEY   = "\1" * 31 << "m"
FELIX_DATA_KEY   = "\2" * 31 << "g"

FELIX_SUCCESS = 0
FELIX_FAIL = 1
FELIX_FATAL = 2

#AWUSBRequest type
USBCmd = {
  :read                            => 0x11,
  :write                           => 0x12
}

#FEL Messages
FELCmd = {
  :verify_device                   => 0x1, # can be used in FES
  :switch_role                     => 0x2,
  :is_ready                        => 0x3, # Read len 8, can be used in FES
  :get_cmd_set_ver                 => 0x4, # can be used in FES
  :disconnect                      => 0x10,
  :download                        => 0x101, # write
  :run                             => 0x102,
  :upload                          => 0x103
}

#FES Messages
FESCmd = {
  :transmite                       => 0x201, # read,write depends on flag
  :run                             => 0x202,
  :info                            => 0x203, # len ∈ {24...31}
  :get_msg                         => 0x204,
  :unreg_fed                       => 0x205,
  :download                        => 0x206,
  :upload                          => 0x207,
  :verify                          => 0x208,
  :query_storage                   => 0x209, # used to check if we boot from nand or sdcard
  :flash_set_on                    => 0x20A, # execs sunxi_sprite_init(0) => no data
  :flash_set_off                   => 0x20B, # execs sunxi_sprite_exit(1) => no data
  :verify_value                    => 0x20C,
  :verify_status                   => 0x20D, # Read len 12 => AWFESVerifyStatusResponse
  :flash_size_probe                => 0x20E, # Read len 4 => sunxi_sprite_size()
  :tool_mode                       => 0x20F, # can be used to reboot device
                                             # :toolmode is one of AWUBootWorkMode
                                             # :nextmode is desired mode
  :memset                          => 0x210, # can be used to fill memory with desired value (byte)
  :pmu                             => 0x211,
  :unseqmem_read                   => 0x212,
  :unseqmem_write                  => 0x213
}

# Mode returned by FELCmd[:verify_device]
AWDeviceMode = {
  :null                            => 0x0,
  :fel                             => 0x1,
  :fes                             => 0x2, # also :srv
  :update_cool                     => 0x3,
  :update_hot                      => 0x4
}

# U-boot mode (uboot_spare_head.boot_data.work_mode,0xE0 offset)
AWUBootWorkMode = {
  :boot                            => 0x0,  # normal start
  :usb_tool_product                => 0x4,  # if :action => :none, then reboots device
  :usb_tool_update                 => 0x8,
  :usb_product                     => 0x10, # FES mode
  :card_product                    => 0x11, # SD-card flash
  :usb_debug                       => 0x12, # FES mode with debug
  :usb_update                      => 0x20, # USB upgrade?
  :outer_update                    => 0x21  # external disk upgrade
}

# Used as argument for FES_SET_TOOL_MODE. Names are self-explaining
AWActions = {
  :none                             => 0x0,
  :normal		                       	=> 0x1,
  :reboot		                       	=> 0x2,
  :shutdown	                      	=> 0x3,
  :reupdate	                      	=> 0x4,
  :boot		                         	=> 0x5
}

# Flag for FESCmd[:transmite]
FESTransmiteFlag = {
  :write                           => 0x10, # aka :download
  :read                            => 0x20, # aka :upload
# used on boot1.0 (index must be 0x20)
  :start                           => 0x40, # [not sure]
  :finish                          => 0x80, # [not sure]
}

#TAGS FOR FES_DOWN
AWTags = {
  :none                            => 0x0,
#  :data_mask                       => 0x7FFF,
#  :dram_mask                       => 0x7F00,
  :dram                            => 0x7F00,
  :mbr                             => 0x7F01, # this flag actually perform erase
  :uboot                           => 0x7F02,
  :boot1                           => 0x7F02,
  :boot0                           => 0x7F03,
  :erase                           => 0x7F04, # forces platform->eraseflag
  :pmu_set                         => 0x7F05,
  :unseq_mem_for_read              => 0x7F06,
  :unseq_mem_for_write             => 0x7F07,
  :flash                           => 0x8000, # used only for writing
  :finish                          => 0x10000,
  :start                           => 0x20000,
#  :mask                            => 0x30000
}

#csw_status of AWUSBResponse
AWUSBStatus = {
  :ok => 0,
  :fail => 1
}

#FES STORAGE TYPE
FESIndex = {
  :dram                            => 0x0,
  :physical                        => 0x1,
  :log                             => 0x2,
# these below are usable on boot 1.0
  :nand                            => 0x2,
  :card                            => 0x3,
  :unknown                         => 0x20
}

#Livesuit image attributes
AWImageAttr = {
  :res                            => 0x800,
  :length                         => 0x80000,
  :encode                         => 0x4000000,
  :compress                       => 0x80000000
}

#Live suit item types
AWItemType = {
  :common                         => "COMMON",
  :info                           => "INFO",
  :bootrom                        => "BOOTROM",
  :fes                            => "FES",
  :fet                            => "FET",
  :fed                            => "FED",
  :fex                            => "FEX",
  :boot0                          => "BOOT0",
  :boot1                          => "BOOT1",
  :rootfsfat12                    => "RFSFAT12",
  :rootfsfat16                    => "RFSFAT16",
  :rootfsfat32                    => "FFSFAT32",
  :userfsfat12                    => "UFSFAT12",
  :userfsfat16                    => "UFSFAT16",
  :userfsfat32                    => "UFSFAT32",
  :phoenix_script                 => "PXSCRIPT",
  :phoenix_tools                  => "PXTOOLS",
  :audio_dsp                      => "AUDIODSP",
  :video_dsp                      => "VIDEODSP",
  :font                           => "FONT",
  :flash_drv                      => "FLASHDRV",
  :os_core                        => "OS_CORE",
  :driver                         => "DRIVER",
  :pic                            => "PICTURE",
  :audio                          => "AUDIO",
  :video                          => "VIDEO",
  :application                    => "APP"
}

#Sparse image chunk types
ChunkType = {
  :raw                            => 0xcac1,
  :fill                           => 0xcac2,
  :dont_care                      => 0xcac3
}
