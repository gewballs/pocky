//==============================================================================
// Pocky & Rocky
// (c) 1993 Natsumi
// trace, disassembly, and decompile by anon
//==============================================================================

//==============================================================================
// Ram map  
//==============================================================================
    $00 byte nmi_ready
    $01 byte ???
    $02 word nmi_tick
    $04 word mode
    $06 byte nmi_vram
    $08 word cntrl1
    $0A word trigger1
    $0C word cntrl2
    $0E word trigger2
    $10 byte local[0x10]
    $20 word bg1hofs
    $22 word bg1vofs
    $24 word bg2hofs
    $26 word bg2vofs
    $28 word bg3hofs
    $2A word bg3vofs
    $2C byte mosaic
    $4C word ???
    $50 word ???
    $52 word ???
    $68 word ???
    $B0 byte vhtimen
    $B1 word vtime
    $B4 word ???
    $B8 word ???
    $BA byte ???
    $C0 word ???
    $CA byte cgswsel
    $CB byte cgadsub
    $CE byte tmw
    $CF byte tsw
    $EC byte cgselect
    $ED byte hdmaen
    $EE byte tm
    $EF byte ts
    $F0 word apu_cmd0
    $F2 word apu_cmd1
    $F4 word apu_cmd2
    $F6 word apu_cmd3
    $F8 word apu_cmd4
    $FA word apu_cmd5
    $FC word apu_cmd6
    $FE word apu_cmd7
  $012A word ???
  $0220 byte oam[0x0220]
  $0522 word nmi_vindex
  $0524 word nmi_vdata[0x????]
  $0600 byte ???[0x0400]
  $0A40 word ???
  $0A4E byte apu_tick
  $0A50 word ???
  $0A98 word ???
  $0A9A word ???
  $0F00 word ???
  $0F20 word ???
  $0F22 word ???
  $0F24 word ???
  $0F26 byte brightness
  $0F28 word ???
  $0FFC word bg4hofs
  $0FFE word bg4vofs
  $1000 byte bgmode
  $1014 word m7a
  $1016 word m7b
  $1018 word m7c
  $101A word m7d
  $101C word m7x
  $101E word m7y
$7F0002 word nmi_bg1v
$7F0012 word nmi_bg2v
$7F0022 word nmi_bg1h
$7F0032 word nmi_bg2h
$7E2000 word cgram[0x0100]
$7E2200 word cgram2[0x0100]
$7E7000 byte ???[0x1000]
$7F8000 byte decode_buffer[0x????]

//==============================================================================
// Rom map  
//==============================================================================

// Bank 0x00 ===================================================================
$008000 vec  Rst
$0081CE jsr  Joy
$0081F7 vec  Irq
// ...
$0089F7 jsr  ???
$008A09 word ???[0x08]
$008B3B jsr  ???
// ...
$008BA9 jsr  ???
// ...
$008BBD jsr  ???
// ...
$008BE8 jsr  ???
$008C72 jsr  DecodeBg3
$008CB8 jsr  Decode
$008CBD jsl  Decode_l
$008CDF jsr  DecodeLoop
$008DC9 jsr  DecodeCopy
$008E49 jsr  NmiVram
$008E9D vec  Nmi
$0090A6 vec  Brk
$0090A7 jsr  ???
// ...
$00913D jsl  Mode
$009149 word modes[0x5B]
// ...
$00A08A jsr  ???
// ...
$00A0A1 jsr  ???
// ...
$00BB33 jsr  Decode2Vram
// ...
$00BBC5 jsr  Decode2Cgwram
// ...
$00C418 jsl  EnableNmi
$00C428 jsl  DisableNmi
// ...
$00C44E jsr  ??? // Fade mode related
// ...
$00C6BB jsl  ??? // Fade mode related
// ...
$00C75E jsl  ModeLicenseLoad
// ...
$00FB78 jsr  DmaBg1v
$00FBE5 jsr  DmaBg2v
$00FC52 jsr  DmaBg1h
$00FCCE jsr  DmaBg2h
// ...
$00FFC0 byte rom_header[0x20]
$00FFE0 word vectors[0x10]

// Bank 0x02 ===================================================================
$02B006 jsl  Bg3Decode_l
$02B012 jsr  Bg3DecodeHorz
$02B019 jsr  Bg3DecodeVert
$02B020 jsr  Bg3DecodeLoop
$02B0D3 jsr  Bg3DecodeCopy
$02B0E7 jsr  Bg3DecodeInc
$02B0EF jsr  Bg3DecodeInc2
$02B0F7 word ???[0x01] // bg3 indirect table
$02B0F9 byte ???       // bg3 encoded maps
$02B7A3 jsr  Bg3DecodeMap
$02B7B0 word bg3maps[0x0C]
// ...
$02D831 jsl  ???

// Bank 0x08 ===================================================================
$088000 jsl  ??? // Audio boot loader (and driver?)

//==============================================================================
// Bank 0x00
//==============================================================================

// Reset =======================================================================
                                                           ;Rst() {
008000 78          SEI                 SEI                 ; Sei(); // disable interrupts
008001 D8          CLD                 CLD                 ; Cld(); // binary mode
008002 18          CLC                 CLC                 ; E = 0; // native mode
008003 FB          XCE                 XCE                 ; 
008004 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
008006 A9 00 00    LDA #$0000          LDA #$0000          ; D = 0x0000; // direct page
008009 5B          TCD                 TCD                 ;
00800A 48          PHA                 PHA                 ; B = 0x00; // data bank
00800B AB          PLB                 PLB                 ;
00800C A9 1F 02    LDA #$021F          LDA #$021F          ; S = 0x021F; // stack
00800F 1B          TCS                 TCS                 ; // reset wram
008010 A9 00 00    LDA #$0000          LDA #$0000          ; $7F0000 = 0x0000;
008013 8F 00 00 7F STA $7F0000         STA $7F0000         ; // zero 0x7F0000 - 0x7FFFFF
008017 AA          TAX                 TAX                 ; Mvn(0x7F0000, 0x7F0001, 0x0000);
008018 9B          TXY                 TXY                 ;
008019 C8          INY                 INY                 ;
00801A A9 FE FF    LDA #$FFFE          LDA #$FFFE          ;
00801D 54 7F 7F    MVN $7F,$7F         MVN $7F,$7F         ; // zero 0x7E2000 - 0x7EEFFE
008020 A2 00 20    LDX #$2000          LDX #$2000          ; Mvn(0x7F2000, 0x7E2000, 0xCFFE);
008023 9B          TXY                 TXY                 ;
008024 A9 FE CF    LDA #$CFFE          LDA #$CFFE          ;
008027 54 7E 7F    MVN $7F,$7E         MVN $7F,$7E         ; // zero 0x000200 - 0x001FFF
00802A A2 00 02    LDX #$0200          LDX #$0200          ; Mvn(0x7F0200, 0x000200, 0x1DFF);
00802D 9B          TXY                 TXY                 ;
00802E A9 FF 1D    LDA #$1DFF          LDA #$1DFF          ;
008031 54 00 7F    MVN $7F,$00         MVN $7F,$00         ; // zero 0x000000 - 0x00017F
008034 A2 00 00    LDX #$0000          LDX #$0000          ; Mvn(0x7F0000, 0x000000, 0x017F);
008037 9B          TXY                 TXY                 ;
008038 A9 7F 01    LDA #$017F          LDA #$017F          ;
00803B 54 00 7F    MVN $7F,$00         MVN $7F,$00         ; // reset registers
00803E E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
008040 A9 00       LDA #$00            LDA #$00            ; B = 0x00;
008042 48          PHA                 PHA                 ;
008043 AB          PLB                 PLB                 ;
008044 9C 40 21    STZ $2140           STZ APUIO0          ; APUIO0 = 0x00;
008047 9C 41 21    STZ $2141           STZ APUIO1          ; APUIO1 = 0x00;
00804A 9C 42 21    STZ $2142           STZ APUIO2          ; APUIO2 = 0x00;
00804D 9C 43 21    STZ $2143           STZ APUIO3          ; APUIO3 = 0x00;
008050 64 2C       STZ $2C             STZ mosaic          ; mosaic = 0x00;
008052 9C 00 42    STZ $4200           STZ NMITIMEN        ; NMITIMEN = 0x00;
008055 9C 0B 42    STZ $420B           STZ MDMAEN          ; MDMAEN = 0x00;
008058 9C 0C 42    STZ $420C           STZ HDMAEN          ; HDMAEN = 0x00;
00805B A9 01       LDA #$01            LDA #$01            ; VTIME = 0x0001;
00805D 8D 09 42    STA $4209           STA VTIME.lo        ;
008060 9C 0A 42    STZ $420A           STZ VTIME.hi        ;
008063 A9 FF       LDA #$FF            LDA #$FF            ; WRIO = 0xFF;
008065 8D 01 42    STA $4201           STA WRIO            ;
008068 A9 8F       LDA #$8F            LDA #$8F            ; INIDISP = 0x8F;
00806A 8D 00 21    STA $2100           STA INIDISP         ;
00806D A9 63       LDA #$63            LDA #$63            ; OBJSEL = 0x63;
00806F 8D 01 21    STA $2101           STA OBJSEL          ;
008072 9C 06 21    STZ $2106           STZ MOSAIC          ; MOSAIC = 0x00;
008075 A9 09       LDA #$09            LDA #$09            ; BGMODE = 0x09;
008077 8D 05 21    STA $2105           STA BGMODE          ;
00807A A9 43       LDA #$43            LDA #$43            ; BG1SC = 0x43;
00807C 8D 07 21    STA $2107           STA BG1SC           ;
00807F A9 33       LDA #$33            LDA #$33            ; BG2SC = 0x33;
008081 8D 08 21    STA $2108           STA BG2SC           ;
008084 A9 59       LDA #$59            LDA #$59            ; BG3SC = 0x59;
008086 8D 09 21    STA $2109           STA BG3SC           ;
008089 9C 0A 21    STZ $210A           STZ BG4SC           ; BG4SC = 0x00;
00808C A9 00       LDA #$00            LDA #$00            ; BG12NBA = 0x00;
00808E 8D 0B 21    STA $210B           STA BG12NBA         ;
008091 A9 55       LDA #$55            LDA #$55            ; BG34NBA = 0x55;
008093 8D 0C 21    STA $210C           STA BG34NBA         ;
008096 A9 00       LDA #$00            LDA #$00            ; for (X = 0x0003; X > 0; X--) {
008098 A2 03 00    LDX #$0003          LDX #$0003          ;
00809B 9D 0D 21    STA $210D,X      -: STA BG1HOFS,X       ;   BG1HOFS[X] = 0x00;
00809E 9D 0D 21    STA $210D,X         STA BG1HOFS,X       ;   BG1HOFS[X] = 0x00;
0080A1 CA          DEX                 DEX                 ;
0080A2 10 F7       BPL $F7             BPL -               ; }
0080A4 A2 0B 00    LDX #$000B          LDX #$000B          ; for (X = 0x000B; X > 0; X--) {
0080A7 9D 20 00    STA $0020,X      -: STA bg1hofs,X       ;   bg1hofs[X] = 0x00;
0080AA CA          DEX                 DEX                 ;
0080AB 10 FA       BPL $FA             BPL -               ; }
0080AD A9 80       LDA #$80            LDA #$80            ; VMAINC = 0x80;
0080AF 8D 15 21    STA $2115           STA VMAINC          ; // highly improper register clear
0080B2 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
0080B4 A9 00 60    LDA #$6000          LDA #$6000          ; VMADD = 0x6000;
0080B7 8D 16 21    STA $2116           STA VMADD           ;
0080BA 9C 1A 21    STZ $211A           STZ M7SEL           ; M7SEL = 0x00; M7A = 0x00;
0080BD 9C 1C 21    STZ $211C           STZ M7B             ; M7B = 0x00; M7C = 0x00;
0080C0 9C 1E 21    STZ $211E           STZ M7D             ; M7D = 0x00; M7X = 0x00;
0080C3 9C 20 21    STZ $2120           STZ M7Y             ; M7Y = 0x00; CGADD = 0x00;
0080C6 9C 22 21    STZ $2122           STZ CGDATA          ; CGDATA = 0x00; W12SEL = 0x00;
0080C9 9C 24 21    STZ $2124           STZ W34SEL          ; W34SEL = 0x00; WOBJSEL = 0x00;
0080CC 9C 26 21    STZ $2126           STZ WH0             ; WH0 = 0x00; WH1 = 0x00;
0080CF 9C 28 21    STZ $2128           STZ WH2             ; WH2 = 0x00; WH3 = 0x00;
0080D2 9C 2A 21    STZ $212A           STZ WBGLOG          ; WBGLOG = 0x00; WOBJLOG = 0x00;
0080D5 9C 33 21    STZ $2133           STZ SETINI          ; SETINI = 0x00; MPY.lo = 0x00;
0080D8 64 CE       STZ $CE             STZ tmw             ; tmw = 0x00; tsw = 0x00; // reset memory
0080DA E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
0080DC 64 00       STZ $00             STZ nmi_ready       ; nmi_ready = 0x00;
0080DE 64 01       STZ $01             STZ $01             ; $01 = 0x00;
0080E0 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
0080E2 64 20       STZ $20             STZ bg1hofs         ; bg1hofs = 0x0000;
0080E4 64 24       STZ $24             STZ bg2hofs         ; bg2hofs = 0x0000;
0080E6 64 28       STZ $28             STZ bg3hofs         ; bg3hofs = 0x0000;
0080E8 9C FC 0F    STZ $0FFC           STZ bg4hofs         ; bg4hofs = 0x0000;
0080EB 64 A6       STZ $A6             STZ $A6             ; $A6 = 0x0000;
0080ED 9C 4E 0A    STZ $0A4E           STZ apu_tick        ; apu_tick = 0x0000;
0080F0 E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
0080F2 A2 FF 01    LDX #$01FF          LDX #$01FF          ; for (X = 0x01FF; X > 0; X--) {
0080F5 A9 F0       LDA #$F0            LDA #$F0            ;   oam[X] = 0xF0;
0080F7 9D 20 02    STA $0220,X      -: STA oam,X           ;
0080FA CA          DEX                 DEX                 ;
0080FB 10 FA       BPL $FA             BPL -               ; }
0080FD 20 A7 90    JSR $90A7           JSR $90A7           ; $90A7();
008100 E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
008102 A9 00       LDA #$00            LDA #$00            ; for (X = 0x10FF; X > 0; X--) {
008104 A2 FF 10    LDX #$10FF          LDX #$10FF          ;
008107 9D 00 0F    STA $0F00,X      -: STA $0F00,X         ;   $0F00[X] = 0x00;
00810A CA          DEX                 DEX                 ;
00810B 10 FA       BPL $FA             BPL -               ; }
00810D A2 FF 0F    LDX #$0FFF          LDX #$0FFF          ; for (X = 0x0FFF; X > 0; X--) {
008110 9F 00 70 7E STA $7E7000,X    -: STA $7E7000,X       ;   $7E7000[X] = 0x00;
008114 CA          DEX                 DEX                 ;
008115 10 F9       BPL $F9             BPL -               ; }
008117 A2 F0 00    LDX #$00F0          LDX #$00F0          ; for (X = 0x00F0; X != 0x0130; X += 2) {
00811A 9D 00 00    STA $0000,X      -: STA $0000,X         ;   $0000[X] = 0x00;
00811D E8          INX                 INX                 ;
00811E E8          INX                 INX                 ;
00811F E0 30 01    CPX #$0130          CPX #$0130          ;
008122 D0 F6       BNE $F6             BNE -               ; }
008124 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
008126 A9 00 40    LDA #$4000          LDA #$4000          ; $0A98 = 0x4000;
008129 8D 98 0A    STA $0A98           STA $0A98           ;
00812C 8D 9A 0A    STA $0A9A           STA $0A9A           ; $0A9A = 0x4000;
00812F 22 31 D8 02 JSL $02D831         JSL $02D831         ; $02D831();
008133 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
008135 9C 2A 01    STZ $012A           STZ $012A           ; $012A = 0x0000;
008138 A9 14 82    LDA #$8214          LDA #$8214          ; $B4 = 0x8214;
00813B 85 B4       STA $B4             STA $B4             ;
00813D 85 B8       STA $B8             STA $B8             ; $B8 = 0x8214;
00813F 9C 40 0A    STZ $0A40           STZ $0A40           ; $0A40 = 0x0000;
008142 64 CA       STZ $CA             STZ $CA             ; cgswsel = 0x00; cgadsub = 0x00;
008144 A9 08 08    LDA #$0808          LDA #$0808          ; $C0 = 0x0808;
008147 85 C0       STA $C0             STA $C0             ;
008149 20 BD 8B    JSR $8BBD           JSR $8BBD           ; $8BBD();
00814C A5 C0       LDA $C0             LDA $C0             ; $68 = $C0;
00814E 85 68       STA $68             STA $68             ;
008150 A9 00 00    LDA #$0000          LDA #$0000          ; $0F28 = 0x0000;
008153 8D 28 0F    STA $0F28           STA $0F28           ;
008156 A9 01 00    LDA #$0001          LDA #$0001          ; $0F24 = 0x0001;
008159 8D 24 0F    STA $0F24           STA $0F24           ;
00815C A9 00 00    LDA #$0000          LDA #$0000          ; $C44E(0x0000);
00815F 20 4E C4    JSR $C44E           JSR $C44E           ;
008162 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
008164 A9 00 00    LDA #$0000          LDA #$0000          ; $4C = 0x0000;
008167 85 4C       STA $4C             STA $4C             ;
008169 85 50       STA $50             STA $50             ; $50 = 0x0000;
00816B 85 52       STA $52             STA $52             ; $52 = 0x0000;
00816D A9 58 00    LDA #$0058          LDA #$0058          ; mode = 0x0058; // load license
008170 85 04       STA $04             STA mode            ;
008172 A9 00 80    LDA #$8000          LDA #$8000          ; $8BA9(0x8000, 0x0009);
008175 A0 09 00    LDY #$0009          LDY #$0009          ;
008178 20 A9 8B    JSR $8BA9           JSR $8BA9           ;
00817B C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00817D A9 00 EC    LDA #$EC00          LDA #$EC00          ; $8BA9(0xEC00, 0x0015);
008180 A0 15 00    LDY #$0015          LDY #$0015          ;
008183 20 A9 8B    JSR $8BA9           JSR $8BA9           ;
008186 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
008188 A9 67 80    LDA #$8067          LDA #$8067          ; $8BA9(0x8067, 0x0008);
00818B A0 08 00    LDY #$0008          LDY #$0008          ;
00818E 20 A9 8B    JSR $8BA9           JSR $8BA9           ;
008191 E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
008193 AD 10 42    LDA $4210           LDA RDNMI           ; RDNMI;
008196 A9 80       LDA #$80            LDA #$80            ; VMAIN = 0x80;
008198 8D 15 21    STA $2115           STA VMAINC          ;
00819B A9 A0       LDA #$A0            LDA #$A0            ; INIDISP = 0xA0;
00819D 8D 00 42    STA $4200           STA INIDISP         ;
0081A0 58          CLI                 CLI                 ; Cli();
0081A1 A9 00       LDA #$00            LDA #$00            ; INIDISP = 0x00;
0081A3 8D 00 21    STA $2100           STA INIDISP         ;
0081A6 A9 01       LDA #$01            LDA #$01            ; APUIO2 = 0x01;
0081A8 8D 42 21    STA $2142           STA APUIO2          ; // main loop
0081AB 20 CE 81    JSR $81CE        -: JSR Joy             ; for (;;) {
0081AE 22 3D 91 00 JSL $00913D         JSL Mode            ;   Joy();
0081B2 EA          NOP                 NOP                 ;   Mode();
0081B3 EA          NOP                 NOP                 ;
0081B4 EA          NOP                 NOP                 ;
0081B5 EA          NOP                 NOP                 ;
0081B6 EA          NOP                 NOP                 ;
0081B7 EA          NOP                 NOP                 ;
0081B8 EA          NOP                 NOP                 ;
0081B9 EA          NOP                 NOP                 ;
0081BA C2 F8       REP #$F8            REP #$F8            ;   Rep(0xF8);
0081BC A9 1F 02    LDA #$021F          LDA #$021F          ;   S = 0x021F;
0081BF 1B          TCS                 TCS                 ;
0081C0 E2 20       SEP #$20            SEP #$20            ;   Sep(0x20);
0081C2 A9 FF       LDA #$FF            LDA #$FF            ;   nmi_ready = 0xFF;
0081C4 8D 00 00    STA $0000           STA nmi_ready       ;
0081C7 AD 00 00    LDA $0000       --: LDA nmi_ready       ;   while(nmi_ready);
0081CA D0 FB       BNE $FB             BNE --              ;
0081CC 80 DD       BRA $DD             BRA -               ; }
                                                           ;}

