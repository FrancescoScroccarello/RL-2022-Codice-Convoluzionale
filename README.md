# Prova finale: reti logiche
Nel progetto si è sviluppato un modulo hardware FPGA che realizza un codice convoluzionale 1/2, cioè un codice in cui per ogni bit in ingresso ne vengono generati due in uscita, secondo la seguente specifica:
* sia U(t) il bit in ingresso al tempo t, tale per cui:
  * P1(t) = U(t) xor U(t-2)
  * P2(t) = U(t) xor U(t-1) xor U(t-2)
* l'output Y(t) sarà dato dalla concatenazione dei due, ossia:
  * Y(t) = P1(t)P2(t)

Il modulo implementato legge lo stream da memoria con indirizzamento al byte, dove la sequenza di byte è trasformata nella sequenza di bit U da trasformare e lo stream ha dimensione massima 255 byte. La quantità di parole da codificare è memorizzata nell'indirizzo 0, il primo byte della sequenza a partire dall'indirizzo 1 mentre lo stream di uscita viene memorizzato a partire dall'indirizzo 1000. Per poter accendere il modulo è necessario ricevere prima il segnale di RESET per poi iniziare la computazione quando il segnale di START è alto. È possibile fare più codifiche sequenziali, ma il nuovo stream deve aspettare che i segnali di START e DONE siano entrambi bassi. Tutti i dettagli di progetto nel report in pdf.

## Tool usati
* Linguaggio: VHDL
* Sintesi: Xilinx Vivado
* Target HW: Artix-7 FPGA xc7a200tfbg484-1
