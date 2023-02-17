#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <string.h>
#include "bsp.h"
#include "io.h"
#if __cplusplus
extern "C" {
#endif
 /* reverse:  reverse string s in place */
 static void reverse(char s[])
 {
      int i, j, len;
      char c; 

      for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
          c = s[i];
          s[i] = s[j];
          s[j] = c;
      }
 }

/* itoa:  convert n to characters in s */
 static void mitoa(int n, char s[])
 {
	 int i, sign;

	 if ((sign = n) < 0)  /* record sign */
		 n = -n;          /* make n positive */
	 i = 0;
	 do {       /* generate digits in reverse order */
		 s[i++] = n % 10 + '0';   /* get next digit */
	 } while ((n /= 10) > 0);     /* delete it */
	 if (sign < 0)
		 s[i++] = '-';
	 s[i] = '\0';
	 reverse(s);
}

// Converts a floating-point/double number to a string.
static void mftoa(double n, char* res1, char* res2)
{
	float fpart_f;
    int afterpoint=4;

    // Extract integer part
    int ipart = (int)n;

    // Extract floating part
    double fpart = n - (double)ipart;

    // convert integer part to string
	mitoa(n, res1);

    // add dot
    *res2 = '.';
    res2++;

    // convert fraction part to string
    fpart_f = (float)fpart * pow(10, afterpoint);
    if (fpart_f<0)
    {
    	*res2 = '-';
    	res2++;
    	fpart_f = -(fpart_f);
    }
    // handling of 0 after decimal point e.g. 1.003
    for (int i=afterpoint; i>0; i--)
    {
    	if ((fpart_f<(1 * pow(10, i-1))) && (fpart_f>0))
        {
    		*res2='0';
    		res2++;
        }
    }

	mitoa((int)fpart_f, res2);
}

void print_dec(uint32_t val)
{
	char sval[10];
	mitoa(val, sval);
	uart_writeStr(BSP_UART_TERMINAL, sval);
}

void print_float(double val)
{
	int i, j, neg;
	neg=0;
	i=2;
	j=19;
	char sval[20], fval[10];
	mftoa(val, sval, fval);
	if (fval[1] == '-')
	{
		neg = 1;
		while (i<10)
		{
			fval[i-1] = fval[i];
			i++;
		}

	}
	strcat(sval, fval);
	if ((sval[0] != '-') && (neg == 1))
	{
		while (j>=0)
		{
			sval[j+1] = sval[j];
			j--;
		}
		sval[0] = '-';
	}
	uart_writeStr(BSP_UART_TERMINAL, sval);
}

void print_hex(u32 val, u32 digits)
{
	for (int i = (4*digits)-4; i >= 0; i -= 4)
		uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
}

void print_hex_digit(u8 digit){
    uart_write(BSP_UART_TERMINAL, digit < 10 ? '0' + digit : 'A' + digit - 10);
}


void print_hex_byte(u8 byte){
    print_hex_digit(byte >> 4);
    print_hex_digit(byte & 0x0F);
}

void print_hex_64(uint64_t val, uint32_t digits)
{
    for (int i = (4*digits)-4; i >= 0; i -= 4)
        uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
}
#if __cplusplus
}
#endif