// Joy =========================================================================
                                                           ;Joy() {
0081CE E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
0081D0 AD 12 42    LDA $4212        -: LDA HVBJOY          ; while(HVBJOY & 0x0x0001);
0081D3 6A          ROR A               ROR A               ;
0081D4 B0 FA       BCS $FA             BCS -               ;
0081D6 C2 20       REP #$20            REP #$20            ; Rep(0x20);
0081D8 AD 18 42    LDA $4218           LDA CNTRL1          ; trigger1 = CNTRL1 ^ cntrl1 & CNTRL1;
0081DB 45 08       EOR $08             EOR cntrl1          ;
0081DD 2D 18 42    AND $4218           AND CNTRL1          ;
0081E0 85 0C       STA $0C             STA trigger1        ;
0081E2 AD 18 42    LDA $4218           LDA CNTRL1          ; cntrl1 = CNTRL1;
0081E5 85 08       STA $08             STA cntrl1          ;
0081E7 AD 1A 42    LDA $421A           LDA CNTRL2          ; trigger2 = CNTRL2 ^ cntrl1 & CNTRL2;
0081EA 45 0A       EOR $0A             EOR cntrl2          ;
0081EC 2D 1A 42    AND $421A           AND CNTRL2          ;
0081EF 85 0E       STA $0E             STA trigger2        ;
0081F1 AD 1A 42    LDA $421A           LDA CNTRL2          ;
0081F4 85 0A       STA $0A             STA cntrl2          ; cntrl2 = CNTRL2;
0081F6 60          RTS                 RTS                 ; return;
                                                           ;}

// Irq =========================================================================

0081F7 ?? ?? ?? ??

// ...

// ??? =========================================================================
0089F7 20 3B 8B    JSR $8B3B
0089FA E2 20       SEP #$20
0089FC A9 00       LDA #$00
0089FE EB          XBA
0089FF AD 00 01    LDA $0100
008A02 29 7F       AND #$7F
008A04 0A          ASL A
008A05 AA          TAX
008A06 7C 09 8A    JMP ($8A09,X)

008A09 1C 8A
008A0B 19 8A
008A0D BD 8A
008A0F F2 8A
008A11 27 8B
008A13 1C 8A
008A15 1C 8A
008A17 1C 8A

008A19 20 67 8A    JSR $8A67

008A1C E2 20       SEP #$20
008A1E AD 10 01    LDA $0110
008A21 F0 1D       BEQ $1D    [$8A40]
008A23 8D 00 01    STA $0100
008A26 9C 10 01    STZ $0110
008A29 AD 15 01    LDA $0115
008A2C 8D 05 01    STA $0105
008A2F C2 20       REP #$20
008A31 AD 13 01    LDA $0113
008A34 8D 03 01    STA $0103
008A37 AD 11 01    LDA $0111
008A3A 8D 01 01    STA $0101
008A3D 4C 6F 8A    JMP $8A6F
008A40 E2 20       SEP #$20
008A42 AD 20 01    LDA $0120
008A45 F0 1D       BEQ $1D    [$8A64]
008A47 8D 00 01    STA $0100
008A4A 9C 20 01    STZ $0120
008A4D AD 25 01    LDA $0125
008A50 8D 05 01    STA $0105
008A53 C2 20       REP #$20
008A55 AD 23 01    LDA $0123
008A58 8D 03 01    STA $0103
008A5B AD 21 01    LDA $0121
008A5E 8D 01 01    STA $0101
008A61 4C 6F 8A    JMP $8A6F
008A64 C2 20       REP #$20
008A66 60          RTS

008A67 E2 20       SEP #$20
008A69 20 72 8A    JSR $8A72
008A6C 20 72 8A    JSR $8A72

008A6F 20 72 8A    JSR $8A72
008A72 20 85 8A    JSR $8A85
008A75 E2 20       SEP #$20
008A77 A9 80       LDA #$80
008A79 8D 45 43    STA $4345
008A7C 9C 46 43    STZ $4346
008A7F A9 10       LDA #$10
008A81 8D 0B 42    STA $420B
008A84 60          RTS

008A85 E2 20       SEP #$20
008A87 9C 0C 42    STZ $420C
008A8A 9C 00 01    STZ $0100
008A8D A9 80       LDA #$80
008A8F 8D 15 21    STA $2115
008A92 C2 F8       REP #$F8
008A94 18          CLC
008A95 AD 01 01    LDA $0101
008A98 8D 16 21    STA $2116
008A9B 69 00 01    ADC #$0100
008A9D 8D 01 01    STA $0101
008AA1 A9 01 18    LDA #$1801
008AA4 8D 40 43    STA $4340
008AA7 AD 03 01    LDA $0103
008AAA 8D 42 43    STA $4342
008AAD 18          CLC
008AAE 69 00 01    ADC #$0200
008AB0 8D 03 01    STA $0103
008AB4 E2 20       SEP #$20
008AB6 AD 05 01    LDA $0105
008AB9 8D 44 43    STA $4344
008ABC 60          RTS

008ABD E2 20       SEP #$20
008ABF 9C 0C 42    STZ $420C
008AC2 9C 00 01    STZ $0100
008AC5 A9 80       LDA #$80
008AC7 8D 15 21    STA $2115
008ACA C2 F8       REP #$F8
008ACC AD 01 01    LDA $0101
008ACF 8D 16 21    STA $2116
008AD2 A9 01 18    LDA #$1801
008AD5 8D 40 43    STA $4340
008AD8 AD 03 01    LDA $0103
008ADB 8D 42 43    STA $4342
008ADE AD 06 01    LDA $0106
008AE1 8D 45 43    STA $4345
008AE4 E2 20       SEP #$20
008AE6 AD 05 01    LDA $0105
008AE9 8D 44 43    STA $4344
008AEC A9 10       LDA #$10
008AEE 8D 0B 42    STA $420B
008AF1 60          RTS

008AF2 E2 20       SEP #$20
008AF4 9C 0C 42    STZ $420C
008AF7 9C 00 01    STZ $0100
008AFA A9 80       LDA #$80
008AFC 8D 15 21    STA $2115
008AFF C2 F8       REP #$F8
008B01 AD 01 01    LDA $0101
008B04 8D 16 21    STA $2116
008B07 A9 09 18    LDA #$1809
008B0A 8D 40 43    STA $4340
008B0D AD 03 01    LDA $0103
008B10 8D 42 43    STA $4342
008B13 AD 06 01    LDA $0106
008B16 8D 45 43    STA $4345
008B19 E2 20       SEP #$20
008B1B AD 05 01    LDA $0105
008B1E 8D 44 43    STA $4344
008B21 A9 10       LDA #$10
008B23 8D 0B 42    STA $420B
008B26 60          RTS

008B27 20 2A 8B    JSR $8B2A
008B2A 20 85 8A    JSR $8A85
008B2D 9C 45 43    STZ $4345
008B30 A9 01       LDA #$01
008B32 8D 46 43    STA $4346
008B35 A9 10       LDA #$10
008B37 8D 0B 42    STA $420B
008B3A 60          RTS

008B3B E2 20       SEP #$20
008B3D AD 00 01    LDA $0100
008B40 D0 2D       BNE $2D    [$8B6F]
008B42 C2 F8       REP #$F8
008B44 AC 40 04    LDY $0440 
008B47 F0 26       BEQ $26    [$8B6F]
008B49 9C 40 04    STZ $0440
008B4C 88          DEY
008B4D 88          DEY
008B4E B9 42 04    LDA $0442,Y
008B51 8D 06 01    STA $0106
008B54 88          DEY
008B55 88          DEY
008B56 B9 42 04    LDA $0442,Y
008B59 8D 04 01    STA $0104
008B5C 88          DEY
008B5D 88          DEY
008B5E B9 42 04    LDA $0442,Y
008B61 8D 02 01    STA $0102
008B64 88          DEY
008B65 88          DEY
008B66 B9 42 04    LDA $0442,Y
008B69 8D 00 01    STA $0100
008B6C 8C 40 04    STY $0440
008B6F E2 20       SEP #$20
008B71 60          RTS

// ...

// =============================================================================
008BA9 C2 F8       REP #$F8
008BAB 85 10       STA $10
008BAD 84 12       STY $12
008BAF 22 00 80 08 JSL $088000
008BB3 C2 F8       REP #$F8
008BB5 60          RTS

// ...

