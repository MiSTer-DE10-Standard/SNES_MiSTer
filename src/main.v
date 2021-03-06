
`define USE_DLH
`define USE_CX4
`define USE_SDD1
`define USE_GSU
`define USE_SA1

module main
(
   input             RESET_N,

   input             MCLK,
   input             ACLK,

   input       [7:0] ROM_TYPE,
   input      [23:0] ROM_MASK,
   input      [23:0] RAM_MASK,

   output reg [23:0] ROM_ADDR,
   input      [15:0] ROM_Q,
   output reg        ROM_CE_N,
   output reg        ROM_OE_N,
   output reg        ROM_WORD,

   output reg [19:0] BSRAM_ADDR,
   output reg  [7:0] BSRAM_D,
   input       [7:0] BSRAM_Q,
   output reg        BSRAM_CE_N,
   output reg        BSRAM_OE_N,
   output reg        BSRAM_WE_N,

   output     [16:0] WRAM_ADDR,
   output      [7:0] WRAM_D,
   input       [7:0] WRAM_Q,
   output            WRAM_CE_N,
   output            WRAM_OE_N,
   output            WRAM_WE_N,

   output     [15:0] VRAM1_ADDR,
   input       [7:0] VRAM1_DI,
   output      [7:0] VRAM1_DO,
   output            VRAM1_WE_N,
   output     [15:0] VRAM2_ADDR,
   input       [7:0] VRAM2_DI,
   output      [7:0] VRAM2_DO,
   output            VRAM2_WE_N,
   output            VRAM_OE_N,

   output     [15:0] ARAM_ADDR,
   output      [7:0] ARAM_D,
   input       [7:0] ARAM_Q,
   output            ARAM_CE_N,
   output            ARAM_OE_N,
   output            ARAM_WE_N,

   output            GSU_ACTIVE,
   input             GSU_TURBO,

   input             BLEND,
   input             PAL,
   output            HIGH_RES,
   output            FIELD,
   output            INTERLACE,
   output            DOTCLK,
   output      [7:0] R,
   output      [7:0] G,
   output      [7:0] B,
   output            HBLANKn,
   output            VBLANKn,
   output            HSYNC,
   output            VSYNC,

   input       [1:0] JOY1_DI,
   input       [1:0] JOY2_DI,
   output            JOY_STRB,
   output            JOY1_CLK,
   output            JOY2_CLK,
   output            JOY1_P6,
   output            JOY2_P6,
   input             JOY2_P6_in,

   input             GG_EN,
   input     [128:0] GG_CODE,
   input             GG_RESET,
   output            GG_AVAILABLE,

   input             TURBO,
   output            TURBO_ALLOW,

   output     [15:0] AUDIO_L,
   output     [15:0] AUDIO_R
);

wire [23:0] CA;
wire        CPURD_N;
wire        CPUWR_N;
reg   [7:0] DI;
wire  [7:0] DO;
wire        RAMSEL_N;
wire        ROMSEL_N;
reg         IRQ_N;
wire  [7:0] PA;
wire        PARD_N;
wire        PAWR_N;
wire        SYSCLKF_CE;
wire        SYSCLKR_CE;
wire        REFRESH;

wire  [3:0] MAP_ACTIVE;

SNES SNES
(
	.mclk(MCLK),
	.dspclk(ACLK),

	.rst_n(RESET_N),
	.enable(1),

	.ca(CA),
	.cpurd_n(CPURD_N),
	.cpuwr_n(CPUWR_N),

	.pa(PA),
	.pard_n(PARD_N),
	.pawr_n(PAWR_N),
	.di(DI),
	.do(DO),

	.ramsel_n(RAMSEL_N),
	.romsel_n(ROMSEL_N),

	.sysclkf_ce(SYSCLKF_CE),
	.sysclkr_ce(SYSCLKR_CE),

	.refresh(REFRESH),

	.irq_n(IRQ_N),

	.wsram_addr(WRAM_ADDR),
	.wsram_d(WRAM_D),
	.wsram_q(WRAM_Q),
	.wsram_ce_n(WRAM_CE_N),
	.wsram_oe_n(WRAM_OE_N),
	.wsram_we_n(WRAM_WE_N),

	.vram_addra(VRAM1_ADDR),
	.vram_addrb(VRAM2_ADDR),
	.vram_dai(VRAM1_DI),
	.vram_dbi(VRAM2_DI),
	.vram_dao(VRAM1_DO),
	.vram_dbo(VRAM2_DO),
	.vram_rd_n(VRAM_OE_N),
	.vram_wra_n(VRAM1_WE_N),
	.vram_wrb_n(VRAM2_WE_N),

	.aram_addr(ARAM_ADDR),
	.aram_d(ARAM_D),
	.aram_q(ARAM_Q),
	.aram_ce_n(ARAM_CE_N),
	.aram_oe_n(ARAM_OE_N),
	.aram_we_n(ARAM_WE_N),

	.joy1_di(JOY1_DI),
	.joy2_di(JOY2_DI),
	.joy_strb(JOY_STRB),
	.joy1_clk(JOY1_CLK),
	.joy2_clk(JOY2_CLK),
	.joy1_p6(JOY1_P6),
	.joy2_p6(JOY2_P6),
	.joy2_p6_in(JOY2_P6_in),

	.blend(BLEND),
	.pal(PAL),
	.high_res(HIGH_RES),
	.field_out(FIELD),
	.interlace(INTERLACE),
	.dotclk(DOTCLK),

	.rgb_out({B,G,R}),
	.hde(HBLANKn),
	.vde(VBLANKn),
	.hsync(HSYNC),
	.vsync(VSYNC),

	.gg_en(GG_EN),
	.gg_code(GG_CODE),
	.gg_reset(GG_RESET),
	.gg_available(GG_AVAILABLE),
	
	.turbo(TURBO),

	.audio_l(AUDIO_L),
	.audio_r(AUDIO_R)
);

`ifdef USE_DLH
wire  [7:0] DLH_DO;
wire        DLH_IRQ_N;
wire [23:0] DLH_ROM_ADDR;
wire        DLH_ROM_CE_N;
wire        DLH_ROM_OE_N;
wire        DLH_ROM_WORD;
wire [19:0] DLH_BSRAM_ADDR;
wire  [7:0] DLH_BSRAM_D;
wire        DLH_BSRAM_CE_N;
wire        DLH_BSRAM_OE_N;
wire        DLH_BSRAM_WE_N;

