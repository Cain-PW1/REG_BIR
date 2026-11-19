module tt_um_REG_DES_BI_RTL (
    input wire CLK,
    input wire RESET,
    input wire [1:0] OPR,
    input wire [7:0] DIN,
    output wire [7:0] DOUT
);
reg [7:0] QN, QP;  // Señales internas
always @(posedge CLK or posedge RESET) begin // Proceso del registro 
    if (RESET) begin
        QP <= 8'b00000000;
    end else begin
        QP <= QN;
    end
end
// Lógica combinacional para QN - equivalente al with/select
always @(*) begin
    case (OPR)
        2'b00: QN = QP;              // Mantener
        2'b01: QN = {QP[6:0], 1'b0}; // Desplazamiento izquierda
        2'b10: QN = {1'b0, QP[7:1]}; // Desplazamiento derecha
        default: QN = DIN;           // Carga desde DIN
    endcase
end
assign DOUT = QP;  // Asignación de salida
endmodule
