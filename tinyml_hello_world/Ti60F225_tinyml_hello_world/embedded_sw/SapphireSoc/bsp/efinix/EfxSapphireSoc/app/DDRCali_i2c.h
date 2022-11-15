/*
 * DDRCali_i2c.h
 *
 *  Created on: 17 Apr 2020
 *      Author: root
 */

#ifndef SRC_DDRCALI_I2C_H_
#define SRC_DDRCALI_I2C_H_


#include "bsp.h"
#include "i2c.h"
#include "i2cDemo.h"
#include "soc.h"

#define DDR_I2C_CH	SYSTEM_I2C_0_IO_CTRL	//I2C Channel for DDR Calibration
#define MAX_WORDS 	(128 *1024*1024)		//4Gb= 128K WORD *8 *4 //8Gb= 256K WORD *8 *4

//**************************Main Control******************************
#define LPDDR3_DEVICE			//default for T120F324 DevBoard Configure

#ifdef LPDDR3_DEVICE
#else
#define DDR3_DEVICE
#endif

#define MAX_SLICE	2	//1=8bits 2=16bits 4=32bits
#define GATE_OFFSET 	64	//64=1/4 cycle 128=1/2 cycle

#define READ_ACCESS_CALI
//#define WRITE_ACCESS_CALI

//#define DEUBG_MASSAGE
//********************************************************************

#define mem ((volatile uint32_t*)0x00001000)
#define BRUST 16

int MemoryTest_Train(int size);

void DDR_AccessTimingCali(void);
void ddr_cmd_issue(int num);
void ctrl_update_req(void);

#ifdef READ_ACCESS_CALI
void GateLeveling_soft(void);
void ReadLeveling_PatternCali(void);
#endif

#ifdef WRITE_ACCESS_CALI
void WriteLeveling(void);
#endif

#ifdef LPDDR3_DEVICE

void LPDDR_Write_CMD(int CA30, int MA,int OP);

#ifdef WRITE_ACCESS_CALI
void CA_Training(void);
#endif

#define GATE_TRAINING_COARSE_START	2
#define GATE_TRAINING_COARSE_END	5

#else

void DDR3_READ_CMD(void);
void ddr_Write_MRS_Op(int MRS, int op);

#define GATE_TRAINING_COARSE_START	0
#define GATE_TRAINING_COARSE_END	2

#endif

int32_t lfsr1_32bits(int32_t seed, int32_t count)
{
    //uint32_t start_state = 0x12345678u;  /* Any nonzero start state will work. */
    uint32_t lfsr = seed;
    uint32_t bit,n;                    /* Must be 16-bit to allow bit<<15 later in the code */

    for(n=0;n<count;n++)
    {
	/* taps: 32 30 26 25; feedback polynomial: x^32 + x^30 + x^26 + x^25 + 1 */
    	bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 6) ^ (lfsr >> 7)) /* & 1u */;
    	lfsr = (lfsr >> 1) | (bit << 31);
    }
	return lfsr;
}

void print_hex(uint32_t val, uint32_t digits)
{
	for (int i = (4*digits)-4; i >= 0; i -= 4)
		uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
}


void print(uint8_t * data) {
  uart_writeStr(BSP_UART_TERMINAL, data);
}


uint8_t checkAck(void){

	if(i2c_rxAck(DDR_I2C_CH)==0){
	    	i2c_masterStopBlocking(DDR_I2C_CH);
	    //	uart_writeStr(UART_A, "\rGet Ack Fail\n");
	    	return 0;
	}
	else
	{
	//	uart_writeStr(UART_A, "\rGet Ack Pass\n");
		return 1;
	}
}

void WriteDDRArray(uint8_t *data, uint32_t size)
{
    unsigned char buf;
    int out;

	i2c_masterStartBlocking(DDR_I2C_CH);

    for(int i = 0;i < size;i++){
        i2c_txByte(DDR_I2C_CH, data[i]);
        i2c_txNackBlocking(DDR_I2C_CH);
        if(!checkAck())	return;
    }

	i2c_masterStopBlocking(DDR_I2C_CH);
}


