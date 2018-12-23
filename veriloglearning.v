//**********************//
//*****数电期末抢救*****//
//**by  @whu. Tian Yun**//
//**********2018.12.23**//
//1.有三位同学参加投票表决，每人手里有一个按键，两人以上同意（按键按下）则通过（指示灯亮）
//否则不通过（指示灯不亮），试使用逻辑门器件搭建电路，完成多数表决功能。
module Majority(a,b,c,out);
	input a,b,c;
	output out;
	assign out=(a&b)|(a&c)|(b&c);
endmodule
//2.一位全加器
module Adder_dataflow(A,B,Cin,Sum,Cout);
	input A,B,Cin;
	output Sum,Cout;
	assign	{Cout,Sum}=A+B+Cin;
endmodule
//3.四位全加器
module adder_4bit (S,C3,A,B,C_1); 
	input[3:0] A,B; 
	input C_1;
	output [3:0] S;
	output	C3;
	wire C0，C1，C2; 
		adder_dataflow U1_FA(S[0],C0,A[0],B[0],C_1); 
		adder_dataflow U2_FA(S[1],C1,A[1],B[1],C0);
		adder_dataflow U3_FA(S[2],C2,A[2],B[2],C1);
		adder_dataflow U4_FA(S[3],C3,A[3],B[3],C2);
endmodule
//4.多输入门实例引用格式如下：
//Gate-name <instance>(out1,out2……outN,input)
//2选1数据选择器（根据电路图转化）
module _2tolmuxtri (a,b,sel,out); 
	input a,b,sel; 
	output out; 
	tri out; 
	bufif1 (out,b,sel); 
	bufif0 (out,a,sel); 
endmodule
//一位全加器（根据电路图转化）
module _addbit (a,b,ci,sum,co);
	input a,b,ci; 
	output sum,co;
	xor u0(n1,a,b), u1(sum,n1,ci); 
	and u2(n2,a,b), u3(n3,n1,ci);
	or u4(co,n2,n3);	
endmodule
//5.case语句实现素数判断，4-BIT PRIME NUMBER FUNCTION IN VERILOG
module prime(in, isprime) ;
	input [3:0] in ;
	output  isprime;
	reg		isprime;
	always @(in) begin 
	case(in)
		2,3,5,7,11,13: isprime = 1'b1 ;
		default:isprime = 1'b0 ; 
	endcase 
	end 
endmodule 
//6.case语句使用方法
case(控制表达式) 
	<case 分支表达式1： 语句；> 
	<case 分支表达式2： 语句；> 
	…
	default： 语句；
endcase
//7.always语句使用方法
always @(posedge 信号1 or negedge 信号2 or posedge 信号3) begin 
	….
end
//always的敏感列表中可以同时包括多个电平敏感事件，也可以同时包括多个边沿敏感事件， 
//但不能同时有电平和边沿敏感事件。
//一个module中可以有多个always块，它们都是并行运行的。  
//always块中，被赋值的变量一定要是reg型。  
//若always块用于描述组合逻辑电路则敏感列表中要包括所有输入信号 always@（*）

//8.casex语句实现素数判断,𝑖𝑠𝑝𝑟𝑖𝑚𝑒 = 𝑎′𝑏′𝑐𝑑′ + 𝑎′𝑏′𝑐𝑑 + 𝑎’′𝑏𝑐′𝑑 +𝑎′𝑏𝑐𝑑 + 𝑎𝑏′𝑐𝑑 + 𝑎𝑏𝑐′𝑑= 001𝑥 + 01𝑥1 + 𝑥011 + 𝑥101
module prime1(in,isprime);
	input [3:0] in;
	output	isprime;
	reg		isprime;
	always @(in) begin
		casex(in)
			4'b001x:isprime=1;
			4'b01x1:isprime=1;
			4'bx011:isprime=1;
			4'bx101:isprime=1;
			default:isprime=0;
		endcase
	end
endmodule

//9.assign语句实现素数判断,𝑖𝑠𝑝𝑟𝑖𝑚𝑒 = 𝑎′𝑏′𝑐 + 𝑎′𝑏𝑑 + 𝑏′𝑐𝑑 + 𝑏𝑐′𝑑
module prime2(in,isprime);
	input [3:0] in;
	output	isprime;
	assign	isprime=(~in[3] & ~in[2] & in[1])| (~in[3] & in[2] & in[0] )| (~in[2] & in[1] & in[0]) | (in[2] &~ in[1] & in[0]) ;
endmodule

//10.素数程序的testbench
module test_prime;
	reg[3:0] in;
	wire isprime;
	//初始化待检测模块
	prime p0(in,isprime);
	initial begin//初始化一系列数值
		in=0;
		repeat (16) begin//注意循环的写法
			#100
			$display("in=%2d isprime=%1b",in,isprime);//注意输出的写法
			in=in+1;
		end
	end
