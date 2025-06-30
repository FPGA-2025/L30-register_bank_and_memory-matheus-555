module Memory #(
    parameter MEMORY_FILE = "",
    parameter MEMORY_SIZE = 4096
)(
    input  wire        clk,

    input  wire        rd_en_i,    // Indica uma solicitação de leitura
    input  wire        wr_en_i,    // Indica uma solicitação de escrita

    input  wire [31:0] addr_i,     // Endereço
    input  wire [31:0] data_i,     // Dados de entrada (para escrita)
    output wire [31:0] data_o,     // Dados de saída (para leitura)

    output wire        ack_o       // Confirmação da transação
);

    reg [31:0] memory [0:MEMORY_SIZE-1];
    reg [31:0] _data_o;
    reg _ack_o;

    initial begin
        if (MEMORY_FILE != "") begin
            $readmemh(MEMORY_FILE, memory);
        end
    end

    always @(posedge clk) begin
        _ack_o  <= 1'b0;
        _data_o <= 32'b0;

        if (rd_en_i) begin
            _data_o <= memory[addr_i[31:2]];
            _ack_o  <= 1'b1;
        end else if (wr_en_i) begin
            memory[addr_i[31:2]] <= data_i;
            _ack_o <= 1'b1;
        end
    end

    assign data_o = _data_o;
    assign ack_o  = _ack_o;
endmodule