void WriteDDRAddr(uint32_t addr)
{
    char buf[6];

    buf[0] = 0x41<<1;
   buf[1] = 0x01;
   buf[2] = addr & 0xFF;
   buf[3] = (addr >> 8) & 0xFF;
   buf[4] = (addr >> 16) & 0xFF;
   buf[5] = (addr >> 24) & 0xFF;

   WriteDDRArray(buf, 6);

}

void WriteDDRData(uint32_t data)
{
	char buf[6];

	buf[0] = 0x41<<1;
	buf[1] = 0x00;
	buf[2] = data & 0xFF;
	buf[3] = (data >> 8) & 0xFF;
	buf[4] = (data >> 16) & 0xFF;
	buf[5] = (data >> 24) & 0xFF;

	WriteDDRArray(buf, 6);

}

void WriteDDR_Addr_Data(uint32_t Addr, uint32_t Data)
{
    WriteDDRAddr(Addr);
    WriteDDRData(Data);
}

uint32_t ReadDDRData(void)
{
    uint32_t outdata=0;

    i2c_masterStartBlocking(DDR_I2C_CH);

	i2c_txByte(DDR_I2C_CH, (0x41<<1)+1);
	i2c_txAckBlocking(DDR_I2C_CH);
	if(!checkAck())	return 0;

    for(int i = 0; i < 4; i++){
    	i2c_txByte(DDR_I2C_CH, 0xFF);
	    if(i != 3) i2c_txAckBlocking(DDR_I2C_CH); else i2c_txNackBlocking(DDR_I2C_CH);
	    outdata |= i2c_rxData(DDR_I2C_CH) << (i*8);
    }

	i2c_masterStopBlocking(DDR_I2C_CH);

    return	outdata;
}

uint32_t ReadAddrData(uint32_t Addr)
{
    WriteDDRAddr(Addr);
    return ReadDDRData();
}

void ctrl_update_req(void)
{
    int poll;

    WriteDDR_Addr_Data(0x483, 1);

    for (poll = 0; poll < 16; poll++)
    {
        if ((ReadAddrData(0x483) & 0x01) == 0x00)
            break;
    }
}

void ddr_cmd_issue(int num)
{
    int timeout;
    uint32_t  data= 0x10;
    int rdData;

    num -= 1;

    if (num <= 0)        num = 0;
    else if (num >= 16) num = 15;
    else                num = 0;

    data |= (num & 0xF);

    WriteDDRAddr(0x0412);

    WriteDDRData(data);

    for (timeout = 0; timeout < 32; timeout++)
    {
        rdData = ReadDDRData();

        if ((rdData & 0x10) == 0)
        {
        	//uart_writeStr(UART_A,"\rIssue Done\n");
            return;
        }
    }

 //   uart_writeStr(UART_A,"\rIssue Fail\n");
}


int MemoryTest_Train(int size)
{
	int n;
	uint32_t buff[BRUST];
	static uint32_t seed;

	if(seed==0)	seed=0x123ABC99;

	if(size <=BRUST) size=BRUST;

	for(int i=0;i<(size/BRUST);i++)
	{
		for(n=0;n<BRUST;n++)
		{
			//buff[n] = rand() & 0xFFFFFFFF;
			buff[n]= lfsr1_32bits(seed,2)  & 0xFFFFFFFF;
			seed=buff[n];
			mem[(i*BRUST)+n]=buff[n];
		}

		for(n=0;n<BRUST;n++)
		{
			if (mem[(i*BRUST)+n] != buff[n])
			{
			return 0;
			}
		}
	}

	seed=lfsr1_32bits(seed,n)  & 0xFFFFFFFF;

	return 1;
}

#ifdef LPDDR3_DEVICE

void LPDDR_Write_CMD(int CA30, int MA,int OP)
{
	uint32_t data = 0x00FFF001;
	int wait =0x04;

	data |=((CA30&0x7)<<9) | ((MA&0xFF)<<24);

	WriteDDRAddr(0x00000420);
	WriteDDRData(data);

	data = (OP & 0xFF) |(((CA30&0x08)>>3)<<8) |(wait <<12);

	WriteDDRAddr(0x00000430);
	WriteDDRData(data);

	ddr_cmd_issue(1);
}