DSP_LHRomMap DSP_LHRomMap
(
	.mclk(MCLK),
	.rst_n(RESET_N),

	.ca(CA),
	.di(DO),
	.do(DLH_DO),
	.cpurd_n(CPURD_N),
	.cpuwr_n(CPUWR_N),

	.pa(PA),
	.pard_n(PARD_N),
	.pawr_n(PAWR_N),

	.romsel_n(ROMSEL_N),
	.ramsel_n(RAMSEL_N),

	.sysclkf_ce(SYSCLKF_CE),
	.sysclkr_ce(SYSCLKR_CE),
	.refresh(REFRESH),

	.irq_n(DLH_IRQ_N),

	.rom_addr(DLH_ROM_ADDR),
	.rom_q(ROM_Q),
	.rom_ce_n(DLH_ROM_CE_N),
	.rom_oe_n(DLH_ROM_OE_N),
	.rom_word(DLH_ROM_WORD),

	.bsram_addr(DLH_BSRAM_ADDR),
	.bsram_d(DLH_BSRAM_D),
	.bsram_q(BSRAM_Q),
	.bsram_ce_n(DLH_BSRAM_CE_N),
	.bsram_oe_n(DLH_BSRAM_OE_N),
	.bsram_we_n(DLH_BSRAM_WE_N),

	.map_ctrl(ROM_TYPE),
	.rom_mask(ROM_MASK),
	.bsram_mask(RAM_MASK)
);
`endif

`ifdef USE_CX4
wire [7:0]  CX4_DO;
wire        CX4_IRQ_N;
wire [22:0] CX4_ROM_ADDR;
wire        CX4_ROM_CE_N;
wire        CX4_ROM_OE_N;
wire        CX4_ROM_WORD;
wire [19:0] CX4_BSRAM_ADDR;
wire [7:0]  CX4_BSRAM_D;
wire        CX4_BSRAM_CE_N;
wire        CX4_BSRAM_OE_N;
wire        CX4_BSRAM_WE_N;

