`default_nettype none

module tt_um_REG_DES_BI_RTL (
    input  wire [7:0] ui_in,    // Entradas dedicadas -> DIN[7:0]
    output wire [7:0] uo_out,   // Salidas dedicadas  -> DOUT[7:0]
    input  wire [7:0] uio_in,   // IOs entrada        -> uio_in[1:0] = OPR[1:0]
    output wire [7:0] uio_out,  // IOs salida (no usadas)
    output wire [7:0] uio_oe,   // Habilitación IOs (0 = entrada, 1 = salida)
    input  wire       ena,      // Siempre en 1 cuando el diseño está activo
    input  wire       clk,      // Reloj (en minúsculas)
    input  wire       rst_n     // Reset activo en bajo
);

  // Configuramos los 8 pines bidireccionales (uio) como entradas
  assign uio_out = 8'b00000000;
  assign uio_oe  = 8'b00000000;

  // Mapeo de tus señales internas a los pines físicos de Tiny Tapeout
  wire [1:0] OPR  = uio_in[1:0];
  wire [7:0] DIN  = ui_in[7:0];
  wire [7:0] DOUT;

  reg [7:0] QN, QP;

  // Proceso secuencial adaptado a clk y rst_n (activo en bajo)
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      QP <= 8'b00000000;
    end else begin
      QP <= QN;
    end
  end

  // Tu lógica combinacional original intacta
  always @(*) begin
    case (OPR)
      2'b00:   QN = QP;              // Mantener
      2'b01:   QN = {QP[6:0], 1'b0}; // Desplazamiento izquierda
      2'b10:   QN = {1'b0, QP[7:1]}; // Desplazamiento derecha
      default: QN = DIN;           // Carga desde DIN
    endcase
  end

  assign DOUT   = QP;
  assign uo_out = DOUT;

  // Evita errores en el Linter por los pines de uio_in y ena que no se usan
  wire _unused = &{ena, uio_in[7:2], 1'b0};

endmodule