#else
void DDR3_READ_CMD(void)
{
	WriteDDR_Addr_Data(0x0420, 0x00FFFA01);
	WriteDDR_Addr_Data(0x0430, 0x00000000);
	ddr_cmd_issue(1);
}



void ddr_Write_MRS_Op(int MRS, int op)
{
    uint32_t data = 0x00FFF001;

    op &= 0x1FFF;

    data |= (op & 0xFF) << 24;
    WriteDDR_Addr_Data(0x0420,data);

    MRS &= 0x0007;

    WriteDDR_Addr_Data(0x0430,(0x00000000 | (MRS<<8) | ((op>>8)&0xFF)) );

    ddr_cmd_issue(1);
}

#endif


#ifdef WRITE_ACCESS_CALI
void WriteLeveling_soft(void)
{
    uint32_t rData;
    int val = 0;
    int Byte;
    int Result[4] = {0,0,0,0};
    int rising_edge[4] = { 0xFF,0xFF,0xFF,0xFF};
    int LastState[4] = {0,0,0,0};
    int Done[4]={0,0,0,0};

    if(MAX_SLICE == 2)
	{
    	Done[2]=1;
    	Done[3]=1;
	}

	#ifdef LPDDR3_DEVICE
    LPDDR_Write_CMD(0, 0x02, 0x84);     //[3:0]=4 :RL6/WL3 (<=400Mhz) [7]=Enable Write leveling
	#else
    //DDR3*********************
    ddr_Write_MRS_Op(1, 0x00A4);
	//*************************
	#endif

    WriteDDR_Addr_Data(0x59, 2);        //Enable soft_wrlvl_en

    for (val = 0; val < 0xBF; val+=2)   //0xFF - 0x40
    {
        for (Byte = 0; Byte < MAX_SLICE; Byte++)
        	WriteDDR_Addr_Data(0x05 + (0x10 * Byte), (ReadAddrData(0x05 + (0x10 * Byte)) & 0xFF00FFFF) | (val << 16));

        ctrl_update_req();

        for (Byte = 0; Byte < MAX_SLICE; Byte++)
        {
           	WriteDDR_Addr_Data(0x01 + (0x10 * Byte), ((ReadAddrData(0x01 + (0x10 * Byte)) & 0xFFFFFFFE) | 0x01));

            Result[Byte] = (ReadAddrData(0x0F + (0x10 * Byte)) >> 4) & 0x01;

            if ((LastState[Byte] == 0) && (Result[Byte] == 1))
            {
                rising_edge[Byte] = val;
                Done[Byte]=1;
            }

            LastState[Byte] = Result[Byte];
        }


        if(Done[0] && Done[1] && Done[2] && Done[3])
        {
        	break;
        }
    }

    for (Byte = 0; Byte < MAX_SLICE; Byte++)
    {
    	WriteDDR_Addr_Data(0x05 + (0x10 * Byte), (ReadAddrData(0x05 + (0x10 * Byte)) & 0xFF0000FF) | (rising_edge[Byte] << 16) | ((rising_edge[Byte] +0x40)<<8));
    //	WriteDDR_Addr_Data(0x01 + (0x10 * Byte), ((ReadAddrData(0x01 + (0x10 * Byte)) & 0xFFFFFFFE)));
    }

    print("Write leveling Done!!\n\r");

	#ifdef DEUBG_MASSAGE
    print("slice[0]=0x");
    print_hex(rising_edge[0],4);
    print(" slice[1]=0x");
	print_hex(rising_edge[1],4);
	print(" slice[2]=0x");
	print_hex(rising_edge[2],4);
	print(" slice[3]=0x");
	print_hex(rising_edge[3],4);
	print("\n\r");
	#endif

    ctrl_update_req();

    WriteDDR_Addr_Data(0x59, 0);        //Disable soft_wrlvl_en

    #ifdef LPDDR3_DEVICE
    LPDDR_Write_CMD(0, 0x02, 0x04);     //[3:0]=4 :RL6/WL3 (<=400Mhz) [7]=Disable Write leveling
	#else
    //DDR3*********************
    ddr_Write_MRS_Op(1, 0x0024);
	//*************************
	#endif
}