CX4Map CX4Map
(
	.mclk(MCLK),
	.rst_n(RESET_N),

	.ca(CA),
	.di(DO),
	.do(CX4_DO),
	.cpurd_n(CPURD_N),
	.cpuwr_n(CPUWR_N),

	.pa(PA),
	.pard_n(PARD_N),
	.pawr_n(PAWR_N),

	.romsel_n(ROMSEL_N),
	.ramsel_n(RAMSEL_N),

	.sysclkf_ce(SYSCLKF_CE),
	.sysclkr_ce(SYSCLKR_CE),
	.refresh(REFRESH),

	.irq_n(CX4_IRQ_N),

	.rom_addr(CX4_ROM_ADDR),
	.rom_q(ROM_Q),
	.rom_ce_n(CX4_ROM_CE_N),
	.rom_oe_n(CX4_ROM_OE_N),
	.rom_word(CX4_ROM_WORD),

	.bsram_addr(CX4_BSRAM_ADDR),
	.bsram_d(CX4_BSRAM_D),
	.bsram_q(BSRAM_Q),
	.bsram_ce_n(CX4_BSRAM_CE_N),
	.bsram_oe_n(CX4_BSRAM_OE_N),
	.bsram_we_n(CX4_BSRAM_WE_N),

	.map_active(MAP_ACTIVE[0]),
	.map_ctrl(ROM_TYPE),
	.rom_mask(ROM_MASK),
	.bsram_mask(RAM_MASK)
);
`else
assign MAP_ACTIVE[0] = 0;
`endif

`ifdef USE_SDD1
wire [7:0]  SDD_DO;
wire        SDD_IRQ_N;
wire [22:0] SDD_ROM_ADDR;
wire        SDD_ROM_CE_N;
wire        SDD_ROM_OE_N;
wire        SDD_ROM_WORD;
wire [19:0] SDD_BSRAM_ADDR;
wire [7:0]  SDD_BSRAM_D;
wire        SDD_BSRAM_CE_N;
wire        SDD_BSRAM_OE_N;
wire        SDD_BSRAM_WE_N;

SDD1Map SDD1Map
(
	.mclk(MCLK),
	.rst_n(RESET_N),

	.ca(CA),
	.di(DO),
	.do(SDD_DO),
	.cpurd_n(CPURD_N),
	.cpuwr_n(CPUWR_N),

	.pa(PA),
	.pard_n(PARD_N),
	.pawr_n(PAWR_N),

	.romsel_n(ROMSEL_N),
	.ramsel_n(RAMSEL_N),

	.sysclkf_ce(SYSCLKF_CE),
	.sysclkr_ce(SYSCLKR_CE),
	.refresh(REFRESH),

	.irq_n(SDD_IRQ_N),

	.rom_addr(SDD_ROM_ADDR),
	.rom_q(ROM_Q),
	.rom_ce_n(SDD_ROM_CE_N),
	.rom_oe_n(SDD_ROM_OE_N),
	.rom_word(SDD_ROM_WORD),

	.bsram_addr(SDD_BSRAM_ADDR),
	.bsram_d(SDD_BSRAM_D),
	.bsram_q(BSRAM_Q),
	.bsram_ce_n(SDD_BSRAM_CE_N),
	.bsram_oe_n(SDD_BSRAM_OE_N),
	.bsram_we_n(SDD_BSRAM_WE_N),

	.map_active(MAP_ACTIVE[1]),
	.map_ctrl(ROM_TYPE),
	.rom_mask(ROM_MASK),
	.bsram_mask(RAM_MASK)
);
`else
assign MAP_ACTIVE[1] = 0;
`endif

`ifdef USE_GSU
wire [7:0]  GSU_DO;
wire        GSU_IRQ_N;
wire [22:0] GSU_ROM_ADDR;
wire        GSU_ROM_CE_N;
wire        GSU_ROM_OE_N;
wire        GSU_ROM_WORD;
wire [19:0] GSU_BSRAM_ADDR;
wire [7:0]  GSU_BSRAM_D;
wire        GSU_BSRAM_CE_N;
wire        GSU_BSRAM_OE_N;
wire        GSU_BSRAM_WE_N;

