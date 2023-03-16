format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        formatFloat db '%d.%d',0
        debugFormat db 10,13,'%d',0



        floatBase dd 11200007
        floatDotPos db 4

        HighParticalBuffer dd ?
        LowParticalBuffer dd ?
  
  FloatTextBase Rb 8
  TextVar dd 1000000


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


     NULL = 0
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