#ifdef LPDDR3_DEVICE
void CA_Training(void)
{
    int  n,tmp,out,Pattern;
    int StartPass_MR41=0;
    int StartPass_MR48 = 0;
    int EndPass_MR41 = 0;
    int EndPass_MR48 = 0;
    int min, max, result;
    int result_MR41, result_MR48;
    int val;

    LPDDR_Write_CMD(0x00, 41, 0xA4);

    WriteDDR_Addr_Data(0x480, 0x0210a0a0);
    WriteDDR_Addr_Data(0x59, 0x01);

    for (val = 0; val < 0xBF; val++)
    {

        WriteDDR_Addr_Data(0x45, (ReadAddrData(0x45) & 0xFF0000FF)|((val &0xFF)<<16)| (((val +0x40) & 0xFF) << 8));
        ctrl_update_req();
        WriteDDR_Addr_Data(0x420, 0xABFFEA00);
        WriteDDR_Addr_Data(0x430, 0x0000A550);
        ddr_cmd_issue(1);

        //WriteDDR_Addr_Data(0x480, 0x0310a0a0);

        tmp = ReadAddrData(0x53);
        out = ReadAddrData(0x5B);


        if (out == 0x9959)
        {
            if (StartPass_MR41 == 0)
                StartPass_MR41 = val;

            EndPass_MR41 = val;
        }

    }

    result_MR41 = (StartPass_MR41 + EndPass_MR41) >>1;

    WriteDDR_Addr_Data(0x45, 0x20004040);
    ctrl_update_req();

    LPDDR_Write_CMD(0x00, 48, 0xC0);
    WriteDDR_Addr_Data(0x480, 0x0210a0a0);

    for (val = 0; val < 0xBF; val++)
    {
        WriteDDR_Addr_Data(0x45, (ReadAddrData(0x45) & 0xFF0000FF) | ((val & 0xFF) << 16) | (((val + 0x40) & 0xFF) << 8));
        ctrl_update_req();

        WriteDDR_Addr_Data(0x420, 0xABFFEA00);      //Data MR41 = 0x9959
        WriteDDR_Addr_Data(0x430, 0x0000A550);      //Data MR48 = 0x0101
        ddr_cmd_issue(1);

    //    WriteDDR_Addr_Data(0x480, 0x0310a0a0);

        tmp = ReadAddrData(0x53);

        out = ReadAddrData(0x5B);
        if (out == 0x101)
        {
            if (StartPass_MR48 == 0)
                StartPass_MR48 = val;

            EndPass_MR48 = val;
        }

    }

    result_MR48 = (StartPass_MR48 + EndPass_MR48) >> 1;

   // printf("Fail\n");

    if (StartPass_MR41 >= StartPass_MR48)
    {
        min = StartPass_MR41;
    }
    else
    {
        min = StartPass_MR48;
    }

    if (EndPass_MR41 <= EndPass_MR48)
    {
        max = EndPass_MR41;
    }
    else
    {
        max = EndPass_MR48;
    }

    result = (min + max) / 2;

    WriteDDR_Addr_Data(0x45, (ReadAddrData(0x45) & 0xFF0000FF) | (result <<16) | ((result+0x40)<<8));
    ctrl_update_req();

    WriteDDR_Addr_Data(0x0480, 0x20a0a0);
    WriteDDR_Addr_Data(0x59, 0x00);
    LPDDR_Write_CMD(0x00, 42, 0xA8);
}
#endif
#endif

