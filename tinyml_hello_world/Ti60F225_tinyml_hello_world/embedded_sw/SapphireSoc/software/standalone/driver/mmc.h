////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2022 Efinix Inc. All rights reserved.              
//
// This   document  contains  proprietary information  which   is        
// protected by  copyright. All rights  are reserved.  This notice       
// refers to original work by Efinix, Inc. which may be derivitive       
// of other work distributed under license of the authors.  In the       
// case of derivative work, nothing in this notice overrides the         
// original author's license agreement.  Where applicable, the           
// original license agreement is included in it's original               
// unmodified form immediately below this header.                        
//                                                                       
// WARRANTY DISCLAIMER.                                                  
//     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND        
//     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH               
//     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES,  
//     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF          
//     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR    
//     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED       
//     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.           
//                                                                       
// LIMITATION OF LIABILITY.                                              
//     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY       
//     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT    
//     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY   
//     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT,      
//     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY    
//     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF      
//     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR   
//     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN    
//     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER    
//     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
//     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
//     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR            
//     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT   
//     APPLY TO LICENSEE.                                                
//
////////////////////////////////////////////////////////////////////////////////
#pragma once
#include <stdint.h>

#define BIT(X)	                    1<<X
#define MMC_VDD_165_195		        0x00000080	/* VDD voltage 1.65 - 1.95 */
#define MMC_VDD_20_21		        0x00000100	/* VDD voltage 2.0 ~ 2.1 */
#define MMC_VDD_21_22		        0x00000200	/* VDD voltage 2.1 ~ 2.2 */
#define MMC_VDD_22_23		        0x00000400	/* VDD voltage 2.2 ~ 2.3 */
#define MMC_VDD_23_24		        0x00000800	/* VDD voltage 2.3 ~ 2.4 */
#define MMC_VDD_24_25		        0x00001000	/* VDD voltage 2.4 ~ 2.5 */
#define MMC_VDD_25_26		        0x00002000	/* VDD voltage 2.5 ~ 2.6 */
#define MMC_VDD_26_27		        0x00004000	/* VDD voltage 2.6 ~ 2.7 */
#define MMC_VDD_27_28		        0x00008000	/* VDD voltage 2.7 ~ 2.8 */
#define MMC_VDD_28_29		        0x00010000	/* VDD voltage 2.8 ~ 2.9 */
#define MMC_VDD_29_30		        0x00020000	/* VDD voltage 2.9 ~ 3.0 */
#define MMC_VDD_30_31		        0x00040000	/* VDD voltage 3.0 ~ 3.1 */
#define MMC_VDD_31_32		        0x00080000	/* VDD voltage 3.1 ~ 3.2 */
#define MMC_VDD_32_33		        0x00100000	/* VDD voltage 3.2 ~ 3.3 */
#define MMC_VDD_33_34		        0x00200000	/* VDD voltage 3.3 ~ 3.4 */
#define MMC_VDD_34_35		        0x00400000	/* VDD voltage 3.4 ~ 3.5 */
#define MMC_VDD_35_36		        0x00800000	/* VDD voltage 3.5 ~ 3.6 */


#define MMC_DATA_READ		            1
#define MMC_DATA_WRITE		            2
#define MMC_CMD_GO_IDLE_STATE		    0
#define MMC_CMD_SEND_OP_COND		    1
#define MMC_CMD_ALL_SEND_CID		    2
#define MMC_CMD_SET_RELATIVE_ADDR	    3
#define MMC_CMD_SET_DSR			        4
#define MMC_CMD_SWITCH			        6
#define MMC_CMD_SELECT_CARD		        7
#define MMC_CMD_SEND_EXT_CSD		    8
#define MMC_CMD_SEND_CSD		        9
#define MMC_CMD_SEND_CID		        10
#define MMC_CMD_STOP_TRANSMISSION	    12
#define MMC_CMD_SEND_STATUS		        13
#define MMC_CMD_SET_BLOCKLEN		    16
#define MMC_CMD_READ_SINGLE_BLOCK	    17
#define MMC_CMD_READ_MULTIPLE_BLOCK	    18
#define MMC_CMD_SEND_TUNING_BLOCK		19
#define MMC_CMD_SEND_TUNING_BLOCK_HS200	21
#define MMC_CMD_SET_BLOCK_COUNT         23
#define MMC_CMD_WRITE_SINGLE_BLOCK	    24
#define MMC_CMD_WRITE_MULTIPLE_BLOCK	25
#define MMC_CMD_ERASE_GROUP_START	    35
#define MMC_CMD_ERASE_GROUP_END		    36
#define MMC_CMD_ERASE			        38
#define MMC_CMD_APP_CMD			        55
#define MMC_CMD_SPI_READ_OCR		    58
#define MMC_CMD_SPI_CRC_ON_OFF		    59
#define MMC_CMD_RES_MAN			        62

