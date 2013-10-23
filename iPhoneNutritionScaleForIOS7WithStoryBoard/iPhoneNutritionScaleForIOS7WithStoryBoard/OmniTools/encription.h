#include "string.h"
#include <stdio.h>
#define TABLE_SIZE	256

// 加密用的字串table
extern unsigned char s_table[TABLE_SIZE];

// 解密用的字串table
extern unsigned char s_table2[TABLE_SIZE];

// 加密
extern unsigned char str_encryption(unsigned char *s_in, unsigned char* s_out, unsigned char n_len);

// 解密
extern unsigned char str_decryption(unsigned char *s_in, unsigned char* s_out, unsigned char n_len);
// debug usage
extern void check_str_array(unsigned char *str_array,unsigned char n_len);
extern void test_protocol();
