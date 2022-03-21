#include <stdio.h>

int main()
{
    printf("initializing\n");
    unsigned int c = 1;
    unsigned int state0 = 0; //s63...s32
    unsigned int state1 = 0; // s31...s0
    unsigned int key1 = 0xffffffff; // k79...k48
    unsigned int key2 = 0xffffffff;
    unsigned int key3 = 0xffff;
    
    while(c<32) {
        printf("Round %d\n", c);
        printf("state0 %x\nstate1 %x\nkey1 %x\nkey2 %x\nkey3 %x\n", state0, state1, key1, key2, key3);

        
        unsigned int t0 = 0;
        unsigned int t1 = 0;
        state0 = state0 ^ key1;
        state1 = state1 ^ key2;


        state0=sBox32(state0);
        state1=sBox32(state1);

        t0  = state1 & 1;
        t0 |= (state1 & (1<<4))>>3;
        t0 |= (state1 & (1<<8))>>6;
        t0 |= (state1 & (1<<12))>>9;
        t0 |= (state1 & (1<<16))>>12;
        t0 |= (state1 & (1<<20))>>15;
        t0 |= (state1 & (1<<24))>>18;
        t0 |= (state1 & (1<<28))>>21;
        t0 |= (state0 & 1)<<8 ;
        t0 |= (state0 & (1<<4))<<5;
        t0 |= (state0 & (1<<8))<<2;
        t0 |= (state0 & (1<<12))>>1;
        t0 |= (state0 & (1<<16))>>4;
        t0 |= (state0 & (1<<20))>>7;
        t0 |= (state0 & (1<<24))>>10;
        t0 |= (state0 & (1<<28))>>13;
        t0 |= (state1 & (1<<1))<<15;
        t0 |= (state1 & (1<<5))<<12;
        t0 |= (state1 & (1<<9))<<9;
        t0 |= (state1 & (1<<13))<<6;
        t0 |= (state1 & (1<<17))<<3;
        t0 |=  state1 & (1<<21);
        t0 |= (state1 & (1<<25))>>3;
        t0 |= (state1 & (1<<29))>>6;
        t0 |= (state0 & (1<<1))<<23;
        t0 |= (state0 & (1<<5))<<20;
        t0 |= (state0 & (1<<9))<<17;
        t0 |= (state0 & (1<<13))<<14;
        t0 |= (state0 & (1<<17))<<11;
        t0 |= (state0 & (1<<21))<<8;
        t0 |= (state0 & (1<<25))<<5;
        t0 |= (state0 & (1<<29))<<2;

        t1 = (state1 & (1<<2))>>2;
        t1 |= (state1 & (1<<6))>>5;
        t1 |= (state1 & (1<<10))>>8;
        t1 |= (state1 & (1<<14))>>11;
        t1 |= (state1 & (1<<18))>>14;
        t1 |= (state1 & (1<<22))>>17;
        t1 |= (state1 & (1<<26))>>20;
        t1 |= (state1 & (1<<30))>>23;
        t1 |= (state0 & (1<<2))<<6;
        t1 |= (state0 & (1<<6))<<3;
        t1 |=  state0 & (1<<10);
        t1 |= (state0 & (1<<14))>>3;
        t1 |= (state0 & (1<<18))>>6;
        t1 |= (state0 & (1<<22))>>9;
        t1 |= (state0 & (1<<26))>>12;
        t1 |= (state0 & (1<<30))>>15;
        t1 |= (state1 & (1<<3))<<13;
        t1 |= (state1 & (1<<7))<<10;
        t1 |= (state1 & (1<<11))<<7;
        t1 |= (state1 & (1<<15))<<4;
        t1 |= (state1 & (1<<19))<<1;
        t1 |= (state1 & (1<<23))>>2;
        t1 |= (state1 & (1<<27))>>5;
        t1 |= (state1 & (1<<31))>>8;
        t1 |= (state0 & (1<<3))<<21;
        t1 |= (state0 & (1<<7))<<18;
        t1 |= (state0 & (1<<11))<<15;
        t1 |= (state0 & (1<<15))<<12;
        t1 |= (state0 & (1<<19))<<9;
        t1 |= (state0 & (1<<23))<<6;
        t1 |= (state0 & (1<<27))<<3;
        t1 |= state0 & (1<<31);

        state0 = t1;
        state1 = t0;
        
        

        unsigned int key1Tmp = key2<<29 | key3<<13 | key1>>19;
        unsigned int key2Tmp = key2>>19 | key1<<13;
        key3 = (key2<<13)>>16;
        key1 = key1Tmp;
        key2 = key2Tmp;

        key1 = (sBox(key1>>28)<<28) | (key1 & 0xfffffff);
        key2 = (key2^(c>>1));
        key3 = key3 ^ ((c&1)<<15);

        c++;
    }
    state0 = state0 ^ key1;
    state1 = state1 ^ key2;

    printf("result is:\texpected is:\n");
    printf("%x\t%x\n", state0, 0xE72C46C0);
    printf("%x\t%x\n", state1, 0xF5945049);

    return 0;
}

int sBox(int input) {


    switch(input) {
    case 0:
        return 12;
    case 1:
        return 5;
    case 2:
        return 6;
    case 3:
        return 11;
    case 4:
        return 9;
    case 5:
        return 0;
    case 6:
        return 10;
    case 7:
        return 13;
    case 8:
        return 3;
    case 9:
        return 14;
    case 10:
        return 15;
    case 11:
        return 8;
    case 12:
        return 4;
    case 13:
        return 7;
    case 14:
        return 1;
    case 15:
        return 2;
    default:
        printf("sBox failed for input %x\n", input);
    }


    return 0;

}

int sBox32(unsigned int input) {


    return sBox((input & 0xf)) +
           ( sBox(((input >> 4 ) & 0xf)) << 4 ) +
           ( sBox(((input >> 8 ) & 0xf)) << 8 ) +
           ( sBox(((input >> 12) & 0xf)) << 12 ) +
           ( sBox(((input >> 16) & 0xf)) << 16 ) +
           ( sBox(((input >> 20) & 0xf)) << 20 ) +
           ( sBox(((input >> 24) & 0xf)) << 24 ) +
           ( sBox(((input >> 28 ) & 0xf)) << 28 )  ;

}