// ??? =========================================================================
008BBD C2 F8       REP #$F8
008BBF 20 E8 8B    JSR $8BE8
008BC2 C2 F8       REP #$F8
008BC4 64 E6       STZ $E6
008BC6 64 E8       STZ $E8
008BC8 AD 2C 01    LDA $012C
008BCB 29 03 00    AND #$0003
008BCE 0A          ASL A
008BCF 0A          ASL A
008BD0 A8          TAY
008BD1 B9 DC 8B    LDA $8BDC,Y
008BD4 85 6A       STA $6A
008BD6 B9 DE 8B    LDA $8BDE,Y
008BD9 85 66       STA $66
008BDB 60          RTS

// ...

008BE8 C2 F8       REP #$F8
008BEA A5 66       LDA $66
008BEC 48          PHA
008BED A5 5A       LDA $5A
008BEF 48          PHA
008BF0 A5 9A       LDA $9A
008BF2 48          PHA
008BF3 A5 6A       LDA $6A
008BF5 48          PHA
008BF6 A9 00 00    LDA #$0000
008BF9 A2 40 00    LDX #$0040
008BFC 9D 00 00    STA $0000,X
008BFF E8          INX
008C00 E8          INX
008C01 E0 A6 00    CPX #$00A6
008C04 D0 F6       BNE $F6    [$8BFC]
008C06 A2 0A 0A    LDX #$0A0A
008C09 9D 00 00    STA $0000,X
008C0C E8          INX
008C0D E8          INX
008C0E E0 28 0A    CPX #$0A28
008C11 D0 F6       BNE $F6    [$8C09]
008C13 A2 00 0B    LDX #$0B00
008C16 9D 00 00    STA $0000,X
008C19 E8          INX
008C1A E8          INX
008C1B E0 20 0F    CPX #$0F20
008C1E D0 F6       BNE $F6    [$8C16]
008C20 A2 70 0F    LDX #$0F70
008C23 9D 00 00    STA $0000,X
008C26 E8          INX
008C27 E8          INX
008C28 E0 90 0F    CPX #$0F90
008C2B D0 F6       BNE $F6    [$8C23]
008C2D 9C 12 0F    STZ $0F12
008C30 9C 60 0F    STZ $0F60
008C33 64 E4       STZ $E4
008C35 9C 64 0F    STZ $0F64
008C38 9C 6E 0F    STZ $0F6E
008C3B 68          PLA
008C3C 85 6A       STA $6A
008C3E 68          PLA
008C3F 85 9A       STA $9A
008C41 68          PLA
008C42 85 5A       STA $5A
008C44 68          PLA
008C45 85 66       STA $66
008C47 A9 FF FF    LDA #$FFFF
008C4A 85 6C       STA $6C
008C4C 85 6E       STA $6E
008C4E 64 E4       STZ $E4
008C50 A9 01 00    LDA #$0001
008C53 85 5C       STA $5C
008C55 85 9C       STA $9C
008C57 A5 6A       LDA $6A
008C59 29 FF 00    AND #$00FF
008C5C F0 06       BEQ $06    [$8C64]
008C5E A9 18 00    LDA #$0018
008C61 20 8A A0    JSR $A08A
008C64 A5 6B       LDA $6B
008C66 29 FF 00    AND #$00FF
008C69 F0 06       BEQ $06    [$8C71]
008C6B A9 1C 00    LDA #$001C
008C6E 20 A1 A0    JSR $A0A1
008C71 60          RTS

// DecodeBg3 ===================================================================
                                                           ;DecodeBg3(A) {
008C72 22 06 B0 02 JSL $02B006         JSL DecodeBg3_l     ; DecodeBg3_l(A);
008C76 60          RTS                 RTS                 ; return;
                                                           ;}

// ...

// Decode ======================================================================
                                       $10 long from
                                       $13 long to
                                       $16 long offset
                                       $19 word bytes
                                       $1B word header
                                       $1D word index
                                                           ;Decode(Y) {
008CB8 22 BD 8C 00 JSL $008CBD         JSL Decode_l        ; Decode_l(Y); // Y.hi = bank
008CBC 60          RTS                 RTS                 ; return;      // Y.lo = pack
                                                           ;}

                                                           ;Decode_l(Y) {
008CBD C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8); // nvmxdizc
008CBF 64 13       STZ $13             STZ to              ; to = 0x7F8000;
008CC1 A9 80 7F    LDA #$7F80          LDA #$7F80          ;
008CC4 85 14       STA $14             STA to.hi           ;
008CC6 C2 F8       REP #$F8            REP #F8             ; Rep(0xF8);
008CC8 84 11       STY $11             STY from.hi         ; from.bank = (byte) Y >> 8;
008CCA A9 00 80    LDA #$8000          LDA #$8000          ; from.lo = 0x8000;
008CCD 85 10       STA $10             STA from            ;
008CCF 98          TYA                 TYA                 ; Y = (Y & 0x00FF) * 2;
008CD0 29 FF 00    AND #$00FF          AND #$00FF          ;
008CD3 0A          ASL A               ASL A               ;
008CD4 A8          TAY                 TAY                 ;
008CD5 B7 10       LDA [$10],Y         LDA [from],Y        ; from.lo = from[Y];
008CD7 85 10       STA $10             STA from            ;
008CD9 20 DF 8C    JSR $8CDF           JSR Decode          ; DecodeLoop();
008CDC C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
008CDE 6B          RTL                 RTL                 ; return;
                                                           ;}

                                                           ;DecodeLoop() {
008CDF 8B          PHB                 PHB                 ; Push(B);
008CE0 08          PHP                 PHP                 ; Push(P);
008CE1 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
008CE3 A5 11       LDA $11             LDA from.hi         ; B = from.bank;
008CE5 48          PHA                 PHA                 ;
008CE6 AB          PLB                 PLB                 ;
008CE7 AB          PLB                 PLB                 ;
008CE8 A6 10       LDX $10             LDX from            ; X = from.lo;
008CEA BD 00 00    LDA $0000,X         LDA $0000,X         ; if (!(*X & #$00FF)) {
008CED 29 FF 00    AND #$00FF          AND #$00FF          ;   // Uncompressed data
008CF0 D0 27       BNE $27             BNE +               ;
008CF2 E8          INX                 INX                 ;   X += 1;
008CF3 BD 00 00    LDA $0000,X         LDA $0000,X         ;   Y = Push(*X); // Bytes
008CF6 48          PHA                 PHA                 ;
008CF7 A8          TAY                 TAY                 ;
008CF8 E8          INX                 INX                 ;   X += 2;
008CF9 E8          INX                 INX                 ;
008CFA E2 20       SEP #$20            SEP #$20            ;   Sep(0x20);
008CFC A5 13       LDA $13             LDA to.lo           ;   WMADD = to;
008CFE 8D 81 21    STA $2181           STA WMADD.lo        ;
008D01 A5 14       LDA $14             LDA to.hi           ;
008D03 8D 82 21    STA $2182           STA WMADD.hi        ;
008D06 A5 15       LDA $15             LDA to.bank         ;
008D08 8D 83 21    STA $2183           STA WMADD.bank      ;
008D0B BD 00 00    LDA $0000,X      -: LDA $0000,X         ;   for (; Y; Y--) {
008D0E 8D 80 21    STA $2180           STA WMDATA          ;     WMDATA = *X;
008D11 E8          INX                 INX                 ;     X += 1;
008D12 88          DEY                 DEY                 ;   }
008D13 D0 F6       BNE $F6             BNE -               ;
008D15 FA          PLX                 PLX                 ;   X = Pull();
008D16 28          PLP                 PLP                 ;   P = Pull();
008D17 AB          PLB                 PLB                 ;   B = Pull();
008D18 60          RTS                 RTS                 ;   return;
008D19 E8          INX              +: INX                 ; }
008D1A BD 00 00    LDA $0000,X         LDA $0000,X         ; X += 1;
008D1D 85 19       STA $19             STA bytes           ; bytes = Push(*X);
008D1F 48          PHA                 PHA                 ;
008D20 E8          INX                 INX                 ; X += 2;
008D21 E8          INX                 INX                 ; // Save tailing byte
008D22 18          CLC                 CLC                 ; offset.lo = to.lo + bytes;
008D23 A5 13       LDA $13             LDA to              ;
008D25 65 19       ADC $19             ADC bytes           ;
008D27 85 16       STA $16             STA offset          ;
008D29 E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
008D2B A5 15       LDA $15             LDA to.bank         ; offset.bank = to.bank;
008D2D 85 18       STA $18             STA offset_bank     ;
008D2F A7 16       LDA [$16]           LDA [offset]        ; Push(*offset);
008D31 48          PHA                 PHA                 ;
008D32 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
008D34 A5 16       LDA $16             LDA offset          ; Push(offset.lo);
008D36 48          PHA                 PHA                 ; // Decompress data
008D37 BD 00 00    LDA $0000,X  -next :LDA $0000,X         ; for (;;) {
008D3A D0 1A       BNE $1A             BNE +               ;   if (*X == 0 && bytes >= 0x0010) {
008D3C 85 1B       STA $1B             STA header          ;     // Uncompressed line
008D3E E8          INX                 INX                 ;     header = *X; // Ignored
008D3F E8          INX                 INX                 ;     X += 2;
008D40 A5 19       LDA $19             LDA bytes           ;
008D42 C9 10 00    CMP #$0010          CMP #$0010          ;
008D45 90 13       BCC $13             BCC ++              ;
008D47 20 C9 8D    JSR $8DC9           JSR DecodeCopy      ;     DecodeCopy(X);
008D4A 38          SEC                 SEC                 ;     bytes -= 0x0010;
008D4B A5 19       LDA $19             LDA bytes           ;
008D4D E9 10 00    SBC #$0010          SBC #$0010          ;
008D50 85 19       STA $19             STA bytes           ;
008D52 F0 69       BEQ $69             BEQ +done           ;     if (bytes == 0) goto done;
008D54 80 E1       BRA $E1             BRA -next           ;   } else {
008D56 85 1B       STA $1B          +: STA header          ;     // Compressed line
008D58 E8          INX                 INX                 ;     header = *X;
008D59 E8          INX                 INX                 ;     X += 2;
008D5A A0 10 00    LDY #$0010      ++: LDY #$0010          ;     for (Y == 0x0010; Y; Y--) {
008D5D 46 1B       LSR $1B          -: LSR header          ;       header = (A = header) >> 1;
008D5F B0 11       BCS $11             BCS +               ;       if (!(A & 0x0001)) {
008D61 BD 00 00    LDA $0000,X         LDA $0000,X         ;         // Uncompressed byte
008D64 87 13       STA [$13]           STA [to]            ;         *(to++) = *(X++);
008D66 E8          INX                 INX                 ;
008D67 E6 13       INC $13             INC to              ;
008D69 C6 19       DEC $19             DEC bytes           ;         if (--bytes == 0) goto done;
008D6B F0 50       BEQ $50             BEQ +done           ;
008D6D 88          DEY                 DEY                 ;
008D6E D0 ED       BNE $ED             BNE -               ;
008D70 80 C5       BRA $C5             BRA -next           ;       } else {
008D72 84 1D       STY $1D          +: STY index           ;         index = Y;
008D74 BD 00 00    LDA $0000,X         LDA $0000,X         ;         offset = *X & 0x07FF; // Lo 11 bits
008D77 29 FF 07    AND #$07FF          AND #$07FF          ;
008D7A 85 16       STA $16             STA offset          ;         // Decode size (bytes)
008D7C BD 01 00    LDA $0001,X         LDA $0001,X         ;         Y = (*X[1] & 0x00F8) >> 3; // Hi 5 bits
008D7F 29 F8 00    AND #$00F8          AND #$00F8          ;
008D82 4A          LSR A               LSR A               ;
008D83 4A          LSR A               LSR A               ;
008D84 4A          LSR A               LSR A               ;
008D85 A8          TAY                 TAY                 ;         // Decode offset (bytes)
008D86 A5 13       LDA $13             LDA to              ;         offset.lo = to.lo - offset.lo;
008D88 E5 16       SBC $16             SBC offset          ;
008D8A 85 16       STA $16             STA offset          ;
008D8C E8          INX                 INX                 ;         X += 2;
008D8D E8          INX                 INX                 ;         // Copy first byte
008D8E A7 16       LDA [$16]           LDA [offset]        ;         *(to++) = *(offset++); 
008D90 87 13       STA [$13]           STA [to]            ;
008D92 E6 16       INC $16             INC offset          ;
008D94 E6 13       INC $13             INC to              ;
008D96 C6 19       DEC $19             DEC bytes           ;         if (--bytes == 0) goto done;
008D98 F0 23       BEQ $23             BEQ +done           ;         // Copy second byte
008D9A A7 16       LDA [$16]           LDA [offset]        ;         *(to++) = *(offset++);
008D9C 87 13       STA [$13]           STA [to]            ;
008D9E E6 16       INC $16             INC offset          ;
008DA0 E6 13       INC $13             INC to              ;
008DA2 C6 19       DEC $19             DEC bytes           ;         if (--bytes == 0) goto done;
008DA4 F0 17       BEQ $17             BEQ +done           ;         // Copy additional bytes
008DA6 A7 16       LDA [$16]       --: LDA [offset]        ;         do {
008DA8 87 13       STA [$13]           STA [to]            ;           *(to++) = *(offset++);
008DAA E6 16       INC $16             INC offset          ;
008DAC E6 13       INC $13             INC to              ;
008DAE C6 19       DEC $19             DEC bytes           ;           if (--bytes == 0) goto done;
008DB0 F0 0B       BEQ $0B             BEQ +done           ;
008DB2 88          DEY                 DEY                 ;           Y--;
008DB3 10 F1       BPL $F1             BPL --              ;         } while (Y >= 0);
008DB5 A4 1D       LDY $1D             LDY index           ;         Y = index;
008DB7 88          DEY                 DEY                 ;       }
008DB8 D0 A3       BNE $A3             BNE -               ;     }
008DBA 4C 37 8D    JMP $8D37           JMP -next           ;   }
008DBD 68          PLA          +done: PLA                 ; }
008DBE 85 16       STA $16             STA offset          ; // Restore tailing byte
008DC0 E2 20       SEP #$20            SEP #$20            ; done : offset.lo = Pull();
008DC2 68          PLA                 PLA                 ; Sep(0x20);
008DC3 87 16       STA [$16]           STA [offset]        ; *offset = Pull();
008DC5 FA          PLX                 PLX                 ; X = Pull();
008DC6 28          PLP                 PLP                 ; P = Pull();
008DC7 AB          PLB                 PLB                 ; B = Pull();
008DC8 60          RTS                 RTS                 ; return;
                                                           ;}

                                                           ;DecodeCopy (X) {
008DC9 E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
008DCB A0 00 00    LDY #$0000          LDY #$0000          ; Y = 0;
008DCE BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008DD1 97 13       STA [$13],Y         STA [to],Y          ;
008DD3 E8          INX                 INX                 ;
008DD4 C8          INY                 INY                 ;
008DD5 BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008DD8 97 13       STA [$13],Y         STA [to],Y          ;
008DDA E8          INX                 INX                 ;
008DDB C8          INY                 INY                 ;
008DDC BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008DDF 97 13       STA [$13],Y         STA [to],Y          ;
008DE1 E8          INX                 INX                 ;
008DE2 C8          INY                 INY                 ;
008DE3 BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008DE6 97 13       STA [$13],Y         STA [to],Y          ;
008DE8 E8          INX                 INX                 ;
008DE9 C8          INY                 INY                 ;
008DEA BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008DED 97 13       STA [$13],Y         STA [to],Y          ;
008DEF E8          INX                 INX                 ;
008DF0 C8          INY                 INY                 ;
008DF1 BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008DF4 97 13       STA [$13],Y         STA [to],Y          ;
008DF6 E8          INX                 INX                 ;
008DF7 C8          INY                 INY                 ;
008DF8 BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008DFB 97 13       STA [$13],Y         STA [to],Y          ;
008DFD E8          INX                 INX                 ;
008DFE C8          INY                 INY                 ;
008DFF BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008E02 97 13       STA [$13],Y         STA [to],Y          ;
008E04 E8          INX                 INX                 ;
008E05 C8          INY                 INY                 ;
008E06 BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008E09 97 13       STA [$13],Y         STA [to],Y          ;
008E0B E8          INX                 INX                 ;
008E0C C8          INY                 INY                 ;
008E0D BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008E10 97 13       STA [$13],Y         STA [to],Y          ;
008E12 E8          INX                 INX                 ;
008E13 C8          INY                 INY                 ;
008E14 BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008E17 97 13       STA [$13],Y         STA [to],Y          ;
008E19 E8          INX                 INX                 ;
008E1A C8          INY                 INY                 ;
008E1B BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008E1E 97 13       STA [$13],Y         STA [to],Y          ;
008E20 E8          INX                 INX                 ;
008E21 C8          INY                 INY                 ;
008E22 BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008E25 97 13       STA [$13],Y         STA [to],Y          ;
008E27 E8          INX                 INX                 ;
008E28 C8          INY                 INY                 ;
008E29 BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008E2C 97 13       STA [$13],Y         STA [to],Y          ;
008E2E E8          INX                 INX                 ;
008E2F C8          INY                 INY                 ;
008E30 BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008E33 97 13       STA [$13],Y         STA [to],Y          ;
008E35 E8          INX                 INX                 ;
008E36 C8          INY                 INY                 ;
008E37 BD 00 00    LDA $0000,X         LDA $0000,X         ; to[Y++] = *(X++); 
008E3A 97 13       STA [$13],Y         STA [to],Y          ;
008E3C E8          INX                 INX                 ;
008E3D C8          INY                 INY                 ;
008E3E C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
008E40 18          CLC                 CLC                 ; to += 0x0010;
008E41 A5 13       LDA $13             LDA to              ;
008E43 69 10 00    ADC #$0010          ADC #$0010          ;
008E46 85 13       STA $13             STA to              ;
008E48 60          RTS                 RTS                 ; return;
                                                           ;}

