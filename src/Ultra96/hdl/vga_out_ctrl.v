`timescale 1ns / 1ps

module vga_out_ctrl(
	input pclk,
	input [31:0] center,
	output [7:0] pmod_a, pmod_b
    );

	reg [25:0] cnt;
	integer    hcnt, vcnt;
	wire[15:0] hc, vc;
	reg	[11:0]  vga_out;
	reg        vga_hs, vga_vs;	
	
	assign pmod_b[3:0] = vga_out[11:8];
	assign pmod_a[3:0] = vga_out[7:4];
	assign pmod_b[7:4] = vga_out[3:0];
	assign pmod_a[4] = vga_hs;
	assign pmod_a[5] = vga_vs;
	
	assign hc = center[15:0];
	assign vc = center[31:16];
	
    always@(posedge pclk)
	begin
		
		hcnt <= hcnt + 1;
		if(hcnt == 799) begin
			hcnt <= 0;
			vcnt <= vcnt + 1;
			if(vcnt == 524)	vcnt <= 0;
		end
		
		if(hcnt>=656 && hcnt<752) vga_hs <= 1'b0;
		else                      vga_hs <= 1'b1;
		
		if(vcnt>=490 && vcnt<492) vga_vs <= 1'b0;
		else                      vga_vs <= 1'b1;
		
        if(hcnt>=0 && hcnt<640 && vcnt>=0 && vcnt<480) begin
            cnt <= cnt+1;		
            if(cnt == 500000) begin
                cnt <= 0;		
            end
                        
            vga_out <= 12'hfff;
                                    					
            if(hcnt>=hc && hcnt<hc+8 && vcnt>=vc && vcnt<vc+40) vga_out <= 12'hf00; // "I" Character
            
            if(hcnt>=hc+13 && hcnt<hc+21 && vcnt>=vc && vcnt<vc+40) vga_out <= 12'hf00; // "N" Character
            if(hcnt>=hc+13+(vcnt-vc)/2 && hcnt<hc+21+(vcnt-vc)/2 && vcnt>=vc && vcnt<vc+40) vga_out <= 12'hf00; // "N" Character
			if(hcnt>=hc+33 && hcnt<hc+41 && vcnt>=vc && vcnt<vc+40)  vga_out <= 12'hf00; // "N" Character
			
			if(hcnt>=hc+46 && hcnt<hc+54 && vcnt>=vc && vcnt<vc+40)  vga_out <= 12'hf00; // "I" Character            
			
			if(hcnt>=hc+59 && hcnt<hc+67 && vcnt>=vc && vcnt<vc+40)  vga_out <= 12'h00f; // "P" Character
			if(hcnt>=hc+67 && hcnt<hc+75 && vcnt>=vc && vcnt<vc+8)  vga_out <= 12'h00f; // "P" Character
			if(hcnt>=hc+67 && hcnt<hc+75 && vcnt>=vc+16 && vcnt<vc+24)  vga_out <= 12'h00f; // "P" Character
			if(hcnt>=hc+75 && hcnt<hc+83 && vcnt>=vc+0 && vcnt<vc+24)  vga_out <= 12'h00f; // "P" Character
			
			if(hcnt>=hc+88 && hcnt<hc+96 && vcnt>=vc && vcnt<vc+40)  vga_out <= 12'h00f; // "R" Character
			if(hcnt>=hc+96 && hcnt<hc+104 && vcnt>=vc && vcnt<vc+8)  vga_out <= 12'h00f; // "R" Character
			if(hcnt>=hc+96 && hcnt<hc+104 && vcnt>=vc+16 && vcnt<vc+24)  vga_out <= 12'h00f; // "R" Character
			if(hcnt>=hc+104 && hcnt<hc+112 && vcnt>=vc+0 && vcnt<vc+24)  vga_out <= 12'h00f; // "R" Character
			if(hcnt>=hc+88+(vcnt-vc)/2 && hcnt<hc+96+(vcnt-vc)/2 && vcnt>=vc+20 && vcnt<vc+40) vga_out <= 12'h00f; // "R" Character
			
			if(hcnt>=hc+117 && hcnt<hc+125 && vcnt>=vc && vcnt<vc+40)  vga_out <= 12'h00f; // "O" Character
			if(hcnt>=hc+133 && hcnt<hc+141 && vcnt>=vc && vcnt<vc+40)  vga_out <= 12'h00f; // "O" Character
			if(hcnt>=hc+117 && hcnt<hc+141 && vcnt>=vc && vcnt<vc+8)  vga_out <= 12'h00f; // "O" Character
			if(hcnt>=hc+117 && hcnt<hc+141 && vcnt>=vc+32 && vcnt<vc+40)  vga_out <= 12'h00f; // "O" Character			
		end
		else vga_out <= 12'h000;
		
	end 
	    
endmodule
