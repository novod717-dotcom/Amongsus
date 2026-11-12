# Among Us Style — PS3 (HEN/CFW)

Port **reescrito em C (PSL1GHT)** do clone Unity 6. Unity não exporta para PS3, então
o jogo foi refeito: mapa Astra (11 salas, 16 corredores, spawns e mesa vêm do JSON do projeto),
você + 5 bots, 1 impostor aleatório, tarefas, kill, reportar corpo, reunião e votação.
Não portado: multiplayer (Photon), sabotagens, vents, arte/sprites originais, áudio.

## Compilar o .pkg (PC Linux/WSL/macOS com ps3toolchain)
    export PS3DEV=/usr/local/ps3dev
    export PSL1GHT=$PS3DEV
    export PATH=$PATH:$PS3DEV/bin:$PS3DEV/ppu/bin
    make pkg           # gera amongus_ps3.pkg
Instale o .pkg via Package Manager (HEN) ou copie para /dev_hdd0/packages e use Install Package Files.

## Controles
Analógico esq./D-pad mover · X (segurar) tarefa · Quadrado matar (impostor) · Triângulo reportar · Círculo botão de emergência (mesa) · Cima/Baixo + X votar.

## Teste no PC (sem PS3)
    gcc -O2 -o host source/main_host.c source/game.c -lm && ./host