GSUMap GSUMap
(
	.mclk(MCLK),
	.rst_n(RESET_N),

	.ca(CA),
	.di(DO),
	.do(GSU_DO),
	.cpurd_n(CPURD_N),
	.cpuwr_n(CPUWR_N),

	.pa(PA),
	.pard_n(PARD_N),
	.pawr_n(PAWR_N),

	.romsel_n(ROMSEL_N),
	.ramsel_n(RAMSEL_N),

	.sysclkf_ce(SYSCLKF_CE),
	.sysclkr_ce(SYSCLKR_CE),
	.refresh(REFRESH),

	.irq_n(GSU_IRQ_N),

	.rom_addr(GSU_ROM_ADDR),
	.rom_q(ROM_Q),
	.rom_ce_n(GSU_ROM_CE_N),
	.rom_oe_n(GSU_ROM_OE_N),
	.rom_word(GSU_ROM_WORD),

	.bsram_addr(GSU_BSRAM_ADDR),
	.bsram_d(GSU_BSRAM_D),
	.bsram_q(BSRAM_Q),
	.bsram_ce_n(GSU_BSRAM_CE_N),
	.bsram_oe_n(GSU_BSRAM_OE_N),
	.bsram_we_n(GSU_BSRAM_WE_N),

	.map_active(MAP_ACTIVE[2]),
	.map_ctrl(ROM_TYPE),
	.rom_mask(ROM_MASK),
	.bsram_mask(RAM_MASK),

	.turbo(GSU_TURBO)
);
`else
assign MAP_ACTIVE[2] = 0;
`endif

assign GSU_ACTIVE = MAP_ACTIVE[2];


