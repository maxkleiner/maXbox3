#include <MsTimer2.h>

//-------------------------------------
// Makro: Einstiegspunkt eines Tasks mit Angabe der Startverzögerung in x Millisekunden (0...65535) nach Systemstart
#define SM_ENTRY(x) \
static unsigned int sm_time = x; \
static unsigned char sm_state = 0; \
unsigned char sm_localstate; \
unsigned char sm_repeat; \
if(sm_time > 0) sm_time--; \
if(sm_time == 0) \
{ \
   do \
   { \
      sm_localstate = 0; \
      sm_state++; \
      sm_repeat = 0;
//-------------------------------------   
   
//-------------------------------------   
// Makro: Zustandsbeginn mit Angabe der Zeitdauer in x Millisekunden (0...65535) (muss mit SM_END abgeschlossen werden)
#define SM_DURATION(x) \
sm_localstate++; \
if(sm_localstate == sm_state) \
{ \
   sm_time = x;
//-------------------------------------

//-------------------------------------
// Makro: Überprüfung einer Bedingung in einem Zustand mit Zustandswechsel bei TRUE (muss mit SM_END abgeschlossen werden)
//        wenn Bedingung y == TRUE dann wird der optionale Code bis SM_END ausgeführt und nach x Millisekunden in den nächsten Zustand des Tasks gewechselt
//        wenn Bedingung y == FALSE dann wird der optionale Code nach dem zu SM_CONDITION zugehörigen SM_END ausgeführt und der Zustand nicht gewechselt
#define SM_CONDITION(x, y) \
sm_state--; \
if(y) { sm_time = x; sm_state++;
//-------------------------------------

//-------------------------------------
// Makro: Zustandsende
#define SM_END \
break; }
//-------------------------------------

//-------------------------------------
// Makro: Ausstiegspunkt eines Tasks
#define SM_EXIT \
   sm_state = 0; \
   sm_repeat = 1; \
} while(sm_repeat); }
//-------------------------------------

//-------------------------------------
// Makro: nächsten Zustand (0...255) angeben
#define SM_SET_STATE(x) \
   sm_state = x;
//-------------------------------------

//-------------------------------------
// Makro: nächsten Zustand relativ zum aktuellen Zustand (-128...+127) angeben
#define SM_SET_STATE_RELATIVE(x) \
   sm_state = sm_state - 1 + x;
//-------------------------------------

//-------------------------------------
// Makro: Zeitdauer bis zum nächsten Zustand verändern (0...65535 ms)
#define SM_SET_DURATION(x) \
   sm_time = x;
//-------------------------------------

//-------------------------------------
// Makro: im aktuellen Zustand bleiben
#define SM_REMAIN \
   sm_state--;
//-------------------------------------


#if defined (__AVR_ATmega168__) || defined (__AVR_ATmega48__) || defined (__AVR_ATmega88__) || defined (__AVR_ATmega328P__) || (__AVR_ATmega1280__)
	#define MSTICK_INT_DISABLE  TIMSK2 &= ~(1<<TOIE2);
#elif defined (__AVR_ATmega128__)
	#define MSTICK_INT_DISABLE  TIMSK &= ~(1<<TOIE2);
#elif defined (__AVR_ATmega8__)
	#define MSTICK_INT_DISABLE  TIMSK &= ~(1<<TOIE2);
#endif


#if defined (__AVR_ATmega168__) || defined (__AVR_ATmega48__) || defined (__AVR_ATmega88__) || defined (__AVR_ATmega328P__) || (__AVR_ATmega1280__)
	#define MSTICK_INT_ENABLE  TIMSK2 |= (1<<TOIE2);
#elif defined (__AVR_ATmega128__)
	#define MSTICK_INT_ENABLE  TIMSK |= (1<<TOIE2);
#elif defined (__AVR_ATmega8__)
	#define MSTICK_INT_ENABLE  TIMSK |= (1<<TOIE2);
#endif


void init_system(void)
{
  cli();
  MsTimer2::set(1, ms_tick); // 1ms period
  MsTimer2::start();
  sei();
}


void ms_tick(void)
{
  MSTICK_INT_DISABLE;
  sei();
  
  steuerung();
  
  cli();
  MSTICK_INT_ENABLE;
}