#ifdef READ_ACCESS_CALI
void ReadLeveling_PatternCali(void)
{
    int rng = 0,rData=0,n;
    int bank,poll,check,Byte;
    uint32_t buff[8];
    int FirstPass=-1,LastPass=-1,result;

    for(bank=0;bank<MAX_SLICE;bank++)
    {
   		buff[bank]=ReadAddrData((bank*0x10)+0x05);
   		buff[bank+4]=ReadAddrData((bank*0x10)+0x00);
    }

    for (rng = 0x00; rng < 0xA0; rng+=2)
    {
    	for(bank=0;bank<MAX_SLICE;bank++)
		{
    		WriteDDR_Addr_Data((bank*0x10)+0x05,(ReadAddrData((bank*0x10)+0x05)& 0xFFFFFF00)|rng);
    		WriteDDR_Addr_Data((bank*0x10)+0x00,(ReadAddrData((bank*0x10)+0x00)& 0xFF00FFFF)|(rng<<16));
		}

    	ctrl_update_req();

    	if(MemoryTest_Train(128*16))
		{
    		if(FirstPass==-1)
    			FirstPass=rng;

    		LastPass=rng;
		}
    }

    result=(LastPass+FirstPass)/2;
    check=LastPass-FirstPass;


    if((LastPass==(-1)) || (FirstPass==(-1)) || (check<0x10))
    {
//    	print("\rRange Not Pass, use Normal result\n");

		for(bank=0;bank<MAX_SLICE;bank++)
		{
			WriteDDR_Addr_Data((bank*0x10)+0x05,buff[0+bank]);
			WriteDDR_Addr_Data((bank*0x10)+0x00,buff[4+bank]);
		}

		print("Read Level Fail !!\n\r");
    }
    else
    {
    	for(bank=0;bank<MAX_SLICE;bank++)
		{
   			 WriteDDR_Addr_Data((bank*0x10)+0x05,(buff[0+bank]& 0xFFFFFF00)|(result&0xFF));
   			 WriteDDR_Addr_Data((bank*0x10)+0x00,(buff[4+bank]& 0xFF00FFFF)|((result&0xFF)<<16));
		}

    	print("Read Level Done !!\n\r");
    }



    #ifdef DEUBG_MASSAGE
    print("Range FirstPass= 0x");
    print_hex(FirstPass,2);
	print(" LastPass= 0x");
	print_hex(LastPass,2);
	print(" Result= 0x");
	print_hex(result,2);
	print("\n\r");
	#endif

	ctrl_update_req();
}


