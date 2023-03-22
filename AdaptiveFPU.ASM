format PE console

entry start

include 'C:\Program Files\FASM\INCLUDE\win32a.inc'

section '.data' data readable writable

	formatFloat db '%d.%d',0
	formatFloatText db '%d.%s',0
	debugNSFormat db 10,13,'%s',0
	debugNNFormat db 10,13,'%d',0


	floatBase dd 00123
	floatDotPos db 4



	HighParticalBuffer dd ?
	LowParticalBuffer dd ?

	InvertextLPB Rd 10
	TextLPB Rb 10
	charCounter dd 1
	divider db 10

	NULL = 0

	macro fullClr
	{
	 xor eax, eax
	 xor ebx, ebx
	 xor edx, edx
	 xor ecx, ecx
	}

	macro clr reg
	{
	xor reg, reg
	}


	macro CalcDotPosition dotPos
	{
	 movsx eax, [dotPos]
		mov ecx, 1
		dotpos:


			imul ecx, 10

       

			inc edx
			cmp edx, eax
		 jne dotpos
		 clr edx
		 clr eax
	} 

	macro SetLPB base , LPB
	{
	  mov eax, [base]
	  div ecx

	  mov [LPB], edx
	  add [LPB], ecx
	  clr eax
	  clr edx

	}

	macro SetHPB base , HPB
	{
	  

	  mov eax, [base]

	  div ecx

	  mov  [HPB] , eax

	}

	macro NumberLPBconvertTextLPB LPB, TextBuffer, InvertBuffer, counter
	{
	;Все регистры обнуленны
	mov eax, [LPB]
			lp:
                clr edx
        

                div dword[divider]

                


                mov [InvertBuffer+ebx], edx
                add [InvertBuffer+ebx], 48
                
                cmp eax, 1
                je nonZero
                inc [counter] 

                jmp finish
                nonZero:
                finish:

                
        	inc ebx
        	cmp ebx,[counter]
        	jne lp

				clr eax
                clr ebx
                clr ecx

                dec [counter]

                mov ebx , [counter] 
                mov ecx, 0

			wp:
                xor eax,eax
                mov eax, [InvertBuffer+ebx]
                mov dword[TextBuffer+ecx] , eax


                inc ecx
    			dec ebx
       		cmp ebx, -2
       	    jne wp
	
	
	
	}

	macro ShowResult formatP, LPB, HPB
	{
	 push LPB
	 push [HPB]
	 push formatP
	 call[printf]

	}

	

	macro ExitProgram
	{
	  call[getch]

	  push NULL
	  call[ExitProcess]
	  fullClr

	}





section '.code' code readable executable
	start:
		fullClr ; Все регистры очищенный
		CalcDotPosition floatDotPos ;Регистр eax принимает значение точки (FloatDotPos) || Регистр edx используется как счетчик
						;Макрос конвертирыет значение точки в нужный делитель  || после завершения макроса регистр ecx попадает в следующий макрос

		SetLPB floatBase, LowParticalBuffer;Код обрабатывает младщую часть float значения на вход получает регистр ecx
			   ;После выполнения очищаются регистры eax,edx

		SetHPB floatBase, HighParticalBuffer ;код вычисляет значение старшей части float значения, на входе используется регистр ecx
			   ;После работы макроса все регистры обнуляются

		NumberLPBconvertTextLPB LowParticalBuffer, TextLPB, InvertextLPB, charCounter 
			;Макрос конвертирует малдшую часть float значения в текстовую
			;Например 100.001 | в текстовом формате это 001 а в реальном : 1001


		ShowResult formatFloatText, TextLPB, HighParticalBuffer ;вывод числа в консоль
					
		



		ExitProgram


section '.idata' import data readable

	library kernel, 'kernel32.dll',\
		msvcrt, 'msvcrt.dll'

	import kernel,\
	       ExitProcess, 'ExitProcess'

	import msvcrt,\
	       printf, 'printf',\
	       getch, '_getch',\
	       scanf, 'scanf'