// Nmi =========================================================================
                                                           ;NmiVram() {
008E49 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
008E4B A0 00 00    LDY #$0000          LDY #$0000          ; Y = 0x0000;
008E4E AD 22 05    LDA $0522           LDA nmi_vindex      ; if (nmi_vindex) {
008E51 F0 41       BEQ $41             BEQ +done           ;
008E53 B9 24 05    LDA $0524,Y      -: LDA nmi_vdata,Y     ;   while (nmi_vdata[Y] & 0x3FFF) {
008E56 29 FF 3F    AND #$3FFF          AND #$3FFF          ;
008E59 F0 39       BEQ $39             BEQ +done           ;
008E5B AA          TAX                 TAX                 ;     X = nmi_vdata[Y]; // size (words)
008E5C E2 20       SEP #$20            SEP #$20            ;     Sep(0x20);
008E5E A9 80       LDA #$80            LDA #$80            ;     // row
008E60 8D 15 21    STA $2115           STA VMAINC          ;     VMAIN = 0x80; //Step on hi write by 1
008E63 C2 F8       REP #$F8            REP #$F8            ;     Rep(0x20);
008E65 B9 24 05    LDA $0524,Y         LDA nmi_vdata,Y     ;     if (nmi_vdata[Y] & 0x4000) {
008E68 29 00 40    AND #$4000          AND #$4000          ;       // column
008E6B F0 09       BEQ $09             BEQ +               ;
008E6D E2 20       SEP #$20            SEP #$20            ;       Sep(0x20);
008E6F A9 81       LDA #$81            LDA #$81            ;       VMAINC = 0x81; // Step on hi write by 32
008E71 8D 15 21    STA $2115           STA VMAINC          ;
008E74 C2 F8       REP #$F8            REP #$F8            ;       Rep(0xF8);
008E76 B9 24 05    LDA $0524,Y      +: LDA nmi_vdata,Y     ;     }
008E79 0A          ASL A               ASL A               ;     A = nmi_vdata[Y];
008E7A C8          INY                 INY                 ;     Y += 2;
008E7B C8          INY                 INY                 ;
008E7C 90 08       BCC $08             BCC xfer            ;     if (A & 0x8000) {
008E7E B9 24 05    LDA $0524,Y         LDA nmi_vdata,Y     ;       VMADD = nmi_vdata[Y]; // vram address
008E81 8D 16 21    STA $2116           STA VMADD           ;
008E84 C8          INY                 INY                 ;       Y += 2;
008E85 C8          INY                 INY                 ;     }
008E86 B9 24 05    LDA $0524,Y   xfer: LDA nmi_vdata,Y     ;     do {
008E89 8D 18 21    STA $2118           STA VMDATA          ;       VMDATA = nmi_vdata[Y]; // vram data
008E8C C8          INY                 INY                 ;       Y += 2;
008E8D C8          INY                 INY                 ;
008E8E CA          DEX                 DEX                 ;     } while (--X);
008E8F D0 F5       BNE $F5             BNE xfer            ;   }
008E91 4C 53 8E    JMP $8E53           JMP -               ; }
008E94 9C 06 00    STZ $0006    +done: STZ nmi_vram        ; nmi_vram = 0x0000;
008E97 9C 22 05    STZ $0522           STZ nmi_vindex      ; nmi_vindex = 0x0000;
008E9A E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
008E9C 60          RTS                 RTS                 ; return;
                                                           ;}

                                                           ;Nmi() {
008E9D C2 38       REP #$38            REP #$38            ; Rep(0x38);
008E9F 08          PHP                 PHP                 ; Push(P);
008EA0 48          PHA                 PHA                 ; Push(A);
008EA1 DA          PHX                 PHX                 ; Push(X);
008EA2 5A          PHY                 PHY                 ; Push(Y);
008EA3 0B          PHD                 PHD                 ; Push(D);
008EA4 8B          PHB                 PHB                 ; Push(B);
008EA5 D8          CLD                 CLD                 ; Cld();
008EA6 4B          PHK                 PHK                 ; B = K;
008EA7 AB          PLB                 PLB                 ; 
008EA8 E2 30       SEP #$30            SEP #$30            ; Sep(0x30);
008EAA AD 10 42    LDA $4210           LDA RDNMI           ; RDNMI; // reset nmi flag
008EAD A9 8F       LDA #$8F            LDA #$8F            ; INIDISP = #$8F; // blank, full brightness
008EAF 8D 00 21    STA $2100           STA INIDISP         ;
008EB2 9C 0C 42    STZ $420C           STZ HDMAEN          ; HDMAEN = 0x00; // stop hdma processing
008EB5 A9 80       LDA #$80            LDA #$80            ; VMAINC = 0x80; // step on hi write by 1
008EB7 8D 15 21    STA $2115           STA VMAINC          ; // update data
008EBA A5 06       LDA $06             LDA nmi_vram        ; if (nmi_vram) {
008EBC F0 03       BEQ $03             BEQ +               ;
008EBE 20 49 8E    JSR $8E49           JSR NmiVram         ;   NmiVram();
008EC1 A5 00       LDA $00          +: LDA nmi_ready       ; }
008EC3 D0 03       BNE $03             BNE +               ; if (nmi_ready) {
008EC5 4C 75 8F    JMP $8F75           JMP +skip           ;   // update oam
008EC8 C2 F8       REP #$F8         +: REP #$F8            ;   Rep(0xF8);
008ECA E6 02       INC $02             INC nmi_tick        ;   nmi_tick++;
008ECC E2 20       SEP #$20            SEP #$20            ;   Sep(0x20);
008ECE 9C 02 21    STZ $2102           STZ OAMADD.lo       ;   OAMADD = 0x0000; // addr = 0, pri rot off
008ED1 9C 03 21    STZ $2103           STZ OAMADD.hi       ;
008ED4 9C 00 43    STZ $4300           STZ DMAP0           ;   DMAP0 = 0x00; // 1 addr, inc, A->B bus
008ED7 A9 04       LDA #$04            LDA #$04            ;   DMAB0 = 0x04; // OAMDATA
008ED9 8D 01 43    STA $4301           STA DMAB0           ;
008EDC A9 20       LDA #$20            LDA #$20            ;   DMAA0 = 0x000220; // wram
008EDE 8D 02 43    STA $4302           STA DMAA0.lo        ;
008EE1 A9 02       LDA #$02            LDA #$02            ;
008EE3 8D 03 43    STA $4303           STA DMAA0.hi        ;
008EE6 9C 04 43    STZ $4304           STZ DMAA0.bank      ;
008EE9 A9 20       LDA #$20            LDA #$20            ;   DMAD0 = 0x0220; // size
008EEB 8D 05 43    STA $4305           STA DMAD0.lo        ;
008EEE A9 02       LDA #$02            LDA #$02            ;
008EF0 8D 06 43    STA $4306           STA DMAD0.hi        ;
008EF3 A9 01       LDA #$01            LDA #$01            ;   MDMAEN = 0x01; // trigger dma
008EF5 8D 0B 42    STA $420B           STA MDMAEN          ;   // update cgram
008EF8 9C 21 21    STZ $2121           STZ CGADD           ;   CGADD = 0x00;
008EFB 9C 00 43    STZ $4300           STZ DMAP0           ;   DMAP0 = 0x00; // 1 addr, inc, A->B bus
008EFE A9 22       LDA #$22            LDA #$22            ;   DMAB0 = 0x22; // CGDATA
008F00 8D 01 43    STA $4301           STA DMAB0           ;
008F03 A5 EC       LDA $EC             LDA cgselect        ;   if (cgselect & 0x01) {
008F05 6A          ROR A               ROR A               ;
008F06 90 0C       BCC $0C             BCC +               ;
008F08 A9 00       LDA #$00            LDA #$00            ;     DMAA0 = 0x7E2200; // cgram2
008F0A 8D 02 43    STA $4302           STA DMAA0.lo        ;
008F0D A9 22       LDA #$22            LDA #$22            ;
008F0F 8D 03 43    STA $4303           STA DMAA0.hi        ;
008F12 80 0A       BRA $0A             BRA ++              ;   } else {
008F14 A9 00       LDA #$00         +: LDA #$00            ;     DMAA0 = 0x7E2000; // cgram
008F16 8D 02 43    STA $4302           STA DMAA0.lo        ;
008F19 A9 20       LDA #$20            LDA #$20            ;
008F1B 8D 03 43    STA $4303           STA DMAA0.hi        ;
008F1E A9 7E       LDA #$7E        ++: LDA #$7E            ;
008F20 8D 04 43    STA $4304           STA DMAA0.bank      ;   }
008F23 9C 05 43    STZ $4305           STZ DMAD0.lo        ;   DMAD0 = 0x0200; // size
008F26 A9 02       LDA #$02            LDA #$02            ;
008F28 8D 06 43    STA $4306           STA DMAD0.hi        ;
008F2B A9 01       LDA #$01            LDA #$01            ;   
008F2D 8D 0B 42    STA $420B           STA MDMAEN          ;   MDMAEN = 0x01; // trigger dma
008F30 20 F7 89    JSR $89F7           JSR $89F7           ;   $89F7();
008F33 C2 F8       REP #$F8            REP #$F8            ;   Rep(0xF8);
008F35 AF 02 00 7F LDA $7F0002         LDA nmi_bg1v        ;   if (nmi_bg1v) {
008F39 F0 0A       BEQ $0A             BEQ +               ;
008F3B A9 00 00    LDA #$0000          LDA #$0000          ;     nmi_bg1v = 0x0000;
008F3E 8F 02 00 7F STA $7F0002         STA nmi_bg1v        ;
008F42 20 78 FB    JSR $FB78           JSR DmaBg1v         ;     DmaBg1v();
008F45 AF 12 00 7F LDA $7F0012      +: LDA nmi_bg2v        ;   }
008F49 F0 0A       BEQ $0A             BEQ +               ;   if (nmi_bg2v) {
008F4B A9 00 00    LDA #$0000          LDA #$0000          ;     nmi_bg2v = 0x0000;
008F4E 8F 12 00 7F STA $7F0012         STA nmi_bg2v        ;
009F52 20 E5 FB    JSR $FBE5           JSR DmaBg2v         ;     DmaBg2v();
008F55 AF 22 00 7F LDA $7F0022      +: LDA nmi_bg1h        ;   }
008F59 F0 0A       BEQ $0A             BEQ +               ;   if (nmi_bg1h) {
008F5B A9 00 00    LDA #$0000          LDA #$0000          ;     nmi_bg1h = 0x0000;
008F5E 8F 22 00 7F STA $7F0022         STA nmi_bg1h        ;     DmaBg1h();
008F62 20 52 FC    JSR $FC52           JSR DmaBg1h         ;   }
008F65 AF 32 00 7F LDA $7F0032      +: LDA nmi_bg2h        ;   if (nmi_bg2h) {
008F69 F0 0A       BEQ $0A             BEQ +               ;     nmi_bg2h = 0x0000;
008F6B A9 00 00    LDA #$0000          LDA #$0000          ;     DmaBg2h();
008F6E 8F 32 00 7F STA $7F0032         STA nmi_bg2h        ;   }
008F72 20 CE FC    JSR $FCCE           JSR DmaBg2h         ; }
008F75 E2 20       SEP #$20     +skip: SEP #$20            ; // update registers
008F77 A5 20       LDA $20             LDA bg1hofs.lo      ; Sep(0x20);
008F79 8D 50 0A    STA $0A50           STA $0A50           ; BG1HOFS = $0A50 =  bg1hofs;
008F7C 8D 0D 21    STA $210D           STA BG1HOFS         ;
008F7F A5 21       LDA $21             LDA bg1hofs.hi      ;
008F81 8D 51 0A    STA $0A51           STA $0A51           ;
008F84 8D 0D 21    STA $210D           STA BG1HOFS         ;
008F87 A5 22       LDA $22             LDA bg1vofs.lo      ; BG1VOFS = bg1vofs;
008F89 8D 0E 21    STA $210E           STA BG1VOFS         ;
008F8C A5 23       LDA $23             LDA bg1vofs.hi      ;
008F8E 8D 0E 21    STA $210E           STA BG1VOFS         ;
008F91 A5 24       LDA $24             LDA bg2hofs.lo      ; BG2HOFS = bg2hofs;
008F93 8D 0F 21    STA $210F           STA BG2HOFS         ;
008F96 A5 25       LDA $25             LDA bg2hofs.hi      ;
008F98 8D 0F 21    STA $210F           STA BG2HOFS         ;
008F9B A5 26       LDA $26             LDA bg2vofs.lo      ; BG2VOFS = bg2vofs;
008F9D 8D 10 21    STA $2110           STA BG2VOFS         ;
008FA0 A5 27       LDA $27             LDA bg2vofs.hi      ;
008FA2 8D 10 21    STA $2110           STA BG2VOFS         ;
008FA5 A5 28       LDA $28             LDA bg3hofs.lo      ; BG3HOFS = bg3hofs;
008FA7 8D 11 21    STA $2111           STA BG3HOFS         ;
008FAA A5 29       LDA $29             LDA bg3hofs.hi      ;
008FAC 8D 11 21    STA $2111           STA BG3HOFS         ;
008FAF A5 2A       LDA $2A             LDA bg3vofs.lo      ; BG3VOFS = bg3vofs;
008FB1 8D 12 21    STA $2112           STA BG3VOFS         ;
008FB4 A5 2B       LDA $2B             LDA bg3vofs.hi      ;
008FB6 8D 12 21    STA $2112           STA BG3VOFS         ;
008FB9 AD FC 0F    LDA $0FFC           LDA bg4hofs.lo      ; BG4HOFS = bg4hofs;
008FBC 8D 13 21    STA $2113           STA BG4HOFS         ;
008FBF AD FD 0F    LDA $0FFD           LDA bg4hofs.hi      ;
008FC2 8D 13 21    STA $2113           STA BG4HOFS         ;
008FC5 AD FE 0F    LDA $0FFE           LDA bg4vofs.lo      ; BG4VOFS = bg4vofs;
008FC8 8D 14 21    STA $2114           STA BG4VOFS         ;
008FCB AD FF 0F    LDA $0FFF           LDA bg4vofs.hi      ;
008FCE 8D 14 21    STA $2114           STA BG4VOFS         ;
008FD1 A5 2C       LDA $2C             LDA mosaic          ; MOSAIC = mosaic;
008FD3 8D 06 21    STA $2106           STA MOSAIC          ;
008FD6 A5 ED       LDA $ED             LDA hdmaen          ; HDMAEN = hdmaen;
008FD8 8D 0C 42    STA $420C           STA HDMAEN          ;
008FDB C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
008FDD A5 B1       LDA $B1             LDA vtime           ; VTIME = vtime;
008FDF 8D 09 42    STA $4209           STA VTIME           ;
008FE2 A5 B4       LDA $B4             LDA $B4             ; $B8 = $B4;
008FE4 85 B8       STA $B8             STA $B8             ;
008FE6 A5 CA       LDA $CA             LDA cgswsel         ; CGSWSEL = cgswsel;
008FE8 8D 30 21    STA $2130           STA CGSWSEL         ; CGADSUB = cgadsub;
008FEB A5 EE       LDA $EE             LDA tm              ; TM = tm;
008FED 8D 2C 21    STA $212C           STA TM              ; TS = ts;
008FF0 A5 CE       LDA $CE             LDA tmw             ; TMW = tmw;
008FF2 8D 2E 21    STA $212E           STA TMW             ; TSW = tsw;
008FF5 E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
008FF7 64 BA       STZ $BA             STZ $BA             ; $BA = 0x00;
008FF9 AD 00 10    LDA $1000           LDA bgmode          ; if (bgmode == 0x07) {
008FFC C9 07       CMP #$07            CMP #$07            ;
008FFE D0 4B       BNE $4B             BNE +               ;
009000 8D 05 21    STA $2105           STA BGMODE          ;   BGMODE = bgmode;
009003 AD 14 10    LDA $1014           LDA m7a.lo          ;   M7A = m7a;
009006 8D 1B 21    STA $211B           STA M7A             ;
009009 AD 15 10    LDA $1015           LDA m7a.hi          ;
00900C 8D 1B 21    STA $211B           STA M7A             ;
00900F AD 16 10    LDA $1016           LDA m7n.lo          ;   M7B = m7b;
009012 8D 1C 21    STA $211C           STA M7B             ;
009015 AD 17 10    LDA $1017           LDA m7n.hi          ;
009018 8D 1C 21    STA $211C           STA M7B             ;
00901B AD 18 10    LDA $1018           LDA m7c.lo          ;   M7C = m7c;
00901E 8D 1D 21    STA $211D           STA M7C             ;
009021 AD 19 10    LDA $1019           LDA m7c.hi          ;
009024 8D 1D 21    STA $211D           STA M7C             ;
009027 AD 1A 10    LDA $101A           LDA m7d.lo          ;   M7D = m7d;
00902A 8D 1E 21    STA $211E           STA M7D             ;
00902D AD 1B 10    LDA $101B           LDA m7d.hi          ;
009030 8D 1E 21    STA $211E           STA M7D             ;
009033 AD 1C 10    LDA $101C           LDA m7x.lo          ;   M7X = m7x;
009036 8D 1F 21    STA $211F           STA M7X             ;
009039 AD 1D 10    LDA $101D           LDA m7x.hi          ;
00903C 8D 1F 21    STA $211F           STA M7X             ;
00903F AD 1E 10    LDA $101E           LDA m7y.lo          ;   M7Y = m7y;
009042 8D 20 21    STA $2120           STA M7Y             ;
009045 AD 1F 10    LDA $101F           LDA m7y.hi          ;
009048 8D 20 21    STA $2120           STA M7Y             ; }
00904B E2 20       SEP #$20         +: SEP #$20            ; Sep(0x20);
00904D AD 26 0F    LDA $0F26           LDA brightness      ; INIDISP = brightness & 0x0F;
009050 29 0F       AND #$0F            AND #$0F            ;
009052 8D 00 21    STA $2100           STA INIDISP         ;
009055 A5 B0       LDA $B0             LDA vhtimen         ; NMITIMEN = vhtimen | 0x81;
009057 09 81       ORA #$81            ORA #$81            ;
009059 8D 00 42    STA $4200           STA NMITIMEN        ; // refresh apu
00905C A5 F0       LDA $F0             LDA apu_cmd0.lo     ; if ((A.lo = apu_cmd0.lo)
00905E D0 1C       BNE $1C             BNE +               ;
009060 A5 F2       LDA $F2             LDA apu_cmd1.lo     ; || (A.lo = apu_cmd1.lo)
009062 D0 18       BNE $18             BNE +               ;
009064 A5 F4       LDA $F4             LDA apu_cmd2.lo     ; || (A.lo = apu_cmd2.lo)
009066 D0 14       BNE $14             BNE +               ;
009068 A5 F6       LDA $F6             LDA apu_cmd3.lo     ; || (A.lo = apu_cmd3.lo)
00906A D0 10       BNE $10             BNE +               ;
00906C A5 F8       LDA $F8             LDA apu_cmd4.lo     ; || (A.lo = apu_cmd4.lo)
00906E D0 0C       BNE $0C             BNE +               ;
009070 A5 FA       LDA $FA             LDA apu_cmd5.lo     ; || (A.lo = apu_cmd5.lo)
009072 D0 08       BNE $08             BNE +               ;
009074 A5 FC       LDA $FC             LDA apu_cmd6.lo     ; || (A.lo = apu_cmd6.lo)
009076 D0 04       BNE $04             BNE +               ;
009078 A5 FE       LDA $FE             LDA apu_cmd7.lo     ; || (A.lo = apu_cmd7.lo)
00907A F0 1D       BEQ $1D             BNE ++              ; ) {
00907C EB          XBA              +: XBA                 ;
00907D AD 4E 0A    LDA $0A4E           LDA apu_tick        ;   A.hi = apu_tick++;
009080 EE 4E 0A    INC $0A4E           INC apu_tick        ;   Rep(0xF8);
009083 EB          XBA                 XBA                 ;   APUIO2 = A.lo;
009084 C2 F8       REP #$F8            REP #$F8            ;   APUIO3 = A.hi;
009086 8D 42 21    STA $2142           STA APUIO2          ;   apu_cmd0 = 0x0000;
009089 64 F0       STZ $F0             STZ apu_cmd0        ;   apu_cmd1 = 0x0000;
00908B 64 F2       STZ $F2             STZ apu_cmd1        ;   apu_cmd2 = 0x0000;
00908D 64 F4       STZ $F4             STZ apu_cmd2        ;   apu_cmd3 = 0x0000;
00908F 64 F6       STZ $F6             STZ apu_cmd3        ;   apu_cmd4 = 0x0000;
009091 64 F8       STZ $F8             STZ apu_cmd4        ;   apu_cmd5 = 0x0000;
009093 64 FA       STZ $FA             STZ apu_cmd5        ;   apu_cmd6 = 0x0000;
009095 64 FC       STZ $FC             STZ apu_cmd6        ;   apu_cmd7 = 0x0000;
009097 64 FE       STZ $FE             STZ apu_cmd7        ; }
009099 E2 20       SEP #$20        ++: SEP #$20            ; Sep(0x20);
00909B 64 00       STZ $00             STZ nmi_ready       ; nmi_ready = 0x00;
00909D C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00909F AB          PLB                 PLB                 ; B = Pull();
0090A0 2B          PLD                 PLD                 ; D = Pull();
0090A1 7A          PLY                 PLY                 ; Y = Pull();
0090A2 FA          PLX                 PLX                 ; X = Pull();
0090A3 68          PLA                 PLA                 ; A = Pull();
0090A4 28          PLP                 PLP                 ; P = Pull();
0090A5 40          RTI                 RTI                 ; return;
                                                           ;}