`ifdef USE_SA1
wire [7:0]  SA1_DO;
wire        SA1_IRQ_N;
wire [22:0] SA1_ROM_ADDR;
wire        SA1_ROM_CE_N;
wire        SA1_ROM_OE_N;
wire        SA1_ROM_WORD;
wire [19:0] SA1_BSRAM_ADDR;
wire [7:0]  SA1_BSRAM_D;
wire        SA1_BSRAM_CE_N;
wire        SA1_BSRAM_OE_N;
wire        SA1_BSRAM_WE_N;

SA1Map SA1Map
(
	.mclk(MCLK),
	.rst_n(RESET_N),

	.ca(CA),
	.di(DO),
	.do(SA1_DO),
	.cpurd_n(CPURD_N),
	.cpuwr_n(CPUWR_N),

	.pa(PA),
	.pard_n(PARD_N),
	.pawr_n(PAWR_N),

	.romsel_n(ROMSEL_N),
	.ramsel_n(RAMSEL_N),

	.sysclkf_ce(SYSCLKF_CE),
	.sysclkr_ce(SYSCLKR_CE),
	.refresh(REFRESH),

	.pal(PAL),

	.irq_n(SA1_IRQ_N),

	.rom_addr(SA1_ROM_ADDR),
	.rom_q(ROM_Q),
	.rom_ce_n(SA1_ROM_CE_N),
	.rom_oe_n(SA1_ROM_OE_N),
	.rom_word(SA1_ROM_WORD),

	.bsram_addr(SA1_BSRAM_ADDR),
	.bsram_d(SA1_BSRAM_D),
	.bsram_q(BSRAM_Q),
	.bsram_ce_n(SA1_BSRAM_CE_N),
	.bsram_oe_n(SA1_BSRAM_OE_N),
	.bsram_we_n(SA1_BSRAM_WE_N),

	.map_active(MAP_ACTIVE[3]),
	.map_ctrl(ROM_TYPE),
	.rom_mask(ROM_MASK),
	.bsram_mask(RAM_MASK)
);
`else
assign MAP_ACTIVE[3] = 0;
`endif

assign TURBO_ALLOW = ~(MAP_ACTIVE[3] | MAP_ACTIVE[1]);

always @(*) begin
	case (MAP_ACTIVE)
`ifdef USE_CX4
	'b0001:
		begin
			DI         = CX4_DO;
			IRQ_N      = CX4_IRQ_N;
			ROM_ADDR   = {1'b0,CX4_ROM_ADDR};
			ROM_CE_N   = CX4_ROM_CE_N;
			ROM_OE_N   = CX4_ROM_OE_N;
			BSRAM_ADDR = CX4_BSRAM_ADDR;
			BSRAM_D    = CX4_BSRAM_D;
			BSRAM_CE_N = CX4_BSRAM_CE_N;
			BSRAM_OE_N = CX4_BSRAM_OE_N;
			BSRAM_WE_N = CX4_BSRAM_WE_N;
			ROM_WORD   = CX4_ROM_WORD;
		end
`endif
`ifdef USE_SDD1
	'b0010:
		begin
			DI         = SDD_DO;
			IRQ_N      = SDD_IRQ_N;
			ROM_ADDR   = {1'b0,SDD_ROM_ADDR};
			ROM_CE_N   = SDD_ROM_CE_N;
			ROM_OE_N   = SDD_ROM_OE_N;
			BSRAM_ADDR = SDD_BSRAM_ADDR;
			BSRAM_D    = SDD_BSRAM_D;
			BSRAM_CE_N = SDD_BSRAM_CE_N;
			BSRAM_OE_N = SDD_BSRAM_OE_N;
			BSRAM_WE_N = SDD_BSRAM_WE_N;
			ROM_WORD   = SDD_ROM_WORD;
		end
`endif
`ifdef USE_GSU
	'b0100:
		begin
			DI         = GSU_DO;
			IRQ_N      = GSU_IRQ_N;
			ROM_ADDR   = {1'b0,GSU_ROM_ADDR};
			ROM_CE_N   = GSU_ROM_CE_N;
			ROM_OE_N   = GSU_ROM_OE_N;
			BSRAM_ADDR = GSU_BSRAM_ADDR;
			BSRAM_D    = GSU_BSRAM_D;
			BSRAM_CE_N = GSU_BSRAM_CE_N;
			BSRAM_OE_N = GSU_BSRAM_OE_N;
			BSRAM_WE_N = GSU_BSRAM_WE_N;
			ROM_WORD   = GSU_ROM_WORD;
		end
`endif
`ifdef USE_SA1
	'b1000:
		begin
			DI         = SA1_DO;
			IRQ_N      = SA1_IRQ_N;
			ROM_ADDR   = {1'b0,SA1_ROM_ADDR};
			ROM_CE_N   = SA1_ROM_CE_N;
			ROM_OE_N   = SA1_ROM_OE_N;
			BSRAM_ADDR = SA1_BSRAM_ADDR;
			BSRAM_D    = SA1_BSRAM_D;
			BSRAM_CE_N = SA1_BSRAM_CE_N;
			BSRAM_OE_N = SA1_BSRAM_OE_N;
			BSRAM_WE_N = SA1_BSRAM_WE_N;
			ROM_WORD   = SA1_ROM_WORD;
		end
`endif
`ifdef USE_DLH
	default:
		begin
			DI         = DLH_DO;
			IRQ_N      = DLH_IRQ_N;
			ROM_ADDR   = DLH_ROM_ADDR;
			ROM_CE_N   = DLH_ROM_CE_N;
			ROM_OE_N   = DLH_ROM_OE_N;
			BSRAM_ADDR = DLH_BSRAM_ADDR;
			BSRAM_D    = DLH_BSRAM_D;
			BSRAM_CE_N = DLH_BSRAM_CE_N;
			BSRAM_OE_N = DLH_BSRAM_OE_N;
			BSRAM_WE_N = DLH_BSRAM_WE_N;
			ROM_WORD   = DLH_ROM_WORD;
		end
`else
	default:
		begin
			DI         = 0;
			IRQ_N      = 1;
			ROM_ADDR   = 0;
			ROM_CE_N   = 1;
			ROM_OE_N   = 1;
			BSRAM_ADDR = 0;
			BSRAM_D    = 0;
			BSRAM_CE_N = 1;
			BSRAM_OE_N = 1;
			BSRAM_WE_N = 1;
			ROM_WORD   = 0;
		end
`endif
	endcase
end

endmodule
