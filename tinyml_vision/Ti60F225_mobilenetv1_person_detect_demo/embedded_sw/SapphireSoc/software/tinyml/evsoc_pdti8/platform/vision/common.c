
#include "common.h"

void init_mem_content (volatile uint32_t mem_array [], int32_t num_words) {
   uart_writeStr(BSP_UART_TERMINAL, "Initialize memory content..\n\r");
   for(int i=0;i<num_words;i++) {
      mem_array [i] = 0xffffffff;
   }
}

void check_mem_content (volatile uint32_t mem_array [], int32_t num_words) {
   uart_writeStr(BSP_UART_TERMINAL, "Check memory content..\n\r");
   for(int i=0;i<num_words;i++) {
      print_hex(mem_array[i], 8);
      uart_writeStr(BSP_UART_TERMINAL, "\r");
   }
}

//void print_hex_64(uint64_t val, uint32_t digits)
//{
//    for (int i = (4*digits)-4; i >= 0; i -= 4)
//        uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
//}

u32 axi_slave_read32(u32 address) {
   u32 data;
   data = read_u32(address);
   return data;
}

void assert(int cond){
    if(!cond) {
        uart_writeStr(BSP_UART_TERMINAL, "Assert failure\n");
        while(1);
    }
}

//void print_hex_digit(u8 digit){
//    uart_write(BSP_UART_TERMINAL, digit < 10 ? '0' + digit : 'A' + digit - 10);
//}


//void print_hex_byte(u8 byte){
//    print_hex_digit(byte >> 4);
//    print_hex_digit(byte & 0x0F);
//}
//
//void print_hex(u32 val, u32 digits)
//{
//	for (int i = (4*digits)-4; i >= 0; i -= 4)
//		uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
//}


u32 number_pow(u32 base ,u32 pow)
{
	u32 i=1;
	u32 out=1;

		 if(pow==0)return 1;
	else if(pow==1)return base;
	else
	{
		while(i<=pow){
			out=out*base;
			i++;
		}
		return out;
	}

	return 0;	//error
}

unsigned char UartGetChar(void)
{
	unsigned char out;

	while(1)
	{
		while(uart_readOccupancy(BSP_UART_TERMINAL))
		{
			out = uart_read(BSP_UART_TERMINAL);
			return out;
		}
	}
}


void msDelay(u32 ms)
{
	bsp_uDelay(ms*1000);
}

u32 UartGetDec(void)
{
	unsigned char u=0;
	u32 num=0,total=0,total_num=0;

	while(1)
		{
			while(uart_readOccupancy(BSP_UART_TERMINAL))
			{
				u = uart_read(BSP_UART_TERMINAL);

				uart_write(BSP_UART_TERMINAL, u);

					 if(u=='0')	num=0;
				else if(u=='1')	num=1;
				else if(u=='2')	num=2;
				else if(u=='3')	num=3;
				else if(u=='4')	num=4;
				else if(u=='5')	num=5;
				else if(u=='6')	num=6;
				else if(u=='7')	num=7;
				else if(u=='8')	num=8;
				else if(u=='9')	num=9;

				if(u==0x0D)
				{
					total_num=total;
					return total;
				}
				else
				{
					total*=10;
					total+=num;
				}
			}

		}
}

void mipi_i2c_init(){
    //I2C init
    I2c_Config i2c_mipi;
    i2c_mipi.samplingClockDivider = 3;
    i2c_mipi.timeout = I2C_CTRL_HZ/1000;
    i2c_mipi.tsuDat  = I2C_CTRL_HZ/2000000;

    i2c_mipi.tLow  = I2C_CTRL_HZ/800000;
    i2c_mipi.tHigh = I2C_CTRL_HZ/800000;
    i2c_mipi.tBuf  = I2C_CTRL_HZ/400000;

    i2c_applyConfig(I2C_CTRL_MIPI, &i2c_mipi);

}

/*
void hdmi_i2c_init(){
    //I2C init
    I2c_Config i2c_hdmi;
    i2c_hdmi.samplingClockDivider = 3;
    i2c_hdmi.timeout = I2C_CTRL_HZ/1000;
    i2c_hdmi.tsuDat  = I2C_CTRL_HZ/2000000;

    i2c_hdmi.tLow  = I2C_CTRL_HZ/800000*2;
    i2c_hdmi.tHigh = I2C_CTRL_HZ/800000*2;
    i2c_hdmi.tBuf  = I2C_CTRL_HZ/400000*2;

    i2c_applyConfig(I2C_CTRL_HDMI, &i2c_hdmi);

}
*/