// Brk =========================================================================
                                                           ;Brk() {
0090A6 6B          RTL                 RTL                 ; return; // should be RTI
                                                           ;}

// ??? =========================================================================
                                                           ;???() {
0090A7 E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
0090A9 A9 C0       LDA #$C0            LDA #$C0            ; hdmaen &= 0x3F;
0090AB 14 ED       TRB $ED             TRB hdmaen          ;
0090AD 1C 0C 42    TRB $420C           TRB HDMAEN          ; HDMAEN &= 0x3F;
0090B0 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
0090B2 A9 00 00    LDA #$0000          LDA #$0000          ; for (X = 0x0000; X != 0x0400; X += 2) {
0090B5 AA          TAX                 TAX                 ;
0090B6 9D 00 06    STA $0600,X      -: STA $0600,X         ;   $0600[X] = 0x0000;
0090B9 E8          INX                 INX                 ;
0090BA E8          INX                 INX                 ;
0090BB E0 00 04    CPX #$0400          CPX #$0400          ;
0090BE D0 F6       BNE $F6             BNE -               ; }
0090C0 E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
0090C2 A9 80       LDA #$80            LDA #$80            ; hdmaen = 0x80;
0090C4 85 ED       STA $ED             STA hdmaen          ;
0090C6 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
0090C8 60          RTS                 RTS                 ; return;
                                                           ;}

// ...

// Mode ========================================================================
                                                           ;Mode() {
00913D C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00913F A5 04       LDA $04             LDA mode            ; X = (mode & 0x00FF) * 2;
009141 29 FF 00    AND #$00FF          AND #$00FF          ;
009144 0A          ASL A               ASL A               ;
009145 AA          TAX                 TAX                 ;
009146 7C 49 91    JMP ($9149,X)       JMP (modes,X)       ; modes[X]();
                                                           ;}

// modes
009149 CA C6
00914B BB C6
00914D 44 C7 // 0x02 Mode_title
00914F D4 C3
009151 FA C7 // 0x04 Mode_splash
009153 0B C8
009155 0B C8
009157 4E BC
009159 BB C6
00915B FC BD
00915D BB C6
00915F 19 BC
009161 24 A2
009163 C2 A1
009165 00 00
009167 43 B8
009169 BB C6
00916B 4F BA
00916D D6 A3
00916F BB C6
009171 D6 A3
009173 D6 A3
009175 BB C6
009177 D6 A3
009179 48 A2
00917B BB C6
00917D 2F A3
00917F 48 A5
009181 BB C6
009183 49 A6
009185 9B C8 // 0x1E Mode_map
009187 65 C8
009189 CA D2 // 0x20 Mode_game
00918B C0 9A
00918D 4E 9B
00918F C1 9B
009191 00 94
009193 6B 94
009195 97 95
009197 61 96
009199 7C 96
00919B CC 96
00919D CF 96
00919F 0A 97
0091A1 AF 97
0091A3 1D 98
0091A5 20 98
0091A7 B3 98
0091A9 17 99
0091AB 1A 99
0091AD 7F 99
0091AF 82 99
0091B1 85 99
0091B3 8B 99
0091B5 82 99
0091B7 8E 99
0091B9 8B 99
0091BB 82 99
0091BD DB 99
0091BF 8B 99
0091C1 82 99
0091C3 79 9A
0091C5 8B 99
0091C7 D6 A3
0091C9 BB C6
0091CB D6 A3
0091CD BB C6
0091CF CA A5
0091D1 48 A5
0091D3 49 A6 // 0x45 Mode_story
0091D5 BB C6
0091D7 6B B1
0091D9 0E 9C
0091DB F5 9B
0091DD E1 9C
0091DF BD 9D
0091E1 6F 9E
0091E3 46 9F // 0x4D Mode_player_select
0091E5 4C 93
0091E7 6F 93
0091E9 2B 93
0091EB 74 BF
0091ED DF BF
0091EF 3A C3
0091F1 59 92
0091F3 1E 93
0091F5 24 A2
0091F7 34 A2
0091F9 5E C7 // 0x58 Mode_license_load
0091FB BB C6 // 0x59 Mode_license_fade_in
0091FD A6 C7 // 0x5A Mode_license_hold
0091FF BC C7 // 0x5B Mode_license_fade_out

// ...

// ??? =========================================================================
00A08A 85 5A       STA $5A
00A08C 64 4A       STZ $4A
00A08E 60          RTS

// ...

