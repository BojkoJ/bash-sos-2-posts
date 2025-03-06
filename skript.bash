#!/bin/bash

# Funkce pro počítání slov v řetězci
count_words() {
    echo "$1" | wc -w
}

# Část A: Vytvoření adresářové struktury podle pošt splňujících kritéria
# Stažení seznamu pošt
# wget -4: vynucení použití IPv4
# -O -: výstup na standardní výstup
# 2> /dev/null: přesměrování chybového výstupu do /dev/null (skrytí chybových hlášek)
post_offices=$(wget -4 -O - http://seidl.cs.vsb.cz/download/posty.csv.txt 2> /dev/null)

# Zpracování každého řádku souboru se seznamem pošt
echo "$post_offices" | while IFS=';' read -r nazev psc adresa tel_kont tel_ved zpusobobs; do
    # Přeskočení hlavičkového řádku
    if [ "$nazev" = '"NAZPOSTY"' ]; then
        continue
    fi
    
    # Odstranění uvozovek z polí
    nazev=${nazev//\"/}
    adresa=${adresa//\"/}
    
    # Kontrola, zda adresa obsahuje "/" a neobsahuje "s" nebo "S"
    if [[ "$adresa" == */* && "$adresa" != *[sS]* ]]; then
        # Nahrazení mezer podtržítky v názvu pošty
        dir_name="${nazev// /_}"
        
        # Vytvoření adresáře
        mkdir -p "$dir_name"
    fi
done

# Poslední příkaz první části podle zadání
ls -la . | head
echo "Konec první části skriptu."

# Část B: Vytváření souborů OB.txt
# Opětovné stažení seznamu pošt pro zpracování v části B
post_offices=$(wget -4 -O - http://seidl.cs.vsb.cz/download/posty.csv.txt 2> /dev/null)

# Asociativní pole pro ukládání informací o již vytvořených souborech OB.txt
declare -A created_files

# Zpracování každého adresáře vytvořeného v části A
for dir in */; do
    if [ -d "$dir" ]; then
        # Odstranění lomítka z konce názvu adresáře
        dir_name="${dir%/}"
        
        # Počítání slov v názvu adresáře (nejprve nahrazení podtržítek mezerami)
        dir_words=$(count_words "${dir_name//_/ }")
        
        # Pokud již máme soubor pro tento počet slov, zkopírujeme ho
        if [ -n "${created_files[$dir_words]}" ]; then
            cp "${created_files[$dir_words]}" "${dir}OB.txt"
        else
            # Vytvoření souboru OB.txt v adresáři
            > "${dir}OB.txt"
            
            # Nalezení pošt se stejným počtem slov a zápis do OB.txt
            echo "$post_offices" | while IFS=';' read -r nazev psc adresa tel_kont tel_ved zpusobobs; do
                # Přeskočení hlavičkového řádku
                if [ "$nazev" = '"NAZPOSTY"' ]; then
                    continue
                fi
                
                # Odstranění uvozovek z pole nazev
                nazev=${nazev//\"/}
                
                # Počítání slov v názvu pošty
                name_words=$(count_words "$nazev")
                
                # Pokud se počty slov shodují, přidání do OB.txt
                if [ "$name_words" -eq "$dir_words" ]; then
                    echo "$nazev" >> "${dir}OB.txt"
                fi
            done
            
            # Uložení cesty k vytvořenému souboru do asociativního pole
            created_files[$dir_words]="${dir}OB.txt"
        fi
    fi
done

# Poslední příkazy části B podle zadání
cat $(ls | head -n 1)/*.txt
cat $(ls | tail -n 1)/*.txt
echo "Konec druhé části skriptu."