endmodule
//11.练习：某工厂有三条生产线，耗电分别为1号线 10KW，2号线20KW，3号线30KW，
//生产线的电力由 两台发电机组提供，其中1号机组20KW，2号机组 40KW。
//试设计一个供电控制电路，根据生产线的开 工情况启动发电机，使得电力负荷达到最佳配置。
module GeneratorCon (A,B,C,Y1,Y2); 
	input A,B,C;
	output Y1,Y2; 
	reg Y1,Y2;
	always@(*)begin 
		case({A,B,C}) 
		0:{Y1,Y2}=2'b00;
		1,5,6: {Y1,Y2}=2'b01; 
		2,4:{Y1,Y2}=2'b10;
		default:{Y1,Y2}=2'b11;	
		endcase
	end 
endmodule
//12.4-2编码器
//逻辑表达式实现
module Enc42(a,b);
	input [3:0] a;
	output [1:0] b;
	assign b={a[3]|a[2],a[3]|a[1]};//真值表
endmodule
//case语句实现
module Enc42b(a,b);
	input [3:0] a;
	output [1:0] b;
	reg	 [1:0] b;//b为待赋值
	always @(*) begin
		case(a)
			4'b0001: b = 2'd0 ; 
			4'b0010: b = 2'd1 ;
			4'b0100: b = 2'd2 ;
			4'b1000: b = 2'd3 ;
			4'b0000: b = 2'd0 ;
			default: b = 2'bxx ;
		endcase
	end 
endmodule
//优先编码器
	4'b0001: b = 2'd0 ;
	4'b001x: b = 2'd1 ; 
	4'b01xx: b = 2'd2 ; 
	4'b1xxx: b = 2'd3 ;
	4'b0000: b = 2'd0 ;
	default: b = 2'bxx ;
//13.四个4-2实现16-4，4片4-2抽象为4个U，有输出时为1，其输出就是b1-b0；4个U的1,0真值表组成了b3-b2；
module Enc42a(a,b,c);
	input [3:0] a;
	output [1:0] b;
	output c;
	assign b={a[3]|a[2],a[3]|a[1]};//b是a的编码
	assign c=|a; //如果U有输入，即a中有1，那么c=1
endmodule
module Enc164(a,b);
	input [15:0] a;
	output [3:0] b;
	wire [7:0] Lb;//记录每个U的编码结果，最后相或，得到b1-b0
	wire [3:0] u; //其编码结果决定了b3-b2
	Enc42a U0(a[3:0],Lb[1:0],u[0]);
	Enc42a U1(a[7:4],Lb[3:2],u[1]);
	Enc42a U2(a[11:8],Lb[5:4],u[2]);
	Enc42a U3(a[15:12],Lb[7:6],u[3]);
	Enc42  e4(u[3:0],b[3:2]);
	assign b[1]=Lb[1]|Lb[3]|Lb[5]|Lb[7];
	assign b[0]=Lb[0]|Lb[2]|Lb[4]|Lb[6];
endmodule
//14.2-4译码器
module Dec(a,b);
	parameter n=2;
	parameter m=4;
	input [n-1:0] a;
	output [m-1:0] b;
	assign b=1<<a;
endmodule
//15.4个2-4译码器实现4-16译码器，由每个译码器的高两位的输出和低两位的相与，相当于b3-b0的整体移位
module Dec4to16(a,b);
	input [3:0] a;
	output [15:0] bl
	wire [3:0] x,y;
	Dec #(2,4) d0(a[1:0],x);
	Dec #(2,4) d1(a[3:2],y);
	assign b[3:0] = x & {4{y[0]}} ;
	assign b[7:4] = x & {4{y[1]}} ;
	assign b[11:8] = x & {4{y[2]}} ;
	assign b[15:12] = x & {4{y[3]}} ;
