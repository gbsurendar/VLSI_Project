module apb_protocol_tb;
  //Port declaration
  reg pclk, prst, pwrite, psel, penable, load, fetch;
  reg [7:0] paddr;
  reg [31:0] pwdata;

  wire [31:0]prdata;
  wire pready, pslverr;

  //Instantiate DUT (Design under test
  apb_protocol uut (
    .pclk(pclk),
    .prst(prst),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .psel(psel),
    .penable(penable),
    .load(load),
    .fetch(fetch),
    .prdata(prdata),
    .pready(pready),
    .pslverr(pslverr)
  );

  //Clock Generation block
always begin
      #5 pclk=~pclk;
    end
  
  initial begin
    pclk = 0;
    prst = 1;
    pwrite = 0;
    pwdata = 8'h00;
    psel = 0;
    penable = 0;
    load = 0;
    fetch = 0;
    #5 prst = ~prst;
   
  end
  
    
      
  

  always @(posedge pclk) begin
    paddr = $urandom_range(0, 127);
    //pwdata = 8'h04;

    case ($urandom_range(0, 4))
      0: begin
        pwrite = 0;
        penable = 1;
        load = 0;
        fetch = 1;
        pwdata=8'd08;
      end
      1: begin
        pwrite = 1;
        penable = 1;
        load = 1;
        fetch = 0;
        pwdata=8'd07;
      end
      2: begin
        pwrite = 1;
        penable = 1;
        load = 1;
        fetch = 1;
        pwdata=8'd06;
      end
      3:begin
        pwrite=1;
        penable=1;
        load=1;
        fetch=1;
        pwdata=8'd04;
      end
      default: begin
        pwrite = 0;
        penable = 0;
        load = 0;
        fetch = 0;
        pwdata=8'd00;
      end
    endcase
  end

  always @(posedge pclk) begin
    $display("paddr=%h, pwdata=%h, pwrite=%b, penable=%b, load=%b, fetch=%b", paddr, pwdata, pwrite, penable, load, fetch);
    $display("prdata=%h, pready=%b, pslverr=%b", prdata, pready, pslverr);
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    #100;
    $finish;
  end

  
endmodule