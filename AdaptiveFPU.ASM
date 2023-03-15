format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

	formatFloat db '%d.%d',0
	debugFormat db 10,13,'%d',0



	floatBase dd 200005
	floatDotPos db 4

	HighParticalBuffer dd ?
	LowParticalBuffer dd ?

	TextLPB Rb 8
	TextCounterX dd 100000


     NULL = 0
section '.code' code readable executable
	start:
		xor eax, eax
		xor ebx, ebx
		xor edx, edx
		xor ecx, ecx

		movsx eax, [floatDotPos]
		mov ecx, 1
		dotpos:


			imul ecx, 10



			inc edx
			cmp edx, eax
		 jne dotpos


	       mov eax, [floatBase]
	       div ecx

		mov [LowParticalBuffer], edx



		xor eax, eax
		xor edx, edx

		mov eax, [floatBase]


		div ecx


		mov  [HighParticalBuffer] , eax


		;xor ebx, ebx
		;xor edx, edx
		;xor ecx, ecx



		;setTextLPB:
		;xor eax, eax
		;mov eax, [floatBase]
		;div [TextCounterX]



		;inc edx
		;cmp edx, 6
		;jne TextLPB


		push [LowParticalBuffer]
		push [HighParticalBuffer]
		push formatFloat
		call[printf]

		push TextLPB
		push debugFormat
		call[printf]

		call[getch]

		push NULL
		call[ExitProcess]

section '.idata' import data readable

	library kernel, 'kernel32.dll',\
		msvcrt, 'msvcrt.dll'

	import kernel,\
	       ExitProcess, 'ExitProcess'

	import msvcrt,\
	       printf, 'printf',\
	       getch, '_getch',\
	       scanf, 'scanf'