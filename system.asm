org 0x7C00

start:
   xor ax, ax
   mov ds, ax
   mov es, ax

   mov si, tekst

   pokaz_promt:
   
   mov byte [licznik], 0
   mov si, tekst
   
   wpisz:
     lodsb
     cmp al, 0
     je sluchaj
     mov ah, 0x0E
     int 0x10
     jmp wpisz

     sluchaj:
     mov ah, 0x00
     int 0x16

     cmp al, 13
     je now

     cmp al, 8
     je usun

     cmp al, 127
     je usun

     inc byte [licznik]
     mov ah, 0x0E
     int 0x10
     jmp sluchaj
     

   mov ah, 0x0E
   int 0x10
   jmp sluchaj

     usun:
     cmp byte [licznik], 0
     jle nie_kasuj
    mov ah, 0x03
    mov bh, 0
    int 0x10

     sprawdz_brzeg:
     cmp dl, 0
     jne skasuj_zwykle

     mov dl, 79
     mov ah, 0x02
     int 0x10

     dec dh
     cmp dh, 255
     jne ustaw_kursor
     mov dh, 0

     ustaw_kursor:
     mov dl, 79
     mov ah, 0x02
     int 0x10
     
     mov ah, 0x0E
     mov al, 32
     int 0x10

     mov ah, 0x02
     mov dl, 79
     int 0x10

     dec byte [licznik]
     jmp sluchaj
     
     skasuj_zwykle:

       dec byte [licznik]
       mov ah, 0x0E
       mov al, 8
       int 0x10
       mov al, 32
       int 0x10
       mov al, 8
       int 0x10
       jmp sluchaj

     nie_kasuj:
         jmp sluchaj
         
     now:
     mov ah, 0x0E
     mov al, 13
     int 0x10
     mov al, 10
     int 0x10
     jmp pokaz_promt

licznik db 0

tekst db ":)> ", 0


times 510-($-$$)db 0
dw 0xAA55
   
        