00A0A1 85 9A       STA $9A
00A0A3 64 8A       STZ $8A
00A0A5 60          RTS

// ...

// Decode2Vram =================================================================
                                                           ;Decode2Vram(A, Y) {
00BB33 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00BB35 8D 16 21    STA $2116           STA VMADD           ; VMADD = A; // VRAM address
00BB38 8C 35 43    STY $4335           STY DMAD3           ; DMAD3 = Y; // bytes
00BB3B E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
00BB3D 9C 0C 42    STZ $420C           STZ HDMAEN          ; HDMAEN = 0x00; // Turn off HDMA
00BB40 A9 80       LDA #$80            LDA #$80            ; VMAINC = 0x80; // Increment on write to VMDATA.hi
00BB42 8D 15 21    STA $2115           STA VMAINC          ;
00BB45 A9 01       LDA #$01            LDA #$01            ; DMAP3 = 0x01; // A->B Bus, autoincrement, 2-address
00BB47 8D 30 43    STA $4330           STA DMAP3           ;
00BB4A A9 18       LDA #$18            LDA #$18            ; DMAB3 = 0x18; // B Bus = VMDATA
00BB4C 8D 31 43    STA $4331           STA DMAB3           ;
00BB4F 9C 32 43    STZ $4332           STZ DMAA3.lo        ; DMAA3 = decode_buffer; // 0x7F8000
00BB52 A9 80       LDA #$80            LDA #$80            ;
00BB54 8D 33 43    STA $4333           STA DMAA3.hi        ;
00BB57 A9 7F       LDA #$7F            LDA #$7F            ;
00BB59 8D 34 43    STA $4334           STA DMAA3.bank      ;
00BB5C A9 08       LDA #$08            LDA #$08            ; MDMAEN = 0x08;
00BB5E 8D 0B 42    STA $420B           STA MDMAEN          ;
00BB61 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00BB63 60          RTS                 RTS                 ; return;
                                                           ;}

// ...

// Decode2Cgwram ===============================================================
                                                           ;Decode2Cgwram(){
00BBC5 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00BBC7 A0 00 01    LDY #$0100          LDY #$0100          ;
00BBCA A2 00 00    LDX #$0000          LDX #$0000          ; X = 0x0000;
00BBCD BF 00 80 7F LDA $7F8000,X     -:LDA decode_buffer,X ; for (Y = 0x0100; Y; Y--) {
00BBD1 9F 00 20 7E STA $7E2000,X       STA cgram,X         ;   cgram = decode_buffer[X];
00BBD5 9F 00 22 7E STA $7E2200,X       STA cgram2,X        ;   cgram2 = decode_buffer[X];
00BBD9 E8          INX                 INX                 ;   X += 2;
00BBDA E8          INX                 INX                 ;
00BBDB 88          DEY                 DEY                 ;
00BBDC D0 EF       BNE $EF             BNE -               ; }
00BBDE 60          RTS                 RTS                 ; return;
                                                           ;}

// ...

// EnableNmi ===================================================================
                                                           ;EnableNmi() {
00C418 E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
00C41A AD 26 0F    LDA $0F26           LDA brightness      ; INIDISP = brightness & 0x0F;
00C41D 29 0F       AND #$0F            AND #$0F            ;
00C41F 8D 00 21    STA $2100           STA INIDISP         ; // Nmi, v timer on; h timer, joy read off
00C422 A9 A0       LDA #$A0            LDA #$A0            ; NMITIMEN = 0xA0;
00C424 8D 00 42    STA $4200           STA NMITIMEN        ;
00C427 6B          RTL                 RTL                 ;
                                                           ;}

// DisableNmi ==================================================================
                                                           ;DisableNmi() {
00C428 E2 20       SEP #$20            SEP #$20            ; Sep(0x20);
00C42A 9C 00 42    STZ $4200           STZ NMITIMEN        ; NMITIMEN = 0x00; // NMI, timers, joy read off
00C42D AD 26 0F    LDA $0F26           LDA brightness      ; INIDISP = brightness & 0x0F | 0x80; // Force blank
00C430 29 0F       AND #$0F            AND #$0F            ;
00C432 09 80       ORA #$80            ORA #$80            ;
00C434 8D 00 21    STA $2100           STA INIDISP         ;
00C437 A9 80       LDA #$80            LDA #$80            ; VMAIN = 0x80; // Increment on write to VMDATA.hi
00C439 8D 15 21    STA $2115           STA VMAINC          ;
00C43C A9 00       LDA #$00            LDA #$00            ; nmi_ready = 0x00;
00C43E 85 00       STA $00             STA nmi_ready       ;
00C440 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00C442 6B          RTL                 RTL                 ; return;
                                                           ;}

// ...

// Fade ========================================================================
00C44E 8D 26 0F    STA $0F26        -: STA brightness      ; -: brightness = A;
00C451 A9 02 00    LDA #$0002          LDA #$0002          ;
00C454 8D 20 0F    STA $0F20           STA $0F20           ; $0F20 = 0x0002;
00C457 8D 22 0F    STA $0F22           STA $0F22           ; $0F22 = 0x0002;
00C45A 60          RTS                 RTS                 ; return;

00C45B C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00C45D A9 02 00    LDA #$0002          LDA #$0002          ; $0F24 = 0x0002;
00C460 8D 24 0F    STA $0F24           STA $0F24           ;
00C463 A9 00 00    LDA #$0000          LDA #$0000          ; A = 0;
00C466 F0 E6       BEQ $E6             BEQ -               ; if (A == 0) goto -;