endmodule
//16.七段显示译码管
`define SS_0 7'b1111110
`define SS_1 7'b0110000
`define SS_2 7'b1101101
`define SS_3 7'b1111001
`define SS_4 7'b0110011
`define SS_5 7'b1011011
`define SS_6 7'b1011111
`define SS_7 7'b1110000
`define SS_8 7'b1111111
`define SS_9 7'b1111011
module sseg(bin,segs);
	input [3:0] bin;
	output [6:0] segs;
	reg [6:0]] segs;
	always@(*) begin
		case(bin)
			0:segs=`SS_0;
			1:segs=`SS_1;
			2:segs=`SS_2;
			....
			default:segs=7'b0000000;
		endcase
	end
endmodule

//17.4选1 数据选择器，任意数据宽度，选择信号为独热码,选哪个和哪个相与为1
module Mux4(a3,a2,a1,a0,s,b);
	parameter k=1;
	input [k-1:0] a3,a2,a1,a0;
	input [3:0] s;//one-hot
	output [k-1:0] b;
	assign b=({k{s[0]}}&a0)|{k{s[1}}&a1)|({k{s[2]}}&a2)|{k{s[3]}}&a3);
endmodule

//实例化：Mux4 #(2) mx(2'd3,2'd2,2'd1,2'd0,f,h);
//case语句实现
module Mux4(a3,a2,a1,a0,s,b);
	parameter k=1;
	input [k-1:0] a3,a2,a1,a0;
	input [3:0] s;//one-hot
	output [k-1:0] b;
	reg [k-1:0] b;
	always @(*) begin
		case(s)
			4'b0001:b=a0;
			4'b0010:b=a1;
			4'b0100:b=a2;
			4'b1000:b=a3;
			default:b={k{1'bx}};
		endcase
	end
endmodule

//18.怎么设计一个n选1的数据宽度为k的二进制数据选择器
//思路：1.设计一个n-m译码器，将二进制代码转化为独热码
//		2.将多个小型数据选择宽度为k的独热码MUX扩展为n选1独热码MUX
//		3.将两个模块连接（与，或）
// example:设计一个16选1的数据选择器
module Mux16a(a15,a14,a13,.....,a0,s,b);
	parameter k=1;
	input [k-1:0] a15,.....,a0;
	input [3:0] s;
	output [k-1:0] b;
	wire [k-1:0] b0,b1,b2,b3;
	wire [15:0] sb;
	//1.4-16 转换为独热码
	Dec #(4,16) Dec4_16(s,sb);
	//2.将4个4选1数据选择器扩展为16选1
    Mux4 #(k) m3(a15,a14,a13,a12,sb[15:12],b3);
	Mux4 #(k) m2(a11,a10,a9,a8,sb[11:8],b2);
	Mux4 #(k) m1(a7,a6,a5,a4,sb[7:4],b1);
	Mux4 #(k) m0(a3,a2,a1,a0,sb[3:0],b0);
	//3.结果相或
	assign b=b0|b1|b2|b3;
endmodule
	
//19.数据选择器实现isprime 
module Primem(in,isprime);
	input[2:0] in;
	output isprime;
	Mux8 #(1) m(1,0,10,1,1,1,0,in,isprime);
endmodule

//20.半加器 s=a异或b，co=a+b
module HalfAdder(a,b,c,s);
	input a,b;
	output c,s;
	wire s=a^b; //也可以 assign s=a^b;
	wire c=a&b;
endmodule

//21.全加器
module FullAdder(a,b,cin,cout,s);
	input a,b,cin;
	output cout,s;
	//逻辑描述
	assign s=a^b^cin;
	assign cout=(a&b)|(a&cin)|(b&cin);
	//行为描述
	//assign {cout,s}=a+b+cin; 
endmodule

//22.比较器 if-else 语句
module compare_n(a,b,eq);
	input [k-1:0] a,b;
	output [2:0] eq;
	reg aeb,agb,asb; // = ,>,<
	parameter k=8;
	assign eq={aeb,agb,asb};
	always @(a,b)
		begin
			if(a==b)
				aeb=1;
			else
				aeb=0;
			if(a>b)
				agb=1;
			else
				agb=0;
			if(a<b)
				asb=1;
			else
				asb=0;
		end
endmodule
//23.n位D触发器
module DFF(clk,in,out);
	parameter n=1;
    input clk;
    input [n-1:0] in;
    output [n-1:0] out;
    reg [n-1:0] out;
    always @(posedge clk)
    	out=in;
endmodule
//具有同步清零reset
module dff_sync_reset(data,clk,reset,q);
	input data,clk,reset;
	output q;
	reg q;
	always@(posedge clk );
		if(~reset)
			begin
				q<=1'b0;
			end
		else
			begin
				q<=data;
			end
	//异步清零
	//always@(posedge clk or negedge reset);
	//if (~reset)
	//	...
endmodule
		
//24.简单JK触发器
module JK(clk,j,k,Q);
	input clk;
	input j,k;
    output Q;
    reg Q;
    always @(posedge clk)
    	Q<=j&&(~Q)||(~k)&&Q; //&&是逻辑上的与，结果为1或者0， &是位与，结果有很多位
endmodule
//25.简单T触发器
module TFF(clk,t,Q);
	input clk;
    input t;
    output Q;
    reg Q;
    always@(posedge clk)
  		Q<=t&&(~Q)||(~t)&&Q;
endmodule
//有reset功能
module tff_aync_reset(t,clk,reset,q);
	input data,clk,reset;
	output q;
	reg q;
	always@(posedge clk or negedge reset)
		if(~reset)
			begin
				q<=1'b0;
			end
		else
			begin
				q<=~q;
			end
endmodule
			
//26.简单的移位寄存器
    1 module Shift_Register1(clk,rst,sin,out);
    2   parameter n=4;
    3   input clk,rst,sin;
    4   output [n-1:0] out;
    5   wire [n-1:0] nest=rst? {n{1'b0}}:{out[n-2:0],sin};
    6   DFF #(n) cnt(clk,next,out);
    7 endmodule

//27.六进制加法计数器
module counter_6(
        input CLK,
        input RST,
        output reg [2:0] CNT
        );
        parameter MAX=3'b101;
        always @(posedge RST,posedge CLK)
        begin
            if(RST)
            begin
                CNT<=3'b000;
            end
            else
            begin
                if(CNT==MAX)
                begin
                    CNT<=3'b000;
                end
                else
                begin
                    CNT<=CNT+3'b001;
                end
            end
        end

endmodule
//28.带有左移、右移、异步置位、状态保持功能的寄存器
    1 module LRL_Shift_Register(clk,rst,left,right,load,sin,in,out);
    2   parameter n=4;
    3   input clk,rst,left,right,load,sin;
    4   input [n-1:0] in;
    5   output [n-1:0] out;
    6   reg [n-1:0] next;
    7   DFF #(n) cnt(clk,next,out);
    8   always @(*) begin
    9     casex({rst,left,right,load})
   10         4'b1xxx:next=0;
   11         4'b01xx:next={out[n-2:0],sin};
   12         4'b001x:next={sin,out[n-1:1]};
   13         4'b0001:next=in;
   14         default:next=out;
   15     endcase
   16   end
   17 endmodule
//29.简单3位二进制计数器
    1 module Counter1(clk,rst,out);
    2   input clk,rst;
    3   output [2:0] out;
    4   reg [2:0] next;
    5   DFF#(3) count(clk,next,out);
    6   always@(*)begin
    7     casex({rst,out})
    8       6'b1xxxxx:next=0;
    9       6'd0:next=1;
   10       6'd1:next=2;
   11       6'd2:next=3;
   12       6'd3:next=4;
   13       6'd4:next=5;
   14       6'd5:next=6;
   15       6'd6:next=7;
   16       6'd7:next=0;
   17       default:next=0;
   18   endcase
   19 end
   20 endmodule
//用逻辑函数实现：
    1 module Couter(clk,rst,count);
    2   parameter n=3;
    3   input rsk,clk;
    4   output[n-1:0] count;
    5   wire [n-1:0] next=rst? 0:count+1;
    6   DFF#(n) cnt(clk,next,out);
    7 endmodule
//30.预置数功能的可逆计数器
    1 module UDL_Count1(clk,rst,up,down,load,in,out);
    2   input clk,rst,up,down,load;
    3   parameter n=3;
    4   input [n-1:0] in;
    5   output [n-1:0] out;
    6   wire [n-1:0] outpm1;//用于计算的中间变量
    7   reg [n-1:0] next;
    8   DFF#(n) count(clk,next,out);
    9   assign outpm1=out+{{n-1{~up}},1'b1};
   10   always@(*)begin
   11     casex({rst,up,down,load})
   12       4'b1xxx:next={n{1'b0}};
   13       4'b01xx:next=outpm1;
   14       4'b001x:next=outpm1;
   15       4'b0001:next=in;
   16       default:next=out;
   17     endcase
   18   end
   19 endmodule
//31.简单的同步十进制计数器
    1 module Counter10(clk,rst,out);
    2   parameter n=4;
    3   input clk,rst;
    4   output [n-1:0] count;//当前状态
    5   wire flag;  //判断是否为9
    6   wire [n-1:0] next=(rst|flag)? 0:count+1;
    7   assign flag=(count==9)? 1:0;
    8   DFF#(n) cnt(clk,next,out);
    9 endmodule
//32.任意进制的计数器
    1 module Counter_num(clk,rst,out);
    2   parameter n=4,num=10;
    3   input rsk,clk;
    4   output [n-1:0] count;
    5   wire flag;
    6   wire [n-1:0] next=(rst|flag)? 0:count+1;
    7   assign flag=(count==(num-1))? 1:0;
    8   DFF#(n) cnt(clk,next,out);
    9 endmodule
//33.有限状态机的设计
//1.红绿灯
//2.自动售卖机
//3.简易流水灯
//4.串行数据检测器	
	

