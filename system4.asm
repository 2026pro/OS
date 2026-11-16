org 0x7C00

start:
   xor ax, ax
   mov ds, ax
   mov es, ax
   mov ss, ax
   mov sp, 0x7C00
   jmp czysc_ekran

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
     je sprawdz_komende

     cmp al, 8
     je usun

     cmp al, 127
     je usun

     movzx bx, byte [licznik]
     mov [bufor + bx], al
     inc byte [licznik]

    
     

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

     czysc_ekran:
     mov ah, 0x06
     mov al, 0
     mov bh, 0x07
     mov cx, 0x0000
     mov dx, 0x184F
     int 0x10

     mov ah, 0x02
     mov bh, 0
     mov dh, 0
     mov dl, 0
     int 0x10
     jmp pokaz_promt

     sprawdz_dysk:
     cmp byte [licznik], 0
     je now

     pusha

     mov ah, 0x02
     mov al, 1
     mov ch, 0
     mov cl, 2
     mov dh, 0
     mov dl, 0x80

     xor ax, ax
     mov es, ax
     mov bx, 0x8000

     int 0x13
     jc .skok_dysk_blad

     mov si, 0x8000

     .skok_dysk_wyswietl:
     lodsb
     cmp al, 0
     je .skok_dysk_koniec
     mov ah, 0x0E
     int 0x10
     jmp .skok_dysk_wyswietl

     .skok_dysk_koniec:
     popa
     jmp now

     .skok_dysk_blad:
     popa
     jmp now

     sprawdz_komende:
         cmp byte [licznik], 0
         je now
         movzx bx, byte [licznik]
         mov byte [bufor + bx], 0

         mov si, bufor
         mov di, cmd_help
         call porownaj
         jc pokaz_help
         
          mov si, bufor
         mov di, cmd_cls
         call porownaj
         jc czysc_ekran


         jmp sprawdz_dysk

         pokaz_help:
             mov ah, 0x0E
             mov al, 13
             int 0x10
             mov al, 10
             int 0x10
             mov si, tekst_help
         .pentla_help:
             lodsb
             cmp al, 0
             je now
             int 0x10
             jmp .pentla_help

             porownaj:
             mov al, [si]
             mov bl, [di]
             cmp al, bl
             jne .rozne
             cmp al, 0
             je .takie_same
             inc si
             inc di
             jmp porownaj

             .rozne:
             clc 
             ret

             .takie_same:
             stc
             ret
     
licznik db 0
cmd_cls db "cls", 0
cmd_help db "help", 0
tekst_help db "komendy: cls, help", 0
tekst db ":)> ", 0
bufor times 64 db 0


times 510-($-$$)db 0
dw 0xAA55
   
        