#define SD_CMD_SEND_RELATIVE_ADDR	    3
#define SD_CMD_SWITCH_FUNC		        6
#define SD_CMD_SEND_IF_COND		        8

#define SD_CMD_APP_SET_BUS_WIDTH	    6
#define SD_CMD_ERASE_WR_BLK_START	    32
#define SD_CMD_ERASE_WR_BLK_END		    33
#define SD_CMD_APP_SEND_OP_COND		    41
#define SD_CMD_APP_SEND_SCR		        51

#define MMC_MODE_8BIT		            BIT(30)
#define MMC_MODE_4BIT		            BIT(29)
#define MMC_MODE_1BIT		            BIT(28)
#define MMC_MODE_SPI		            BIT(27)

#define MMC_RSP_PRESENT                 (1 << 0)
#define MMC_RSP_136	                    (1 << 1)		/* 136 bit response */
#define MMC_RSP_CRC	                    (1 << 2)		/* expect valid crc */
#define MMC_RSP_BUSY	                (1 << 3)		/* card may send busy */
#define MMC_RSP_OPCODE	                (1 << 4)		/* response contains opcode */

#define MMC_RSP_NONE	                (0)
#define MMC_RSP_R1	                    (MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE)
#define MMC_RSP_R1b 	                (MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE| \
			                            MMC_RSP_BUSY)
#define MMC_RSP_R2	                    (MMC_RSP_PRESENT|MMC_RSP_136|MMC_RSP_CRC)
#define MMC_RSP_R3	                    (MMC_RSP_PRESENT)
#define MMC_RSP_R4	                    (MMC_RSP_PRESENT)
#define MMC_RSP_R5	                    (MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE)
#define MMC_RSP_R6	                    (MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE)
#define MMC_RSP_R7	                    (MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE)

struct mmc;

struct mmc_cid {
	unsigned long psn;
	unsigned short oid;
	unsigned char mid;
	unsigned char prv;
	unsigned char mdt;
	char pnm[7];
};

struct mmc_cmd {
	unsigned short  cmdidx;
	unsigned int  resp_type;
	unsigned int  cmdarg;
	unsigned int  response[4];
};

struct mmc_data {
	union {
		char *dest;
		const char *src; /* src buffers don't get written to */
	};
	unsigned int flags;
	unsigned int blocks;
	unsigned int blocksize;
};

struct mmc_ops {
	int (*send_cmd)(struct mmc *mmc,
			struct mmc_cmd *cmd, struct mmc_data *data);
	int (*set_ios)(struct mmc *mmc);
	int (*init)(struct mmc *mmc);
	int (*getcd)(struct mmc *mmc);
	int (*getwp)(struct mmc *mmc);
	int (*host_power_cycle)(struct mmc *mmc);
	int (*get_b_max)(struct mmc *mmc, void *dst, uint64_t blkcnt);
};

struct mmc_config {
	char *name;
	struct mmc_ops *ops;
	unsigned int host_caps;
	unsigned int voltages;
	unsigned int f_min;
	unsigned int f_max;
	unsigned int b_max;
	unsigned char part_type;

};

struct mmc {
    //	struct list_head link;
    /* provided configuration */
	struct mmc_config *cfg;	
	unsigned int version;
	void *priv;
	unsigned int voltages;
	unsigned int has_init;
	unsigned int f_min;
	unsigned int f_max;
	int high_capacity;
	unsigned int bus_width;
	unsigned int clock;
	unsigned int card_caps;
	unsigned int host_caps;
	unsigned int ocr;
	unsigned int scr[2];
	unsigned int csd[4];
	unsigned int cid[4];
	unsigned short rca;
	char part_config;
	char part_num;
	unsigned int tran_speed;
	unsigned int read_bl_len;
	unsigned int write_bl_len;
	unsigned int erase_grp_size;
	uint64_t capacity;
};
