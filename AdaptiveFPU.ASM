format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        formatFloat db '%d.%d',0
        debugNSFormat db 10,13,'%s',0
        debugNNFormat db 10,13,'%d',0


        floatBase dd 3333
        floatDotPos db 2


        HighParticalBuffer dd ?
        LowParticalBuffer dd ?

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


        macro CalcDotPosition
        {
         movsx eax, [floatDotPos]
                mov ecx, 1
                dotpos:


                        imul ecx, 10

       

                        inc edx
                        cmp edx, eax
                 jne dotpos
                 clr edx
        }

        macro SetLPB
        {
          mov eax, [floatBase]
          div ecx

          mov [LowParticalBuffer], edx
          add [LowParticalBuffer], ecx

        }

        macro SetHPB
        {
          clr eax
          clr edx

          mov eax, [floatBase]

          div ecx

          mov  [HighParticalBuffer] , eax

        }

        macro ShowResult
        {
         push [LowParticalBuffer]
         push [HighParticalBuffer]
         push formatFloat
         call[printf]

        }

        macro ExitProgram
        {
          call[getch]

          push NULL
          call[ExitProcess]

        }





section '.code' code readable executable
        start:
                fullClr
                CalcDotPosition

                SetLPB
                SetHPB


                ShowResult



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