void GateLeveling_soft(void)
{
    int poll = 0, rData = 0, n;
    int valf,valc,Byte;
    unsigned char Result[4] = { 0,0,0,0 };
    unsigned char rising_edge_c[4] = { 0xFF,0xFF,0xFF,0xFF };
    unsigned char rising_edge_f[4] = { 0xFF,0xFF,0xFF,0xFF };
    unsigned char LastState[4] = { 0xFF,0xFF,0xFF,0xFF };
    unsigned char Done[4] = {0,0,0,0};

    if(MAX_SLICE == 2)
	{
		Done[2]=1;
		Done[3]=1;
	}

    WriteDDR_Addr_Data(0x0480, 0x210A0A0);

	#ifdef LPDDR3_DEVICE

	#else
    //DDR3*********************
    ddr_Write_MRS_Op(3, 0x0004);
	//*************************
	#endif

    WriteDDR_Addr_Data(0x59, 0x14);

    for (Byte = 0; Byte < MAX_SLICE; Byte++)
    	WriteDDR_Addr_Data(0x0B+(0x10*Byte), (ReadAddrData(0x0B+(0x10*Byte))) | (1 << 12));


    for (valc = GATE_TRAINING_COARSE_START; valc <= GATE_TRAINING_COARSE_END; valc++)
    {
        for (Byte = 0; Byte < MAX_SLICE; Byte++)
        	WriteDDR_Addr_Data(0x02 + (0x10 * Byte), (ReadAddrData(0x02 + (0x10 * Byte)) & 0xDFFFFFF8) | ((valc & 0xE) >> 1) | ((valc & 0x1) << 29));


        for (valf = 0; valf < 0x7F; valf += 4)
        {
            for (Byte = 0; Byte < MAX_SLICE; Byte++)
            	WriteDDR_Addr_Data(0x05 + (0x10 * Byte), (ReadAddrData(0x05 + (0x10 * Byte)) & 0x00FFFFFF) | valf << 24);

            ctrl_update_req();


			#ifdef LPDDR3_DEVICE

            LPDDR_Write_CMD(0x08, 32, 0x00);    //MR32 DQ calibration pattern A 0xAA

			#else
			//DDR3*********************
            DDR3_READ_CMD();
			//*************************
			#endif

            for (Byte = 0; Byte < MAX_SLICE; Byte++)
            {
				Result[Byte] = (ReadAddrData(0x0C + (0x10 * Byte)) >> 16) & 0xFF;

				if ((LastState[Byte] == 0) && (Result[Byte] == 1))
				{
					rising_edge_f[Byte] = valf;
					rising_edge_c[Byte] = valc;
					Done[Byte]=1;
				}

                LastState[Byte] = Result[Byte];
            }

        }

        if(Done[0] && Done[1] && Done[2] && Done[3])
		{
			break;
		}
    }


    for (Byte = 0; Byte < MAX_SLICE; Byte++)
    {
		if ((rising_edge_c[Byte] == 0xFF) && (rising_edge_f[Byte] == 0xFF))
		{
			//Fail
		}
		else
		{
			if (rising_edge_f[Byte] < GATE_OFFSET)   //64 = 1/4 cycle offset
			{
				rising_edge_f[Byte] += GATE_OFFSET;
				rising_edge_c[Byte] -=1;
			}
			else
			{
				rising_edge_f[Byte] -= GATE_OFFSET;
			}

			WriteDDR_Addr_Data(0x02 + (0x10 * Byte), (ReadAddrData(0x02 + (0x10 * Byte)) & 0xDFFFFFF8) | ((rising_edge_c[Byte] & 0xE) >> 1) | ((rising_edge_c[Byte] & 0x1) << 29));
			WriteDDR_Addr_Data(0x05 + (0x10 * Byte), (ReadAddrData(0x05 + (0x10 * Byte)) & 0x00FFFFFF) | rising_edge_f[Byte] << 24);
		}
    }

    print("Gate Level Done !!\n\r");

    #ifdef DEUBG_MASSAGE
    print("rising_edge_c[0] =  ");
    print_hex(rising_edge_c[0],4);
    print(" rising_edge_f[0] =  ");
	print_hex(rising_edge_f[0],4);
	print("\n\r");

	print("rising_edge_c[1] =  ");
	print_hex(rising_edge_c[1],4);
	print(" rising_edge_f[1] =  ");
	print_hex(rising_edge_f[1],4);
	print("\n\r");

	print("rising_edge_c[2] =  ");
	print_hex(rising_edge_c[2],4);
	print(" rising_edge_f[2] =  ");
	print_hex(rising_edge_f[2],4);
	print("\n\r");

	print("rising_edge_c[3] =  ");
	print_hex(rising_edge_c[3],4);
	print(" rising_edge_f[3] = ");
	print_hex(rising_edge_f[3],4);
	print("\n\r");
	#endif

    ctrl_update_req();

    for (Byte = 0; Byte < MAX_SLICE; Byte++)
    	WriteDDR_Addr_Data(0x0B+(0x10*Byte), (ReadAddrData(0x0B+(0x10*Byte))) &0xFFFFEFFF);


	#ifdef LPDDR3_DEVICE

	#else
    //DDR3*********************
    ddr_Write_MRS_Op(3, 0x0000);
	//*************************
	#endif

    WriteDDR_Addr_Data(0x59, 0x00);
    WriteDDR_Addr_Data(0x0480, 0x20a0a0);
}
#endif

void DDR_AccessTimingCali(void)
{

	//I2C init
	I2c_Config i2c;
	i2c.samplingClockDivider = 3;
	i2c.timeout = I2C_CTRL_HZ/1000;    //1 ms;
	i2c.tsuDat  = I2C_CTRL_HZ/2000000; //500 ns

	i2c.tLow  = I2C_CTRL_HZ/800000;  //1.25 us
	i2c.tHigh = I2C_CTRL_HZ/800000; //1.25 us
	i2c.tBuf  = I2C_CTRL_HZ/400000;  //2.5 us

	i2c_applyConfig(DDR_I2C_CH, &i2c);


	#ifdef WRITE_ACCESS_CALI
		#ifdef LPDDR3_DEVICE
			CA_Training();
		#endif
		WriteLeveling_soft();
	#endif

	#ifdef READ_ACCESS_CALI
		GateLeveling_soft();
		ReadLeveling_PatternCali();
	#endif
}

#endif /* SRC_DDRCALI_I2C_H_ */
