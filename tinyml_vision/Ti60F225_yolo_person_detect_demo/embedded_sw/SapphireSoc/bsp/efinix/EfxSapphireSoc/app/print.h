#pragma once

#include <stdarg.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <string.h>
#include "bsp.h"

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
    
    /* itos:  convert integer n to characters in s */
     static void itos(int n, char s[])
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
    static void ftoa(double n, char* res1, char* res2)
    {
        float fpart_f;
        int afterpoint=4;
    
        // Extract integer part
        int ipart = (int)n;
    
        // Extract floating part
        double fpart = n - (double)ipart;
    
        // convert integer part to string
        itos(n, res1);
    
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
    
        itos((int)fpart_f, res2);
    }
    
    static void print_dec(uint32_t val)
    {
        char sval[10];
        itos(val, sval);
        uart_writeStr(BSP_UART_TERMINAL, sval);
    }
    
    static void print_float(double val)
    {
        int i, j, neg;
        neg=0;
        i=2;
        j=19;
        char sval[20], fval[10];
        ftoa(val, sval, fval);
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


    static void bsp_printf_c(int c)
    {
        bsp_putChar(c);
    }
    
    static void bsp_printf_s(char *p)
    {
        while (*p)
            bsp_putChar(*(p++));
    }
    
    static void bsp_printf_d(int val)
    {
        char buffer[32];
        char *p = buffer;
        if (val < 0) {
            bsp_printf_c('-');
            val = -val;
        }
        while (val || p == buffer) {
            *(p++) = '0' + val % 10;
            val = val / 10;
        }
        while (p != buffer)
            bsp_printf_c(*(--p));
    }
    
    static void bsp_printf_x(int val)
    {
    	int i,digi=2;
    
    	for(i=0;i<8;i++)
    	{
    		if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    		{
    			digi=i+1;
    			break;
    		}
    	}
    
    	bsp_printHex(val);
    }
    
    static void bsp_printf(const char *format, ...)
    {
        int i;
        va_list ap;
    
        va_start(ap, format);
    
        for (i = 0; format[i]; i++)
            if (format[i] == '%') {
                while (format[++i]) {
                    if (format[i] == 'c') {
                        bsp_printf_c(va_arg(ap,int));
                        break;
                    }
                    if (format[i] == 's') {
                        bsp_printf_s(va_arg(ap,char*));
                        break;
                    }
                    if (format[i] == 'd') {
                        bsp_printf_d(va_arg(ap,int));
                        break;
                    }
                    if (format[i] == 'x') {
    					bsp_printf_x(va_arg(ap,int));
    					break;
    				}
                }
            } else
                bsp_printf_c(format[i]);
    
        va_end(ap);
    }