00C468 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00C46A AD 24 0F    LDA $0F24           LDA $0F24           ; if ($0F24 == 0) {
00C46D D0 01       BNE $01             BNE +               ;   return;
00C46F 60          RTS              -: RTS                 ; }
00C470 CE 22 0F    DEC $0F22        +: DEC $0F22           ; if (--$0F22) {
00C473 D0 FA       BNE $FA             BNE -               ;   return;
00C475 AD 20 0F    LDA $0F20           LDA $0F20           ; }
00C478 8D 22 0F    STA $0F22           STA $0F22           ; $0F22 = $0F20;
00C47B AD 24 0F    LDA $0F24           LDA $0F24           ; if ($0F24 != 0x0001) {
00C47E C9 01 00    CMP #$0001          CMP #$0001          ;
00C481 F0 10       BEQ $10             BEQ +               ;
00C483 EE 26 0F    INC $0F26           INC brightness      ;   brightness++;
00C486 AD 26 0F    LDA $0F26           LDA brightness      ;   if (brightness & 0x00FF != 0x000F) {
00C489 29 FF 00    AND #$00FF          AND #$00FF          ;
00C48C C9 0F 00    CMP #$000F          CMP #$000F          ;     return;
00C48F D0 13       BNE $13             BNE +done           ;   }
00C491 F0 0B       BEQ $0B             BEQ ++              ; } else {
00C493 CE 26 0F    DEC $0F26        +: DEC brightness      ;   brightness--;
00C496 AD 26 0F    LDA $0F26           LDA brightness      ;   if (brightness & 0x00FF) {
00C499 29 FF 00    AND #$00FF          AND #$00FF          ;     return;
00C49C D0 06       BNE $06             BNE +done           ;   }
00C49E A9 00 00    LDA #$0000      ++: LDA #$0000          ; }
00C4A1 8D 24 0F    STA $0F24           STA $0F24           ; $0F24 = 0x0000;
00C4A4 60          RTS          +done: RTS                 ; return;

// ...

// 0x?? Mode_fade ==============================================================
                                                           ;Mode_fade() {
00C6BB C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00C6BD 20 68 C4    JSR $C468           JSR $C468           ; $C468();
00C6C0 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00C6C2 AD 24 0F    LDA $0F24           LDA $0F24           ; if ($0F24 == 0) {
00C6C5 D0 02       BNE $02             BNE +               ;   mode++;
00C6C7 E6 04       INC $04             INC mode            ; }
00C6C9 6B          RTL              +: RTL                 ; return;
                                                           ;}

// ...

// 0x58 Mode_license_load ======================================================
                                                           ;ModeLicenseLoad() {
00C75E C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00C760 22 28 C4 00 JSL $00C428         JSL DisableNmi      ; DisableNmi();
00C764 A9 00 00    LDA #$0000          LDA #$0000          ; DecodeBg3(0x0000); // Bg3 screen
00C767 20 72 8C    JSR $8C72           JSR DecodeBg3       ;
00C76A A0 13 14    LDY #$1413          LDY #$1413          ; Decode_l(0x1413); // Palette
00C76D 22 BD 8C 00 JSL $008CBD         JSL Decode_l        ;
00C771 20 C5 BB    JSR $BBC5           JSR Decode2Cgwram   ; Decode2Cgwram();
00C774 A0 14 14    LDY #$1414          LDY #$1414          ; Decode(0x1414); // Bg3 screen
00C777 20 B8 8C    JSR $8CB8           JSR Decode          ;
00C77A A0 00 08    LDY #$0800          LDY #$0800          ; Decode2Vram(0x0800, 0x5800);
00C77D A9 00 58    LDA #$5800          LDA #$5800          ;
00C780 20 33 BB    JSR $BB33           JSR Decode2Vram     ;
00C783 A0 0B 1A    LDY #$1A0B          LDY #$1A0B          ; Decode(0x1A0B); // Bg3 characters
00C786 20 B8 8C    JSR $8CB8           JSR Decode          ;
00C789 A0 00 10    LDY #$1000          LDY #$1000          ; Decode2Vram(0x1000, 0x5000);
00C78C A9 00 50    LDA #$5000          LDA #$5000          ;
00C78F 20 33 BB    JSR $BB33           JSR Decode2Vram     ;
00C792 20 5B C4    JSR $C45B           JSR $C45B           ; $C45B();
00C795 A9 04 04    LDA #$0404          LDA #$0404          ; tm = 0x04;
00C798 85 EE       STA $EE             STA tm              ; ts = 0x04;
00C79A 9C 00 0F    STZ $0F00           STZ $0F00           ; $0F00 = 0x0000;
00C79D E6 04       INC $04             INC mode            ; mode++;
00C79F 22 18 C4 00 JSL $00C418         JSL EnableNmi       ; EnableNmi();
00C7A3 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
00C7A5 6B          RTL                 RTL                 ; return;
                                                           ;}

// ...

// ??? =========================================================================
00FB78 E2 20       SEP #$20
00FB7A 9C 0C 42    STZ $420C
00FB7D A9 80       LDA #$80
00FB7F 8D 15 21    STA $2115
00FB82 C2 F8       REP #$F8
00FB84 A9 01 18    LDA #$1801
00FB87 8D 40 43    STA $4340
00FB8A AF 40 00 7F LDA $7F0040
00FB8E 8D 16 21    STA $2116
00FB91 AF 44 00 7F LDA $7F0044
00FB95 8D 42 43    STA $4342
00FB98 A9 40 00    LDA #$0040
00FB9B 8D 45 43    STA $4345
00FB9E E2 20       SEP #$20
00FBA0 A9 7E       LDA #$7E
00FBA2 8D 44 43    STA $4344
00FBA5 A9 10       LDA #$10
00FBA7 8D 0B 42    STA $420B 
00FBAA 9C 0C 42    STZ $420C
00FBAD A9 80       LDA #$80
00FBAF 8D 15 21    STA $2115
00FBB2 C2 F8       REP #$F8
00FBB4 A9 01 18    LDA #$1801
00FBB7 8D 40 43    STA $4340
00FBBA 18          CLC
00FBBB AF 40 00 7F LDA $7F0040
00FBBF 69 00 04    ADC #$0400
00FBC2 8D 16 21    STA $2116
00FBC5 18          CLC
00FBC6 AF 44 00 7F LDA $7F0044
00FBCA 69 00 08    ADC #$0800
00FBCD 8D 42 43    STA $4342
00FBD0 A9 40 00    LDA #$0040
00FBD3 8D 45 43    STA $4345
00FBD6 E2 20       SEP #$20
00FBD8 A9 7E       LDA #$7E
00FBDA 8D 44 43    STA $4344
00FBDD A9 10       LDA #$10
00FBDF 8D 0B 42    STA $420B
00FBE2 4C 47 FD    JMP $FD47

00FBE5 E2 20       SEP #$20
00FBE7 9C 0C 42    STZ $420C
00FBEA A9 80       LDA #$80
00FBEC 8D 15 21    STA $2115
00FBEF C2 F8       REP #$F8
00FBF1 A9 01 18    LDA #$1801
00FBF4 8D 40 43    STA $4340
00FBF7 AF 48 00 7F LDA $7F0048
00FBFB 8D 16 21    STA $2116
00FBFE AF 4C 00 7F LDA $7F004C
00FC02 8D 42 43    STA $4342
00FC05 A9 40 00    LDA #$0040
00FC08 8D 45 43    STA $4345
00FC0B E2 20       SEP #$20
00FC0D A9 7E       LDA #$7E
00FC0F 8D 44 43    STA $4344
00FC12 A9 10       LDA #$10
00FC14 8D 0B 42    STA $420B
00FC17 9C 0C 42    STZ $420C
00FC1A A9 80       LDA #$80
00FC1C 8D 15 21    STA $2115
00FC1F C2 F8       REP #$F8
00FC21 A9 01 18    LDA #$1801
00FC24 8D 40 43    STA $4340
00FC27 18          CLC 
00FC28 AF 48 00 7F LDA $7F0048
00FC2C 69 00 04    ADC #$0400
00FC2F 8D 16 21    STA $2116
00FC32 18          CLC
00FC33 AF 4C 00 7F LDA $7F004C
00FC37 69 00 08    ADC #$0800
00FC3A 8D 42 43    STA $4342
00FC3D A9 40 00    LDA #$0040
00FC40 8D 45 43    STA $4345
00FC43 E2 20       SEP #$20
00FC45 A9 7E       LDA #$7E
00FC47 8D 44 43    STA $4344
00FC4A A9 10       LDA #$10
00FC4C 8D 0B 42    STA $420B
00FC4F 4C 47 FD    JMP $FD47

00FC52 E2 20       SEP #$20
00FC54 A9 81       LDA #$81
00FC56 8D 15 21    STA $2115
00FC59 C2 F8       REP #$F8
00FC5B AF 42 00 7F LDA $7F0042
00FC5F 8D 16 21    STA $2116
00FC62 AF 46 00 7F LDA $7F0046
00FC66 AA          TAX
00FC67 A0 08 00    LDY #$0008
00FC6A BF 00 00 7E LDA $7E0000,X
00FC6E 8D 18 21    STA $2118
00FC71 BF 40 00 7E LDA $7E0040,X
00FC75 8D 18 21    STA $2118
00FC78 BF 80 00 7E LDA $7E0080,X
00FC7C 8D 18 21    STA $2118
00FC7F BF C0 00 7E LDA $7E00C0,X
00FC83 8D 18 21    STA $2118
00FC86 18          CLC
00FC87 8A          TXA
00FC88 69 00 01    ADC #$0100
00FC8B AA          TAX
00FC8C 88          DEY
00FC8D D0 DB       BNE $DB    [$FC6A]
00FC8F 18          CLC
00FC90 AF 42 00 7F LDA $7F0042
00FC94 69 00 08    ADC #$0800
00FC97 8D 16 21    STA $2116
00FC9A 18          CLC
00FC9B AF 46 00 7F LDA $7F0046
00FC9F 69 00 10    ADC #$1000
00FCA2 AA          TAX
00FCA3 A0 08 00    LDY #$0008
00FCA6 BF 00 00 7E LDA $7E0000,X
00FCAA 8D 18 21    STA $2118
00FCAD BF 40 00 7E LDA $7E0040,X
00FCB1 8D 18 21    STA $2118
00FCB4 BF 80 00 7E LDA $7E0080,X
00FCB8 8D 18 21    STA $2118
00FCBB BF C0 00 7E LDA $7E00C0,X
00FCBF 8D 18 21    STA $2118
00FCC2 18          CLC
00FCC3 8A          TXA
00FCC4 69 00 01    ADC #$0100
00FCC7 AA          TAX
00FCC8 88          DEY
00FCC9 D0 DB       BNE $DB    [$FCA6]
00FCCB 4C 47 FD    JMP $FD47

00FCCE E2 20       SEP #$20
00FCD0 A9 81       LDA #$81
00FCD2 8D 15 21    STA $2115
00FCD5 C2 F8       REP #$F8
00FCD7 AF 4A 00 7F LDA $7F004A
00FCDB 8D 16 21    STA $2116
00FCDE AF 4E 00 7F LDA $7F004E
00FCE2 AA          TAX
00FCE3 A0 08 00    LDY #$0008
00FCE6 BF 00 00 7E LDA $7E0000,X
00FCEA 8D 18 21    STA $2118
00FCED BF 40 00 7E LDA $7E0040,X
00FCF1 8D 18 21    STA $2118
00FCF4 BF 80 00 7E LDA $7E0080,X
00FCF8 8D 18 21    STA $2118
00FCFB BF C0 00 7E LDA $7E00C0,X
00FCFF 8D 18 21    STA $2118
00FD02 18          CLC
00FD03 8A          TXA
00FD04 69 00 01    ADC #$0100
00FD07 AA          TAX
00FD08 88          DEY
00FD09 D0 DB       BNE $DB    [$FCE6]
00FD0B 18          CLC
00FD0C AF 4A 00 7F LDA $7F004A
00FD10 69 00 08    ADC #$0800
00FD13 8D 16 21    STA $2116
00FD16 18          CLC
00FD17 AF 4E 00 7F LDA $7F004E
00FD1B 69 00 10    ADC #$1000
00FD1E AA          TAX
00FD1F A0 08 00    LDY #$0008
00FD22 BF 00 00 7E LDA $7E0000,X
00FD26 8D 18 21    STA $2118
00FD29 BF 40 00 7E LDA $7E0040,X
00FD2D 8D 18 21    STA $2118
00FD30 BF 80 00 7E LDA $7E0080,X
00FD34 8D 18 21    STA $2118
00FD37 BF C0 00 7E LDA $7E00C0,X
00FD3B 8D 18 21    STA $2118
00FD3E 18          CLC
00FD3F 8A          TXA
00FD40 69 00 01    ADC #$0100
00FD43 AA          TAX
00FD44 88          DEY
00FD45 D0 DB       BNE $DB    [$FD22]

00FD47 C2 F8       REP #$F8
00FD49 A9 00 80    LDA #$8000
00FD4C 0C 32 0F    TSB $0F32
00FD4F 60          RTS

// ...

// rom_header
00FFC0 50 4F 43 4B 59 20 52 4F 43 4B 59 20 20 20 20 20
00FFD0 20 20 20 20 20 20 00 0A 00 01 E9 00 03 53 FC AC

// vector_table
// Native    mode : --- --- COP, BRK, ABT, NMI, ---, IRQ
// Emulation mode : --- --- COP, ---, ABT, NMI, RST, IRQ
00FFE0 00 00 00 00 00 00 A6 90 00 00 9D 8E 00 80 F7 81
00FFF0 00 00 00 00 00 00 00 00 00 00 9D 8E 00 80 F7 81



//==============================================================================
// Bank 0x02
//==============================================================================

// DecodeBg3 ===================================================================
                                       $10 word from
                                       $12 word from2
                                       $14 word bytes
                                                           ;DecodeBg3_l(A) {
02B006 C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
02B008 8B          PHB                 PHB                 ; Push(B);
02B009 4B          PHK                 PHK                 ; B = K;
02B00A AB          PLB                 PLB                 ;
02B00B 20 A3 B7    JSR $B7A3           JSR DecodeBg3Map    ; DecodeBg3Map(A);
02B00E C2 F8       REP #$F8            REP #$F8            ; Rep(0xF8);
02B010 AB          PLB                 PLB                 ; B = Pull();
02B011 6B          RTL                 RTL                 ; return;
                                                           ;}

                                                           ;DecodeBg3Horz() {
02B012 A9 80 00    LDA #$0080          LDA #$0080          ; VMAIN = 0x80; // Increment on hi by 1
02B015 8D 15 21    STA $2115           STA VMAINC          ;
02B018 60          RTS                 RTS                 ; return;
                                                           ;}

                                                           ;DecodeBg3Vert() {
02B019 A9 81 00    LDA #$0081          LDA #$0081          ; VMAIN = 0x81; // Increment on hi by 32
02B01C 8D 15 21    STA $2115           STA VMAINC          ;
02B01F 60          RTS                 RTS                 ; return;
                                                           ;}

                                                           ;DecodeBg3Loop() {
02B020 20 12 B0    JSR $B012    -loop: JSR DecodeBg3Horz   ; for (;;) {
02B023 A0 00 00    LDY #$0000          LDY #$0000          ;   DecodeBg3Horz();
02B026 B1 10       LDA ($10),Y         LDA (from,Y)        ;   X = *from;
02B028 AA          TAX                 TAX                 ;
02B029 10 03       BPL $03             BPL +               ;   if (X < 0) {
02B02B 20 19 B0    JSR $B019           JSR DecodeBg3Vert   ;     DecodeBg3Vert();
02B02E A9 02 00    LDA #$0002       +: LDA #$0002          ;   }
02B031 20 E7 B0    JSR $B0E7           JSR DecodeBg3Inc    ;   DecodeBg3Inc(0x0002);
02B034 8A          TXA                 TXA                 ;   if (X & 0x4000) {
02B035 29 00 40    AND #$4000          AND #$4000          ;     // Set address
02B038 F0 0B       BEQ $0B             BEQ +               ;
02B03A B1 10       LDA ($10),Y         LDA (from),Y        ;     VMADD = *from;
02B03C 8D 16 21    STA $2116           STA VMADD           ;
02B03F A9 02 00    LDA #$0002          LDA #$0002          ;     DecodeBg3Inc(0x0002);
02B042 20 E7 B0    JSR $B0E7           JSR DecodeBg3Inc    ;   }
02B045 8A          TXA              +: TXA                 ;   if (X & 0x2000) {
02B046 29 00 20    AND #$2000          AND #$2000          ;     // +a, Copy indirect
02B049 D0 68       BNE $68             BNE +a              ;
02B04B 8A          TXA                 TXA                 ;   } else if(X & 0x1000) {
02B04C 29 00 10    AND #$1000          AND #$1000          ;     // +b, Copy repeat
02B04F D0 30       BNE $30             BNE +b              ;
02B051 8A          TXA                 TXA                 ;   } else if(X & 0x0800) {
02B052 29 00 08    AND #$0800          AND #$0800          ;     // +c, Copy series
02B055 D0 07       BNE $07             BNE +c              ;
02B057 8A          TXA                 TXA                 ;   } else if(X & 0x0FFF) {
02B058 29 FF 0F    AND #$0FFF          AND #$0FFF          ;     // +d, Copy words
02B05B D0 41       BNE $41             BNE +d              ;   } else {
02B05D 60          RTS                 RTS                 ;     return;
02B05E 8A          TXA             +c: TXA                 ;   }
02B05F 29 FF 07    AND #$07FF          AND #$07FF          ; }
02B062 8D 14 00    STA $0014           STA bytes           ;}
02B065 A0 00 00    LDY #$0000          LDY #$0000          ; // +c , Copy series
02B068 A2 00 00    LDX #$0000          LDX #$0000          ; bytes = X & 0x07FF;
02B06B 18          CLC              -: CLC                 ; X = 0;
02B06C 8A          TXA                 TXA                 ; do {
02B06D 71 10       ADC ($10),Y         ADC (from),Y        ;   VMDATA = X + *from;
02B06F 8D 18 21    STA $2118           STA VMDATA          ;
02B072 E8          INX                 INX                 ;   X++;
02B073 CE 14 00    DEC $0014           DEC bytes           ; } while (--bytes);
02B076 D0 F3       BNE $F3             BNE -               ;
02B078 A9 02 00    LDA #$0002          LDA #$0002          ; DecodeBg3Inc(0x0002);
02B07B 20 E7 B0    JSR $B0E7           JSR DecodeBg3Inc    ;
02B07E 4C 20 B0    JMP $B020           JMP -loop           ; // +b, Copy repeat
02B081 8A          TXA             +b: TXA                 ; bytes = X & 0x07FF;
02B082 29 FF 07    AND #$07FF          AND #$07FF          ;
02B085 8D 14 00    STA $0014           STA bytes           ;
02B088 A0 00 00    LDY #$0000          LDY #$0000          ; do {
02B08B B1 10       LDA ($10),Y      -: LDA (from),Y        ;   VMDATA = *from;
02B08D 8D 18 21    STA $2118           STA VMDATA          ;
02B090 CE 14 00    DEC $0014           DEC bytes           ; } while (--bytes);
02B093 D0 F6       BNE $F6             BNE -               ;
02B095 A9 02 00    LDA #$0002          LDA #$0002          ; DecodeBg3Inc(0x0002);
02B098 20 E7 B0    JSR $B0E7           JSR DecodeBg3Inc    ;
02B09B 4C 20 B0    JMP $B020           JMP -loop           ; // +d, Copy words
02B09E 8D 14 00    STA $0014       +d: STA bytes           ; bytes = A;
02B0A1 AD 10 00    LDA $0010           LDA from            ; from2 = from;
02B0A4 8D 12 00    STA $0012           STA from2           ;
02B0A7 20 D3 B0    JSR $B0D3           JSR DecodeBg3Copy   ; DecodeBg3Copy(from2, bytes);
02B0AA AD 12 00    LDA $0012           LDA from2           ; from = from2;
02B0AD 8D 10 00    STA $0010           STA from            ;
02B0B0 4C 20 B0    JMP $B020           JMP -loop           ; // +a, Copy indirect
02B0B3 8A          TXA             +a: TXA                 ; X = (X & 0x07FF) * 2;
02B0B4 29 FF 07    AND #$07FF          AND #$07FF          ;
02B0B7 0A          ASL A               ASL A               ;
02B0B8 AA          TAX                 TAX                 ;
02B0B9 BD F7 B0    LDA $B0F7,X         LDA bg3indirect,X   ; from2 = bg3indirect[X];
02B0BC 8D 12 00    STA $0012           STA from2           ;
02B0BF A0 00 00    LDY #$0000          LDY #$0000          ; bytes = *from2;
02B0C2 B1 12       LDA ($12),Y         LDA (from2),Y       ;
02B0C4 8D 14 00    STA $0014           STA bytes           ;
02B0C7 A9 02 00    LDA #$0002          LDA #$0002          ; DecodeBg3Inc2(0x0002);
02B0CA 20 EF B0    JSR $B0EF           JSR DecodeBg3Inc2   ;
02B0CD 20 D3 B0    JSR $B0D3           JSR DecodeBg3Copy   ; DecodeBg3Copy();
02B0D0 4C 20 B0    JMP $B020           JMP -loop           ;
                                                           ;}

                                                           ;DecodeBg3Copy() {
02B0D3 A0 00 00    LDY #$0000          LDY #$0000          ; do {
02B0D6 B1 12       LDA ($12),Y       -:LDA (from2),Y       ;   VMDATA = *from2;
02B0D8 8D 18 21    STA $2118           STA VMDATA          ;
02B0DB A9 02 00    LDA #$0002          LDA #$0002          ;   DecodeBg3Inc2(0x0002);
02B0DE 20 EF B0    JSR $B0EF           JSR $B0EF           ;
02B0E1 CE 14 00    DEC $0014           DEC bytes           ; } while (--bytes);
02B0E4 D0 F0       BNE $F0             BNE -               ;
02B0E6 60          RTS                 RTS                 ; return;
                                                           ;}

                                                           ;DecodeBg3Inc(A) {
02B0E7 18          CLC                 CLC                 ; from += A;
02B0E8 6D 10 00    ADC $0010           ADC from            ;
02B0EB 8D 10 00    STA $0010           STA from            ;
02B0EE 60          RTS                 RTS                 ; return;
                                                           ;}

                                                           ;DecodeBg3Inc2(A) {
02B0EF 18          CLC                 CLC                 ; from2 += A;
02B0F0 6D 12 00    ADC $0012           ADC from2           ;
02B0F3 8D 12 00    STA $0012           STA from2           ;
02B0F6 60          RTS                 RTS                 ; return;
                                                           ;}

// bg3indirect, encoded bg3 indirect "table"
02B0F7 F9 B0

// Encoded bg3 maps
02B0F9                            10 48 08 30 00 00 10
02B100 48 28 30 10 00 10 48 48 30 20 00 10 48 68 30 30
02B110 00 10 48 88 30 40 00 10 48 A8 30 50 00 10 48 C8
02B120 30 60 00 10 48 E8 30 70 00 10 48 08 31 80 00 10
02B130 48 28 31 90 00 10 48 48 31 A0 00 10 48 68 31 B0
02B140 00 10 48 88 31 C0 00 10 48 A8 31 D0 00 10 48 C8
02B150 31 E0 00 10 48 E8 31 F0 00 10 48 08 32 00 01 10
02B160 48 28 32 10 01 10 48 48 32 20 01 10 48 68 32 30
02B170 01 10 48 88 32 40 01 10 48 A8 32 50 01 10 48 C8
02B180 32 60 01 10 48 E8 32 70 01 10 48 08 33 80 01 10
02B190 48 28 33 90 01 10 48 48 33 A0 01 10 48 68 33 B0
02B1A0 01 10 48 88 33 C0 01 10 48 A8 33 D0 01 10 48 C8
02B1B0 33 E0 01 10 48 E8 33 F0 01 00 00

