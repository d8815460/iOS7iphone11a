#include "string.h"
#include <stdio.h>
#define TABLE_SIZE	256

// �[�K�Ϊ��r��table
extern unsigned char s_table[TABLE_SIZE];

// �ѱK�Ϊ��r��table
extern unsigned char s_table2[TABLE_SIZE];

// �[�K
extern unsigned char str_encryption(unsigned char *s_in, unsigned char* s_out, unsigned char n_len);

// �ѱK
extern unsigned char str_decryption(unsigned char *s_in, unsigned char* s_out, unsigned char n_len);
// debug usage
extern void check_str_array(unsigned char *str_array,unsigned char n_len);
extern void test_protocol();
