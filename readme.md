## SOS 2: Bash Script

-   Soubor skriptu bude začínat řádkem:
    `#!/bin/bash`

-   Pokud bude použitý příkaz používat parametry, v komentáři bude popsán význam parametrů.
    Příklad:

```
cat /etc/passwd | grep -v -A 1 bash
# grep -v invertuje výběr
# -A 1 najde i řádek nad
```

-   Bod **b)** bude procházet vytvořenou adresářovou strukturu. Nebude tedy přejímat názvy adresářů z první části.

Stažení souboru a vypsání na standardní výstup:
`wget -4 -O - http://seidl.cs.vsb.cz/download/seznam-obci-cr.txt 2> /dev/null`

### Zadání:

**a)** Ve vašem serveru v adresáři ze kterého se spouští skript by skript měl vytvořit adresářovou strukturu kde název adresářů bude
odpovídat názvům všech pošt v ČR jejíž adresa obsahuje znak "/" a neobsahuje znak "s" nebo "S".
Případné mezery se nahradí podtržítky. Seznam pošt v ČR v textové podobě najdeme zde: http://seidl.cs.vsb.cz/download/posty.csv.txt
Jako poslední příkaz první části skriptu bude: `ls -la . | head; echo "Konec první části skriptu.".`

**b)** Druhá část bude kód, který v každém adresáři vytvoří soubor `OB.txt`
a do tohoto souboru zapíše názvy všech pošt, které se skládají ze stejného počtu slov jako adresář ve kterém se nacházíme.
Na konci skriptu bude příkaz: `cat $(ls | head -n 1)/_.txt; cat $(ls | tail -n 1)/_.txt; echo "Konec druhé části skriptu.".`