02B1BB                                  10 48 08 5C 00
02B1C0 00 10 48 28 5C 10 00 10 48 48 5C 20 00 10 48 68
02B1D0 5C 30 00 10 48 88 5C 40 00 10 48 A8 5C 50 00 10
02B1E0 48 C8 5C 60 00 10 48 E8 5C 70 00 10 48 08 5D 80
02B1F0 00 10 48 28 5D 90 00 10 48 48 5D A0 00 10 48 68
02B200 5D B0 00 10 48 88 5D C0 00 10 48 A8 5D D0 00 10
02B210 48 C8 5D E0 00 10 48 E8 5D F0 00 10 48 08 5A 00
02B220 01 10 48 28 5A 10 01 10 48 48 5A 20 01 10 48 68
02B230 5A 30 01 10 48 88 5A 40 01 10 48 A8 5A 50 01 10
02B240 48 C8 5A 60 01 10 48 E8 5A 70 01 10 48 08 5B 80
02B250 01 10 48 28 5B 90 01 10 48 48 5B A0 01 10 48 68
02B260 5B B0 01 10 48 88 5B C0 01 10 48 A8 5B D0 01 10
02B270 48 C8 5B E0 01 10 48 E8 5B F0 01 00 00

02B27D                                        00 54 00
02B280 58 00 00 00 54 00 40 00 00 00 54 00 30 00 00 10
02B290 40 C8 58 30 20 31 20 32 20 33 20 34 20 35 20 36
02B2A0 20 37 20 38 20 39 20 41 20 42 20 43 20 44 20 45
02B2B0 20 46 20 10 D0 04 5C 30 20 10 D0 04 5E 31 20 10
02B2C0 C0 05 5C 30 20 31 20 32 20 33 20 34 20 35 20 36
02B2D0 20 37 20 38 20 39 20 41 20 42 20 43 20 44 20 45
02B2E0 20 46 20 10 C0 05 5E 30 20 31 20 32 20 33 20 34
02B2F0 20 35 20 36 20 37 20 38 20 39 20 41 20 42 20 43
02B300 20 44 20 45 20 46 20 20 D0 06 5C 30 20 04 40 70
02B310 58 42 20 41 20 4E 20 4B 20 05 40 90 58 50 20 41
02B320 20 4C 20 45 20 54 20 07 40 45 58 42 20 47 20 00
02B330 20 54 20 45 20 53 20 54 20 00 00

02B33B                                  0C 40 AB 58 4B
02B340 1C 49 1C 4B 1C 49 1C 00 1C 4B 1C 41 1C 49 1C 4B
02B350 1C 41 1C 49 1C 32 1C 06 40 2E 59 53 1C 41 1C 4D
02B360 1C 50 1C 4C 1C 45 1C 05 40 8E 5A 53 1C 54 1C 41
02B370 1C 52 1C 54 1C 06 40 CE 5A 4F 1C 50 1C 54 1C 49
02B380 1C 4F 1C 4E 1C 0D 40 0A 5B 31 1C 39 1C 39 1C 32
02B390 1C 00 1C 00 1C 4E 1C 41 1C 54 1C 53 1C 55 1C 4D
02B3A0 1C 45 1C 00 00

02B3A5                00 54 00 58 00 00 09 40 4B 58 54
02B3B0 1C 45 1C 53 1C 54 1C 00 1C 4D 1C 4F 1C 44 1C 45
02B3C0 1C 09 40 CB 58 42 1C 41 1C 4E 1C 4B 1C 00 1C 54
02B3D0 1C 45 1C 53 1C 54 1C 0A 40 0B 59 42 1C 41 1C 4E
02B3E0 1C 4B 1C 00 1C 54 1C 45 1C 53 1C 54 1C 32 1C 0C
02B3F0 40 4B 59 50 1C 49 1C 43 1C 54 1C 55 1C 52 1C 45
02B400 1C 00 1C 54 1C 45 1C 53 1C 54 1C 09 40 8B 59 44
02B410 1C 45 1C 4D 1C 4F 1C 00 1C 54 1C 45 1C 53 1C 54
02B420 1C 0B 40 CB 59 50 1C 4C 1C 41 1C 59 1C 45 1C 52
02B430 1C 00 1C 54 1C 45 1C 53 1C 54 1C 08 40 0B 5A 4D
02B440 1C 41 1C 50 1C 00 1C 54 1C 45 1C 53 1C 54 1C 0A
02B450 40 4B 5A 50 1C 41 1C 4E 1C 45 1C 4C 1C 00 1C 54
02B460 1C 45 1C 53 1C 54 1C 03 40 8B 5A 45 1C 4E 1C 44
02B470 1C 00 00

02B473          00 54 00 58 00 00 0A 40 6B 58 44 1C 45
02B480 C0 4D C0 4F C0 00 C0 00 C0 54 C0 35 C0 53 C0 54
02B490 C0 08 40 CC 58 4F 1C 50 C0 45 C0 4E C0 4E C0 49
02B4A0 C0 4E C0 47 C0 09 40 0C 59 53 1C 54 C0 31 C0 00
02B4B0 C0 43 C0 4C C0 45 C0 41 C0 52 C0 09 40 4C 59 53
02B4C0 1C 54 C0 32 C0 00 C0 43 C0 4C C0 45 C0 41 C0 52
02B4D0 C0 09 40 8C 59 53 1C 54 C0 33 C0 00 C0 43 C0 4C
02B4E0 C0 45 C0 41 C0 52 C0 09 40 CC 59 53 1C 54 C0 34
02B4F0 C0 00 C0 43 C0 4C C0 45 C0 41 C0 52 C0 09 40 0C
02B500 5A 53 1C 54 C0 35 C0 00 C0 43 C0 4C C0 45 C0 41
02B510 C0 52 C0 09 40 4C 5A 53 1C 54 C0 36 C0 00 C0 43
02B520 C0 4C C0 45 C0 41 C0 52 C0 06 40 8C 5A 45 1C 4E
02B530 C0 44 C0 49 C0 4E C0 47 C0 00 00

02B53B                                  02 40 68 58 31
02B540 1C 50 1C 04 40 C4 58 42 1C 41 1C 4E 1C 4B 1C 08
02B550 40 06 59 30 20 31 20 32 20 33 20 34 20 35 20 36
02B560 20 37 20 04 C0 44 59 30 20 31 20 32 20 33 20 08
02B570 40 46 31 10 1C 11 1C 12 1C 13 1C 14 1C 15 1C 16
02B580 1C 17 1C 08 40 66 31 20 1C 21 1C 22 1C 23 1C 24
02B590 1C 25 1C 26 1C 27 1C 08 40 86 31 30 1C 31 1C 32
02B5A0 1C 33 1C 34 1C 35 1C 36 1C 37 1C 08 40 A6 31 40
02B5B0 1C 41 1C 42 1C 43 1C 44 1C 45 1C 46 1C 47 1C 02
02B5C0 40 76 58 32 1C 50 1C 04 40 D2 58 42 1C 41 1C 4E
02B5D0 1C 4B 1C 08 40 14 59 30 20 31 20 32 20 33 20 34
02B5E0 20 35 20 36 20 37 20 04 C0 52 59 30 20 31 20 32
02B5F0 20 33 20 08 40 54 31 18 1C 19 1C 1A 1C 1B 1C 1C
02B600 1C 1D 1C 1E 1C 1F 1C 08 40 74 31 28 1C 29 1C 2A
02B610 1C 2B 1C 2C 1C 2D 1C 2E 1C 2F 1C 08 40 94 31 38
02B620 1C 39 1C 3A 1C 3B 1C 3C 1C 3D 1C 3E 1C 3F 1C 08
02B630 40 B4 31 48 1C 49 1C 4A 1C 4B 1C 4C 1C 4D 1C 4E
02B640 1C 4F 1C 00 00

02B645                08 40 68 58 4F 1C 42 1C 4A 1C 00
02B650 1C 54 1C 45 1C 53 1C 54 1C 02 40 B1 58 4F 1C 4F
02B660 1C 00 00

02B663          07 40 AA 58 53 1C 54 1C 41 1C 47 1C 45
02B670 1C 00 1C 30 1C 07 40 CA 58 53 1C 54 1C 41 1C 47
02B680 1C 45 1C 00 1C 31 1C 07 40 EA 58 53 1C 54 1C 41
02B690 1C 47 1C 45 1C 00 1C 32 1C 07 40 0A 59 53 1C 54
02B6A0 1C 41 1C 47 1C 45 1C 00 1C 33 1C 07 40 2A 59 53
02B6B0 1C 54 1C 41 1C 47 1C 45 1C 00 1C 34 1C 07 40 4A
02B6C0 59 53 1C 54 1C 41 1C 47 1C 45 1C 00 1C 35 1C 07
02B6D0 40 6A 59 53 1C 54 1C 41 1C 47 1C 45 1C 00 1C 36
02B6E0 1C 07 40 8A 59 53 1C 54 1C 41 1C 47 1C 45 1C 00
02B6F0 1C 37 1C 00 00

02B6F5                00 54 00 58 00 00 0D 40 6A 58 50
02B700 1C 4C 1C 41 1C 59 1C 45 1C 52 1C 00 1C 53 1C 45
02B710 1C 4C 1C 45 1C 43 1C 54 1C 00 00

02B71B                                  00 54 00 58 00
02B720 00 08 40 6A 58 43 1C 4F 1C 4E 1C 54 1C 49 1C 4E
02B730 1C 55 1C 45 1C 00 00

02B737                      00 54 00 58 00 00 00 54 00
02B740 5C 00 00 00 54 00 40 00 00 00 54 00 44 00 00 00
02B750 54 00 48 00 00 00 54 00 4C 00 00 00 54 00 30 00
02B760 00 00 54 00 34 00 00 00 54 00 38 00 00 00 54 00
02B770 3C 00 00 00 00 0A AA BD A3 B7 8D 10 00 A0 00 00
02B780 B1 10 29 FF 3F AA B1 10 10 02 E8 E8 E8 B1 10 99
02B790 24 05 C8 C8 CA D0 F6 8A 99 24 05 CA 8E 22 05 8E
02B7A0 20 05 60

                                                           ;DecodeBg3Map(A) {
02B7A3 C2 F8       REP #$F8            REP #$F8            ; from = bg3maps[A * 2];
02B7A5 0A          ASL A               ASL                 ;
02B7A6 AA          TAX                 TAX                 ;
02B7A7 BD B0 B7    LDA $B7B0,X         LDA bg3maps,X       ;
02B7AA 8D 10 00    STA $0010           STA from            ;
02B7AD 4C 20 B0    JMP $B020           JMP -loop           ; goto -loop;
                                                           ;}

// bg3maps, encoded bg3 map addresses
02B7B0 37 B7
02B7B2 BB B1
02B7B4 3B B3
02B7B6 A5 B3
02B7B8 7D B2
02B7BA F9 B0
02B7BC 3B B5
02B7BE 45 B6
02B7C0 63 B6
02B7C2 73 B4
02B7C4 F5 B6
02B7C6 1B B7

// ...

// ??? =========================================================================
02D831 08          PHP
02D832 8B          PHB
02D833 4B          PHK
02D834 AB          PLB
02D835 A2 00 00    LDX #$0000
02D838 BD 78 D8    LDA $D878,X
02D83B 9D 68 0A    STA $0A68,X
02D83E 9D 80 0A    STA $0A80,X
02D841 E8          INX
02D842 E8          INX
02D843 E0 18 00    CPX #$0018
02D846 D0 F0       BNE $F0    [$D838]
02D848 A9 00 00    LDA #$0000
02D84B 8D B0 0A    STA $0AB0
02D84E 8D C0 0A    STA $0AC0
02D851 A9 01 00    LDA #$0001
02D854 8D B2 0A    STA $0AB2
02D857 8D C2 0A    STA $0AC2
02D85A A9 02 00    LDA #$0002
02D85D 8D B4 0A    STA $0AB4
02D860 8D C4 0A    STA $0AC4
02D863 A9 03 00    LDA #$0003
02D866 8D B6 0A    STA $0AB6
02D869 8D C6 0A    STA $0AC6
02D86C A9 04 00    LDA #$0004
02D86F 8D B8 0A    STA $0AB8
02D872 8D C8 0A    STA $0AC8
02D875 AB          PLB
02D876 28          PLP
02D877 6B          RTL



//==============================================================================
// Bank 0x08
//==============================================================================

// BootAudio ===================================================================
088000 08          PHP
088001 C2 30       REP #$30
088003 8B          PHB
088004 4B          PHK
088005 AB          PLB
088006 A0 00 00    LDY #$0000
088009 AD 40 21    LDA $2140
08800C C9 AA BB    CMP #$BBAA
08800F D0 F8       BNE $F8    [$8009]
088011 E2 20       SEP #$20
088013 A9 CC       LDA #$CC
088015 80 26       BRA $26    [$803D]
088017 B7 10       LDA [$10],Y
088019 C8          INY
08801A EB          XBA
08801B A9 00       LDA #$00
08801D 80 0B       BRA $0B    [$802A]
08801F EB          XBA
088020 B7 10       LDA [$10],Y
088022 C8          INY
088023 EB          XBA
088024 CD 40 21    CMP $2140
088027 D0 FB       BNE $FB    [$8024]
088029 1A          INC A
08802A C2 20       REP #$20
08802C 8D 40 21    STA $2140
08802F E2 20       SEP #$20
088031 CA          DEX
088032 D0 EB       BNE $EB    [$801F]
088034 CD 40 21    CMP $2140
088037 D0 FB       BNE $FB    [$8034]
088039 69 03       ADC #$03
08803B F0 FC       BEQ $FC    [$8039]
08803D 48          PHA
08803E C2 20       REP #$20
088040 B7 10       LDA [$10],Y
088042 C8          INY
088043 C8          INY
088044 AA          TAX
088045 B7 10       LDA [$10],Y
088047 C8          INY
088048 C8          INY
088049 8D 42 21    STA $2142
08804C E2 20       SEP #$20
08804E E0 01 00    CPX #$0001
088051 A9 00       LDA #$00
088053 2A          ROL A
088054 8D 41 21    STA $2141
088057 69 7F       ADC #$7F
088059 68          PLA
08805A 8D 40 21    STA $2140
08805D CD 40 21    CMP $2140
088060 D0 FB       BNE $FB    [$805D]
088062 70 B3       BVS $B3    [$8017]
088064 AB          PLB
088065 28          PLP
088066 6B          RTL

//==============================================================================
//
//
//
//==============================================================================

